Gem::Specification.new do |s|
  s.name = 'stego'
  s.version = '0.0.1'
  s.date = '2018-04-25'
  s.summary = 'Stego : The Micro-Service Communication Backbone.'
  s.description = ''
  s.authors = ['Thesaurio Team']
  s.email = 'hello@thesaur.io'
  s.files = Dir['lib/**/*']
  s.license = 'MIT'
  s.homepage = 'https://github.com/Thesaurio/stego-ruby'

  s.add_development_dependency 'simplecov', '~> 0.16.1'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'pry'

  s.add_dependency 'activesupport', '~> 5.2'
  s.add_dependency 'ruby-kafka', '~> 0.5.5'

  s.required_ruby_version = '~> 2.3'
end
