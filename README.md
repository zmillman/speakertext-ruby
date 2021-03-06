speakertext-ruby
================

An unofficial SpeakerText gem.

This gem wraps SpeakerText's [Version 1 API](https://api.speakertext.com/v1) for submitting files for transcription.

IMPORTANT: This gem is still under development and has not really been tested.

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
  config.api_key = '1234567890abcdef1234567890abcdef12345678'               # required
  config.default_pingback_url = 'http://my_app.com/api/transcript_receiver' # optional
end
```

Get your API key from the [SpeakerText account page](http://speakertext.com/account).

Example Usage
-------------

```ruby
%w(rubygems speakertext).each {|lib| require lib}

SpeakerText.configure do |config|
	config.api_key = 'YOUR_API_KEY_HERE'
end

# Define a source from a platform (YouTube, in this example)
s = SpeakerText::Source.new({
  :platform => "youtube",
  :video_id => "http://www.youtube.com/watch?v=_OBlgSz8sSM"
})

# Define a source from a saved transcript_id
s = SpeakerText::Source.new({
  :transcript_id => 'TnXuza158n'
})

# Define a source from a URL
source = SpeakerText::Source.new({
  :title => "How To Skin A Cat",
  :url => "http://example.com/videos/cat_skinning_tutorial.mp4",
  :annotation => "Dear transcriber, do not be alarmed. No animals were harmed." # optional
})

# Submit source for transcription
source.transcribe!
source.transcript_id # => "TnXuza158n"

# Fetch a transcript
t = source.transcript(:format => 'html') # Returns the html version (for CaptionBox)
t = source.transcript(:format => 'txt')  # Returns the txt version of the transcript

# Check the status of a transcript
t.in_progress? # Returns true if the transcription isn't finished
t.completed?   # Returns true if the transcript is finished

# Read a transcript
t.content # => "There are many ways to skin a cat..."

# Convert to a Tempfile (for sending to Paperclip)
t.to_file # => #<File:/var/fo...gn/T/transcript20120923-3416-xtmolj.txt>

```

Contributing
------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the [issue tracker](http://github.com/zmillman/speakertext-ruby/issues) to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.

Copyright
---------

Copyright (c) 2012 Zach Millman. See LICENSE.txt for
further details.
