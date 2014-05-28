# Oltor

This is the first idea. Not finished yet.

## Installation

Add this line to your application's Gemfile:

    gem 'oltor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oltor

OpenLoad must be installed on the system

	sudo apt-get install openload

## Usage
	
	oltor do |load|
		load.url = "http://your_url_to_request"
		load.max = 10
		load.report = true
	end




## Contributing

1. Fork it ( http://github.com/<my-github-username>/oltor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
