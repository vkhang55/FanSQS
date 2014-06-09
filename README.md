# FanSQS

FanSQS is a background job processing engine for Ruby using [AWS SQS](http://aws.amazon.com/sqs/) for message storage.

## Installation

Add this line to your application's Gemfile:

    gem 'FanSQS'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install FanSQS
    
## Rails Setup

Create a **config/initializer.rb** file in your application directory and insert this line:

```ruby
AWS.config( access_key_id: '<your_access_key_id>', secret_access_key: '<your_secret_access_key>')
```

## Usage

FanSQS integrates seemlessly with your applications. 

## Contributing

1. Fork it ( http://github.com/<my-github-username>/FanSQS/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
=======
FanSQS
======
