module Whois

  class Server
    @@whois_bin = `which whois`.gsub(/\s/, '')

    attr_accessor :tld, :nic_server, :regexes, :port

    def initialize(tld, nic_server = nil, options = {})
      @tld = tld
      @response_cache = Hash.new("")
      @nic_server = nic_server
      @port = options.delete(:port)
      @regexes = options.reverse_merge(
        :free => /(avail|free|no match|no entr|not taken|not registered|not found)/im,
        :registered => /(registered|Domain ID|domain name\s*\:|is active|is not available|exists|\bregistrant\b|Created on)/im,
        :created_date => /(Creation date|created on|created at|Commencement Date|Registration Date)\s*[\:\.]*\s*([\w\-\:\ ]+)[^\n\r]*[\n\r]/im,
        :error => /(error)/im
        )
    end

    # Class variable accessors
    def self.list
      @@list ||= Hash.new
    end

    def self.list=(value)
      @@list = value
    end

    def self.domain_object_cache
      @@domain_object_cache ||= Hash.new
    end

    def self.domain_object_cache=(value)
      @@domain_object_cache = value
    end

    def self.defined_tlds
      self.list.collect {|tld,server| tld.gsub(/^\./, '') }
    end

    # Find a TLD from a full domain name.  There is special care to check for
    # two part TLD's (such as .co.uk, .kids.us, etc) first and then to look for
    # the last part alone.
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

    def self.find(domain)
      domain = domain.to_s.strip.downcase
      return domain_object_cache[domain] unless domain_object_cache[domain].blank?
      return nil unless server = server_for_domain(domain)
      domain_object_cache[domain] = Whois::Domain.new(domain, server.tld)
    end

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

    def raw_response(domain)
      return @response_cache[domain] if !@response_cache[domain].blank?
      @response_cache[domain] = ""
      if nic_server =~ /^http/
        url = nic_server.gsub(/\%DOMAIN\%/, domain)
        @response_cache[domain] = Net::HTTP.get_response(URI.parse(url)).body
      else
        command = "#{@@whois_bin} #{('-h ' + @nic_server) unless @nic_server.blank?} #{self.class.shell_escape(domain)} 2>&1"
        @response_cache[domain] = Whois::Server.run_command_with_timeout(command, 10, true)
      end
      @response_cache[domain]
    end

    def self.define_from_iana(tld)
      iana_out = run_command_with_timeout("#{@@whois_bin} -h whois.iana.org #{shell_escape(tld.to_s)} 2>&1", 10, false)
      return false if iana_out.blank?
      return false unless iana_out =~ /Whois\s+Server\s+\(port ([\d]+)\)\: ([\w\-\.\_]+)/im
      port = $1
      server = $2
      define_single(tld.to_s, server, :port => port)
    end

    def self.define_single(*args, &block)
      new_server = allocate
      new_server.send(:initialize, *args, &block)
      list[args.first.to_s] = new_server
      new_server
    end

    def self.define(*args, &block)
      tld_list = args.shift
      tld_list = tld_list.kind_of?(Array) ? tld_list : [tld_list]
      tld_list.each do |tld|
        define_single(*args.clone.unshift(tld.to_s), &block)
      end
      tld_list
    end

    def self.run_command_with_timeout(command, timeout = 10, do_raise = false)
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
      @output
    end

    def self.shell_escape(word)
      word.to_s.gsub(/[^\w\-\_\.]+/, '')
    end

  end # class Server

end

