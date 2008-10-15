require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'


Rake::TestTask.new do |t|
  t.test_files = FileList.new('test/*.rb')
  t.verbose = true
end

Rake::RDocTask.new do |rd|
  rd.rdoc_files.include("README.rdoc", "LICENSE", "lib/**/*.rb")
  rd.main = "README.rdoc"
end

task :default => [:test]
