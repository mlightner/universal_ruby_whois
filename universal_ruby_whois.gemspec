PKG_NAME      = 'universal_ruby_whois'
PKG_VERSION   = '1.2.7'
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
RUBY_FORGE_PROJECT = 'universalwhois'
RUBY_FORGE_USER    = 'mlightner'

GEM_SPEC = spec = Gem::Specification.new do |s| 
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.author = "Matt Lightner"
  s.email = "mlightner@gmail.com"
  s.homepage = "http://github.com/mlightner/universal_ruby_whois/tree/master"
  s.platform = Gem::Platform::RUBY
  s.summary = "A module that attempts to act as a universal WHOIS output interpreter allowing you to get information about most domain name extensions."
  s.files = %w(
    README.rdoc
    CHANGELOG.rdoc
    LICENSE
    universal_ruby_whois.gemspec
    lib/universal_ruby_whois.rb
    lib/universal_ruby_whois/server.rb
    lib/universal_ruby_whois/server_list.rb
    lib/universal_ruby_whois/domain.rb
    lib/support/extended_regexp.rb
    lib/support/string.rb
    test/whois.rb
    test/string.rb
    test/regexp.rb
    )
  s.require_path = "lib"
  s.autorequire = "name"
  s.add_dependency('activesupport', '>= 1.4.4')
  s.test_files = %w(
    test/whois.rb
    test/string.rb
    test/regexp.rb
    )    
  s.has_rdoc = true
  #s.extra_rdoc_files = ["README", "LICENSE"]
end
