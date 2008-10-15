require 'test/unit'
require File.dirname(__FILE__) + '/../lib/universal_ruby_whois'

class StringTest < Test::Unit::TestCase

  def test_interpolation
    s = "hello __REPLACEME__ end"
    assert_equal "hello __REPLACEME__ end", s
    s2 = s.interpolate("__REPLACEME__" => "a value")
    assert_equal "hello a value end", s2
  end

end
