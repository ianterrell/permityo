# encoding: UTF-8
require 'rake'
require 'rake/rdoctask'
require 'rake/gempackagetask'

require 'rspec/core'
require 'rspec/core/rake_task'

Rspec::Core::RakeTask.new(:spec)

task :default => :spec

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Permit, Yo'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

spec = Gem::Specification.new do |gem|
  gem.name = "permit_yo"
  gem.summary = "A Rails 3 engine for managing authorization."
  gem.description = "An engine that provides authorization for Rails 3 apps."
  gem.email = "ian.terrell@gmail.com"
  gem.homepage = "http://github.com/ianterrell/permityo"
  gem.authors = ["Bill Katz", "Ian Terrell"]
  gem.files = Dir["{lib}/**/*.rb", "{app}/**/*", "{config}/**/*"]
  gem.version = "2.1.1"
end

Rake::GemPackageTask.new(spec) do |pkg|
end

desc "Install the gem #{spec.name}-#{spec.version}.gem"
task :install do
  system("gem install pkg/#{spec.name}-#{spec.version}.gem --no-ri --no-rdoc")
end
