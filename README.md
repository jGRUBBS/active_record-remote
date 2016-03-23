# ActiveRecord::Remote

This gem is a work in progress. The goal is to create a library that allows Ruby wrappers to be agnostic of the communication method. SOAP, XML, JSON, and Flat File all can be written in a similar format. To see a working example for a SOAP API [jGRUBBS/rlm_logistics](https://github.com/jGRUBBS/rlm_logistics).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record-remote'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record-remote

## TODO
- [ ] implement for JSON
- [ ] implement for Flat File
- [ ] implement Rspec

## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_record-remote/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
