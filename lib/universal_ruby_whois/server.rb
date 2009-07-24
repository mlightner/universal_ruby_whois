module Whois

  # = Whois::Server
  #
  # A Whois server object represents a single TLD mapped to a whois server hostname, and a set of regular expressions
  # that are used to match against the raw whois output and determine various information about the domain name (currently
  # registration status is supported on most domain TLDs, and creation date on a good number).
  class Server

    # Exception class thrown when a WHOIS server is down or unavailable.
    class Unavailable < StandardError
    end

    # The default regular expressions used when defining a new server if none are supplied.
    DEFAULT_WHOIS_REGULAR_EXPRESSIONS = {
        :free => /(avail|free|no match|no entr|not taken|Available|Status\:\sNot\sRegistered|not registered|not found|No match for domain)/im,
        :registered => /(registered|Domain ID|domain name\s*\:|is active|Status\:\sActive|Not available|is not available|exists|\bregistrant\b|Created on|created\:)/im,
        :creation_date => /(Creation date|created on|created at|Commencement Date|Registration Date|domain_dateregistered|created\:)\s*[\:\.\]]*\s*([\w\-\:\ \/]+)[^\n\r]*[\n\r]/im,
        :expiration_date => /(expiration date|expires on|registered through|Renewal date|domain_datebilleduntil|expires\:)\s*[\:\.\]]*\s*([\w\-\:\ \/]+)[^\n\r]*[\n\r]/im,
        :error => /(error)/im,
        :server_unavailable => /(Sorry\. Server busy\.|too many requests|been blocked)/im
      }

    # The location of the 'whois' binary utility.
    WHOIS_BIN = '/usr/bin/env whois'

    attr_reader :tld, :nic_server, :regexes, :port, :server_unavailable, :unavailable_response

    # === Whois Server Definition
    #
    # Define a whois server for one or more TLDs.  TLDs can be given as a single string or an array of strings representing
    # TLDs that are handled by this server.  The second argument should be a whois server hostname.  If none is given,
    # the generic output from the command line whois program is used (with any available redirection).  An optional third
    # argument is an array of regular expressions used to parse output from this particular server.  A set of relatively
    # liberal defaults is used if none (or only some) are given.  Supported regex keys are :free, :registered, :creation_date
    # and :error.
    #
    # ==== Regex Options
    # * <tt>:registered</tt> -- If this regular expression matches the whois output, this domain is considered registered.
    # * <tt>:free</tt> -- If this regular expression matches the whois output, the domain is considered available.
    # * <tt>:error</tt> -- If this regular expression matches, an error is said to have occurred.
    # * <tt>:creation_date</tt> -- If this regular expression matches, the value of the second set of parentheses is parsed
    #   using ParseDate and used as the creation date for this domain.
    #
    # Note, the preferred location for Whois::Server definitions is the server_list.rb file.  Definitions should go from
    # least specific to most specific, as subsequent definitions for a TLD will override previous ones.
    def self.define(tlds, server = nil, regexes = nil, &block)
      tlds = tlds.kind_of?(Array) ? tlds : [tlds]
      tlds.each do |tld|
        define_single(tld, server, regexes, &block)
      end
      tlds
    end

    def initialize(tld, nic_server = nil, options = nil) #:nodoc:
      @tld = tld.gsub(/^\.+/, '')
      options ||= Hash.new
      @response_cache = Hash.new("")
      @nic_server = nic_server
      @port = options.delete(:port)
      @regexes = options.reverse_merge(DEFAULT_WHOIS_REGULAR_EXPRESSIONS)
      @regexes.each do |key, rx|
        next unless rx.kind_of?(Array)
        rx2 = Regexp.new(Regexp.escape(rx.first).gsub(/\s+/, '\s*'))
        rx2 = rx2.new_options(rx[1])
        rx2 = rx2.interpolate(/\s+/, '\s+')
        rx2.invert! if ((rx[2] == true) rescue false)
        @regexes[key] = rx2
      end
    end

    # A hash of all of the known whois servers indexed by TLD
    def self.list
      @@list ||= Hash.new
    end

    def self.list=(value)
      @@list = value
    end

    def self.domain_object_cache #:nodoc:
      @@domain_object_cache ||= Hash.new
    end

    def self.domain_object_cache=(value) #:nodoc:
      @@domain_object_cache = value
    end

    # A list of strings representing all supported TLDs.
    def self.defined_tlds
      self.list.collect {|tld,server| tld.gsub(/^\./, '') }
    end

    # Find a TLD from a full domain name.  There is special care to check for two part TLDs
    # (such as .co.uk, .kids.us, etc) first and then to look for the last part alone.
    def self.find_server_from_domain(domain)
      # valid domain?
      return nil unless domain =~ /^((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})$/

      # start the searching.
      tld = nil
      parts = domain.split('.')

      # if the passed domain is more than two parts (. separated strings)
      # try to find the TLD from the last two parts (ie, .co.uk)
      if parts.size > 2
        tld_string = parts[-2,2].join('.')
        tld = self.list[tld_string]
      end

      # if nothing was found, check for a match on the last part only.
      if tld.blank?
        tld_string = parts.last
        tld = self.list[tld_string]
      end

      return nil if !tld.kind_of?(Whois::Server)
      return tld
    end

    # Look up a domain name.  If a proper whois server can not be found for this domain name's extension,
    # it will return nil.  Otherwise it returns a Whois::Domain object.
    #
    # Note: the preferred way to call this method is through the wrapper:
    #
    #   Whois.find(domain)
    def self.find(domain)
      domain = domain.to_s.strip.downcase
      return domain_object_cache[domain] unless domain_object_cache[domain].blank?
      return nil unless server = server_for_domain(domain)
      domain_object_cache[domain] = Whois::Domain.new(domain, server.tld)
    end

    # Determine the appropriate whois server object for a domain name.
    def self.server_for_domain(domain)
      server = self.find_server_from_domain(domain)
      # This will only work on single extension domains
      if server.blank? # && domain.scan(/(\.)/).length == 1
        domain =~ /\.([\w\-]+)$/
        tld = $1
        self.define_from_iana(tld)
        return false unless server = self.find_server_from_domain(domain)
      end
      server
    end

    def unavailable?
      @server_unavailable ? true : false
    end

    # Retrieve the raw WHOIS server output for a domain.
    def raw_response(domain)
      return nil if unavailable?
      return @response_cache[domain] if !@response_cache[domain].blank?
      @response_cache[domain] = ""
      if nic_server.kind_of?(Array)
        interpolate_vars = {
          '%DOMAIN%' => domain,
          '%DOMAIN_NO_TLD%' => domain.gsub(/\.#{tld.to_s}$/i, ''),
          '%TLD%' => tld
          }

        url = URI.parse(nic_server.first.dup.interpolate(interpolate_vars))
        method = nic_server[1] || :post
        req = "Net::HTTP::#{method.to_s.capitalize}".constantize.new(url.path)
        form_data = nic_server[2].dup || {}
        form_data.each { |k,v| form_data[k] = v.interpolate(interpolate_vars) }
        req.set_form_data(form_data)
        res = begin
          Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
        rescue Net::HTTPBadResponse
          nil # Ignore these for now...
        end
        @response_cache[domain] = case res
        when Net::HTTPSuccess, Net::HTTPRedirection
          res.body
        else
          ''
        end
      elsif nic_server.to_s =~ /^http/
        url = nic_server.gsub(/\%DOMAIN\%/, domain)
        @response_cache[domain] = Net::HTTP.get_response(URI.parse(url)).body
      else
        command = "#{WHOIS_BIN} #{('-h ' + @nic_server) unless @nic_server.blank?} #{self.class.shell_escape(domain)} 2>&1"
        @response_cache[domain] = Whois::Server.run_command_with_timeout(command, 10, true)
      end
      if match = regexes[:server_unavailable].match_with_inversion(@response_cache[domain])
        @server_unavailable = true
        @unavailable_response = match[1]
        nil
      else
        @response_cache[domain]
      end
    end

    def raw_response!(domain)
      res = raw_response(domain)
      if !res || !res.respond_to?(:to_s) || res.blank?
        raise Whois::Server::Unavailable, "The WHOIS server for TLD #{tld.to_s} is currently unavailable. (response: #{unavailable_response})"
      end
      res
    end

    # Used as a fallback in case no specific WHOIS server is defined for a given TLD.  An attempt will be made to search
    # the IANA global registrar database to find a suitable whois server.
    def self.define_from_iana(tld)
      iana_out = run_command_with_timeout("#{WHOIS_BIN} -h whois.iana.org #{shell_escape(tld.to_s)} 2>&1", 10, false)
      return false if iana_out.blank?
      return false unless iana_out =~ /Whois\s+Server\s+\(port ([\d]+)\)\: ([\w\-\.\_]+)/im
      port = $1
      server = $2
      define_single(tld.to_s, server, :port => port)
    end

    def self.define_single(*args, &block) #:nodoc:
      new_server = allocate
      new_server.send(:initialize, *args, &block)
      list[args.first.to_s] = new_server
      new_server
    end

    def self.run_command_with_timeout(command, timeout = 10, do_raise = false) #:nodoc:
      @output = ""
      begin
        status = Timeout::timeout(10) do
          IO.popen(command, "r") do |io|
            @output << "#{io.read.to_s}"
          end
        end
      rescue Exception => e
        if do_raise
          raise "Running command \"#{command}\" timed out."
        end
      end
      @output.strip!
      @output
    end

    def self.shell_escape(word) #:nodoc:
      word.to_s.gsub(/[^\w\-\_\.]+/, '') rescue ''
    end

  end

end
