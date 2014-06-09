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

FanSQS integrates seemlessly with your Rails applications. Just *include* the module **FanSQS::Worker** in the class that encapsulates your job logic and define a class method called *perform*. The method *perform* should be able to accept any number of parameters of any type.

```ruby
class MessagePublisher
  include FanSQS::Worker       
  set_fan_sqs_options queue: :message_queue # use the key :queue to define the message queue name

  def self.perform(arg1, arg2, ...)
    # code to do work
  end
end
```

To push jobs into an SQS queue for processing, simply call:

```ruby
MessagePublisher.perform_async(arg1, arg2, ...)
```

To start polling for jobs, simply call either one of the following commands:

```bash
> rake FanSQS:start_polling
> bundle exec rake FanSQS:start_polling # alternative
```

## Running tests

In the command line, run this command to return the number of specs passed & failed. All tests should pass :)

```bash
> rspec
```

## Features to add

1. Rake task to start polling for specific queues
2. Priority queues
3. Auto retries on error
4. Hook up to Travis

## Contributing

1. Fork it ( http://github.com/<my-github-username>/FanSQS/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Test coverage for your changes. Sorry I will not merge changes without test coverage!
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
