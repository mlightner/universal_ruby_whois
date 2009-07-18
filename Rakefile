require 'rubygems'
# Gem::manage_gems is deprecated

require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/contrib/rubyforgepublisher'

PKG_NAME        = 'universalwhois'

specfile = File.read(File.dirname(__FILE__) + '/universal_ruby_whois.gemspec')
eval(specfile, binding)

desc 'Default: run unit tests.'
task :default => :test

desc 'Run unit tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*.rb'
  t.verbose = true
end

desc 'Generate documentation for universal_ruby_whois.'
Rake::RDocTask.new do |rd|
  rd.rdoc_dir = 'html'
  rd.rdoc_files.include("README.rdoc", "LICENSE", "lib/**/*.rb")
  rd.main = "README.rdoc"
  rd.title    = "#{PKG_NAME} -- A universal WHOIS output parser for Ruby."
  rd.options << "--all"
end

Rake::GemPackageTask.new(GEM_SPEC) do |pkg|
  pkg.need_tar = true
end

desc "Publish the API documentation"
task :pdoc => [:rdoc] do
  Rake::RubyForgePublisher.new(RUBY_FORGE_PROJECT, RUBY_FORGE_USER).upload
end

desc 'Publish the gem and API docs to RubyForge'
task :publish => [:pdoc, :rubyforge_upload]

desc 'Publish the current version to GitHub.'
task :github do
  require 'readline'
  message = Readline::readline('Describe changes: ')
  raise "Couldn't add current changes." unless system("git add .")
  raise "Couldn't commit changes with message." unless system("git", "commit", "-m", message)
  raise "Couldn't push changes to GitHub." unless system("git push origin master")
  puts "Changes published to GitHub."
end

desc "Publish the release files to RubyForge."
task :rubyforge_upload => :package do
  files = %w(gem tgz).map { |ext| "pkg/#{PKG_FILE_NAME}.#{ext}" }

  if RUBY_FORGE_PROJECT then
    require 'net/http'
    require 'open-uri'
    require 'rubyforge'

    packages = %w( gem tgz zip ).collect{ |ext| "pkg/#{PKG_FILE_NAME}.#{ext}" }

    project_uri = "http://rubyforge.org/projects/#{RUBY_FORGE_PROJECT}/"
    project_data = open(project_uri) { |data| data.read }
    group_id = project_data[/[?&]group_id=(\d+)/, 1]
    raise "Couldn't get group id" unless group_id

    system("rubyforge login")
    system("rubyforge add_release #{group_id} 9557 #{PKG_VERSION} pkg/#{PKG_FILE_NAME}.tgz")
    true
  end
end


