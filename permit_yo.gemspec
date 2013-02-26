Gem::Specification.new do |gem|
  gem.name = "permit_yo"
  gem.summary = "A Rails 3 engine for managing authorization."
  gem.description = "An engine that provides authorization for Rails 3 apps."
  gem.email = "ian.terrell@gmail.com"
  gem.homepage = "http://github.com/ianterrell/permityo"
  gem.authors = ["Bill Katz", "Ian Terrell"]
  gem.files = Dir["{lib}/**/*.rb", "{config}/**/*"]
  gem.dependencies
  gem.add_development_dependency 'rails', '~> 3.1'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency "rspec-rails", "~> 2.13.0"
  gem.add_development_dependency "rdoc"
  gem.add_runtime_dependency 'activesupport', '~> 3.0'
  gem.version = "2.1.4"
end