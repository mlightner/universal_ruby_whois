require 'test/unit'
require File.dirname(__FILE__) + '/../lib/universal_ruby_whois'

class WhoisTest < Test::Unit::TestCase

  def test_unavailable
    domain = Whois::Server.find("google.com")
    assert !domain.available?
    assert domain.registered?
  end

  def test_available
    domain = Whois::Server.find("j983jf89ej2e09d2jd.com")
    assert domain.available?
    assert !domain.registered?
  end

  def test_creation_date
    domain = Whois::Server.find("google.com")
    domain.created_date == Time.local(*ParseDate.parsedate("1997-09-15"))
  end

end
