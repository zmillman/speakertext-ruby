require File.expand_path("../lib/speakertext/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'speakertext'
  s.version     = SpeakerText::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2012-09-19'
  s.summary     = "An unofficial SpeakerText gem"
  s.description = "An unofficial gem for interacting with the SpeakerText API"
  s.authors     = ["Zachary Millman"]
  s.email       = 'zach@magoosh.com'
  s.files       = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path
  s.homepage    = 'http://github.com/zmillman/speakertext-ruby'
  
  # Dependencies
  s.add_dependency 'addressable', '>=2.2.4'
end