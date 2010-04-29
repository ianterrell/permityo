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
  rdoc.title    = 'Authorization'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

spec = Gem::Specification.new do |gem|
  gem.name = "constellation-authorization"
  gem.summary = "A module for managing authorization."
  gem.description = "A module for managing authorization."
  gem.email = "ian@constellationsoft.com;jeff@constellationsoft.com"
  gem.homepage = "http://github.com/constellationsoft/authorization"
  gem.authors = ["Bill Katz", "Ian Terrell", "Jeff Bozek"]
  gem.files = Dir["{lib}/**/*.rb", "{app}/**/*", "{config}/**/*"]
  gem.version = "2.0.0"
end

Rake::GemPackageTask.new(spec) do |pkg|
end

desc "Install the gem #{spec.name}-#{spec.version}.gem"
task :install do
  system("gem install pkg/#{spec.name}-#{spec.version}.gem --no-ri --no-rdoc")
end
