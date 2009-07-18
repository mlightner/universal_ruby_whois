require 'test/unit'
require File.dirname(__FILE__) + '/../lib/universal_ruby_whois'

class WhoisTest < Test::Unit::TestCase

  TEST_TLDS = %w(com org co.uk eu.com ru info jp eu tc nu co.nz no)
  REGISTERED_DOMAIN = "google"
  AVAILABLE_DOMAIN = "asdfasdfasdfcvr3rwsdc2e"

  def test_invalid_tld
    domain = Whois.find("hello.blahblah")
    assert_nil domain
  end

  def test_unavailable
    TEST_TLDS.each do |tld|
      domain = find_and_assert_domain("#{REGISTERED_DOMAIN}.#{tld}")
      assert !domain.available?, "The domain name #{domain} shows as available but should not."
      assert domain.registered?, "The domain name #{domain} does not show as registered but should."
    end
  end

  def test_available
    TEST_TLDS.each do |tld|
      domain = find_and_assert_domain("#{AVAILABLE_DOMAIN}.#{tld}")
      assert domain.available?, "The domain name #{domain} does not show as available but should."
      assert !domain.registered?, "The domain name #{domain} shows as registered but should not."
    end
  end

  def test_creation_date
    domain = find_and_assert_domain("google.com")
    assert_equal Time.local(*ParseDate.parsedate("1997-09-15")), domain.creation_date

    TEST_TLDS.each do |tld|
      domain = find_and_assert_domain("#{REGISTERED_DOMAIN}.#{tld}")
      next unless domain.creation_date_known?
      assert_kind_of Time, domain.creation_date, "Can't find creation date for domain: #{domain}"
    end
  end

  def test_expiration_date
    domain = find_and_assert_domain("google.com")
    assert_equal Time.local(*ParseDate.parsedate("2011-09-14")), domain.expiration_date

    TEST_TLDS.each do |tld|
      domain = find_and_assert_domain("#{REGISTERED_DOMAIN}.#{tld}")
      next unless domain.expiration_date_known?
      assert_kind_of Time, domain.expiration_date, "Can't find expiration date for domain: #{domain}"
    end
  end

  def test_mobi_domain
    domain = find_and_assert_domain("google.mobi")
    assert domain.expiration_date_known?
  end
  
  def test_no_domain
    domain = find_and_assert_domain("norge.no")
    assert_equal Time.local(*ParseDate.parsedate("1999-11-15")), domain.creation_date
  end

  protected

  def find_and_assert_domain(domain)
    domain_object = ::Whois.find(domain)
    assert_kind_of Whois::Domain, domain_object, "Unable to look up info for domain name: #{domain}"
    assert domain_object.valid?, "The domain name object for #{domain} is not valid (perhaps the whois server is down or busy?)"
    domain_object
  end

end
