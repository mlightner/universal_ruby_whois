require 'rubygems'
require 'activesupport'

require 'net/http'
require 'uri'
require 'time'
require 'timeout'

require File.dirname(__FILE__) + '/universal_ruby_whois/string'
require File.dirname(__FILE__) + '/universal_ruby_whois/extended_regexp'
Regexp.class_eval do
  include MattLightner::ExtendedRegexp
end

require File.dirname(__FILE__) + '/universal_ruby_whois/domain'
require File.dirname(__FILE__) + '/universal_ruby_whois/server'
require File.dirname(__FILE__) + '/universal_ruby_whois/server_list'

module Whois

  def find(domain)
    ::Whois::Domain.find(domain)
  end
  module_function :find

end
