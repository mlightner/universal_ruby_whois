require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'


Rake::TestTask.new do |t|
  t.test_files = FileList.new('test/*.rb')
  t.verbose = true
end


Rake::RDocTask.new do |rd|
  #rd.main = "README.rdoc"
  rd.rdoc_files.include("lib/*.rb", "lib/**/*.rb")
end

task :default => [:test]
