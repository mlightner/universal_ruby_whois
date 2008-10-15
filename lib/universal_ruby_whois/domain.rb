require File.dirname(__FILE__) + '/server'
require 'time'

module Whois

  class Domain

    attr_accessor :domain, :server_tld_key, :whois_output

    # Lookup a domain name.  This method returns a domain name object on which various
    # methods can be called.
    def self.find(domain)
      ::Whois::Server.find(domain)
    end

    def initialize(domain, server_tld_key = nil)
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

    def has_domain?
      return false if domain.nil?
      (domain.to_s =~ /\w/) ? true : false
    end

    # The raw whois server output obtained when looking up this domain.
    def whois_output
      return @whois_output if !@whois_output.blank?
      @whois_output = has_domain? ? server.raw_response(domain) : ''
    end

    # The domain name's current registration status:
    # <tt>:registered</tt> The domain name is registered.
    # <tt>:free</tt> The domain name is not registered (available).
    # <tt>:error</tt> There was an error looking up the domain name.
    # <tt>:unknown</tt> The domain name status could not be determined.
    def status
      return :unknown unless has_domain?
      return @status unless @status.blank?
      [ :registered, :free, :error ].each do |status|
        #return status if Regexp.new(regexes[status].source, 5).match(res)
        return(@status = status) if regexes[status].match_with_inversion(whois_output)
      end
      return @status = :unknown
    end

    # Is this domain available?  Returns true/false.
    def available?
      return nil unless has_domain?
      status == :free
    end

    # Is this domain name registered?  Returns true/false.
    def registered?
      return nil unless has_domain?
      status == :registered
    end

    # Returns a Time object representing the date this domain name was created.
    def created_date
      return nil unless has_domain?
      return @created_date unless @created_date.blank?
      if regexes[:created_date] && (regexes[:created_date] =~ whois_output)
        @created_date = (Time.local(*ParseDate.parsedate($2)) rescue nil)
      end
      @created_date
    end
    alias_method :creation_date, :created_date

    def creation_date_known?
      created_date.kind_of?(Time)
    end

    def to_s
      domain.to_s rescue nil
    end
  end

end

