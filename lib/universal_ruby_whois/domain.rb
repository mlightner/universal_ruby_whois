require 'time'

module Whois

  class Domain

    attr_accessor :domain, :server_tld_key, :whois_output

    def initialize(domain, server_tld_key = nil)
      @domain, @server_tld_key = domain.to_s.strip.downcase, server_tld_key
    end

    def server
      Whois::Server.list[@server_tld_key]
    end

    def regexes
      server.regexes
    end

    def whois_output
      return @whois_output if !@whois_output.blank?
      @whois_output = server.raw_response(domain) || ""
    end

    def status
      return @status unless @status.blank?
      [ :registered, :free, :error ].each do |status|
        #return status if Regexp.new(regexes[status].source, 5).match(res)
        return(@status = status) if regexes[status].match_with_inversion(whois_output)
      end
      return @status = :unknown
    end

    def available?
      status == :free
    end

    def registered?
      status == :registered
    end

    def created_date
      return @created_date unless @created_date.blank?
      if regexes[:created_date] && (regexes[:created_date] =~ whois_output)
        @created_date = (Time.local(*ParseDate.parsedate($2)) rescue nil)
      end
      @created_date
    end
  end

end

