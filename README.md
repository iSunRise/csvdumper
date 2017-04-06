## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csvdumper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csvdumper

## Usage

Generate migration and model:

    $ rake csvdumper:install

Perform migrations:

    $ rake db:migrate

Dump csv file (it expects `data_dump.csv` to be in root directory of project)

    $ rake csvdumper:process

Or, manually specify file path (relative) and bulk size:

    $ rake csvdumper:process_file[myfile.csv,1000]

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

