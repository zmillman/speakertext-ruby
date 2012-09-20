speakertext-ruby
================

An unofficial SpeakerText gem. This description is just a draft of the eventual functionality. Nothing works yet.

This is an unofficial SpeakerText rubygem. It wraps SpeakerText's [Version 1 API](https://api.speakertext.com/v1).

Installation
------------

<!-- ```bash
gem install speakertext
``` -->

Or, add the speakertext gem to your project's Gemfile.rb:

```ruby
gem 'speakertext', :git => "git://github.com/zmillman/paperclip-normalize.git"
```

Then from your project's root, run:

```bash
bundle
```

If you're using SpeakerText in a rails app, drop this into `config/initializers/speakertext.rb`:

```ruby
SpeakerText.configure do |config|
  config.api_key = '1234567890abcdef1234567890abcdef12345678'     # required
end
```

Get your API key from the [SpeakerText account page](http://speakertext.com/account).

Example Standalone Usage
------------------------

```ruby
%w(rubygems speakertext).each {|lib| require lib}

SpeakerText.configure do |config|
	config.api_key = 'YOUR_API_KEY_HERE'
end

# Fetch a transcript
SpeakerText.transcripts.get_transcript(123, :format => :srt)

```

Contributing
------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the [issue tracker](http://github.com/zmillman/speakertext-ruby/issues) to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.

== Copyright

Copyright (c) 2012 Zach Millman. See LICENSE.txt for
further details.

