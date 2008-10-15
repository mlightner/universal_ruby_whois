require 'test/unit'
require File.dirname(__FILE__) + '/../lib/universal_ruby_whois'

class RegexpTest < Test::Unit::TestCase

  def test_inversion
    r = /hi there/.invert!
    assert !r.match_with_inversion("hi there")
    r.uninvert!
    assert r.match_with_inversion("hi there")
  end

  def test_interpolation
    r = /hello __REPLACEME__ end/
    assert_equal "hello __REPLACEME__ end", r.source
    old_options = r.options
    r2 = r.interpolate("__REPLACEME__" => "a value")
    assert_equal old_options, r2.options
    assert_equal "hello a value end", r2.source
  end

end
