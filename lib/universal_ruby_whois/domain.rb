require File.dirname(__FILE__) + '/server'
require 'time'

module Whois

  class Domain

    # The domain name, lower case, no spaces.
    attr_reader :domain

    # The TLD server being used for this domain.
    attr_reader :server_tld_key

    # The cached output from a whois request for this domain.
    attr_reader :whois_output

    # Look up a domain name.  If a proper whois server can not be found for this domain name's extension,
    # it will return nil.  Otherwise it returns a Whois::Domain object.
    #
    # Note: the preferred way to call this method is through the wrapper:
    #
    #   Whois.find(domain)
    def self.find(domain)
      ::Whois::Server.find(domain)
    end

    def initialize(domain, server_tld_key = nil) #:nodoc:
      @domain, @server_tld_key = domain.to_s.strip.downcase, server_tld_key
    end

    # Returns the Whois::Server object for this domain name.
    def server
      Whois::Server.list[@server_tld_key] rescue nil
    end

    # The set of regular expressions that will be used in matching this domain's whois output.
    def regexes
      server.regexes rescue {}
    end

    # Does this object have a domain name set?
    def has_domain?
      return false if domain.nil?
      (domain.to_s =~ /\w/) ? true : false
    end

    # Does this domain have a server which is available?
    def has_available_server?
      server && !(server.unavailable? rescue true)
    end

    # Does this domain have sufficient info to perform a lookup?
    def has_domain_and_server?
      has_domain? && has_available_server?
    end
    alias_method :valid?, :has_domain_and_server?

    # The raw whois server output obtained when looking up this domain.
    def whois_output
      return @whois_output if !@whois_output.blank?
      @whois_output = has_domain_and_server? ? server.raw_response!(domain) : ''
    end

    # The domain name's current registration status:
    # <tt>:registered</tt> The domain name is registered.
    # <tt>:free</tt> The domain name is not registered (available).
    # <tt>:error</tt> There was an error looking up the domain name.
    # <tt>:unknown</tt> The domain name status could not be determined.
    def status
      return :unknown unless has_domain_and_server?
      return @status unless @status.blank?
      [ :registered, :free, :error ].each do |status|
        #return status if Regexp.new(regexes[status].source, 5).match(res)
        return(@status = status) if regexes[status].match_with_inversion(whois_output)
      end
      return @status = :unknown
    end

    # Is this domain available?  Returns true/false.
    def available?
      return nil unless has_domain_and_server?
      status == :free
    end

    # Is this domain name registered?  Returns true/false.
    def registered?
      return nil unless has_domain_and_server?
      status == :registered
    end

    # Returns a Time object representing the date this domain name was created.
    def creation_date
      return nil unless has_domain_and_server?
      return @creation_date unless @creation_date.blank?
      if regexes[:creation_date] && (regexes[:creation_date] =~ whois_output)
        @creation_date = (Time.local(*ParseDate.parsedate($2)) rescue nil)
      end
      @creation_date
    end

    # Depreciated.  Use creation_date instead.
    alias_method :created_date, :creation_date

    # Do we know the creation date for this domain?
    def creation_date_known?
      creation_date.kind_of?(Time)
    end


    # Returns a Time object representing the date this domain name is set to expire.
    def expiration_date
      return nil unless has_domain_and_server?
      return @expiration_date unless @expiration_date.blank?
      if regexes[:expiration_date] && (regexes[:expiration_date] =~ whois_output)
        @expiration_date = (Time.local(*ParseDate.parsedate($2)) rescue nil)
      end
      @expiration_date
    end

    # Do we know the expiration date for this domain?
    def expiration_date_known?
      expiration_date.kind_of?(Time)
    end

    def to_s
      domain.to_s rescue nil
    end
    def to_hash
      {
        :status => self.status,
        :creation_date => self.creation_date,
        :expiration_date => self.expiration_date,
        :output => self.whois_output
      }
    end
    def to_json
      self.to_hash.to_json
    end
    def to_xml
      self.to_hash.to_xml
    end
  end

end

