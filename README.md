# RequireProf

Inspired by https://github.com/schneems/derailed_benchmarks

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'require_prof'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install require_prof

## Usage

RequireProf profile some require like

```ruby
result = RequireProf.profile do
  require 'mime-types'
end
```

or just using start/stop without block

```ruby
RequireProf.start
require 'mime-types'
result = RequireProf.stop
```   
    
### Printers
    
```ruby
printer = RequireProf::TreePrinter.new(result)
printer.print
# or with extra options
printer.print(output: STDOUT, precision: 3)
```
    
    
```
.
└── mime-types (136.68 ms, 13172 kb)
    └── mime/types (132.64 ms, 13172 kb)
        ├── mime/type (9.84 ms, 408 kb)
        │   ├── mime (0.4 ms, 0 kb)
        │   └── json (6.12 ms, 408 kb)
        │       ├── json/common (3.28 ms, 0 kb)
        │       │   ├── json/version (0.23 ms, 0 kb)
        │       │   └── json/generic_object (1.22 ms, 0 kb)
        │       │       └── ostruct (0.78 ms, 0 kb)
        │       ├── json/version (0.04 ms, 0 kb)
        │       └── json/ext (2.09 ms, 408 kb)
        │           ├── json/common (0.02 ms, 0 kb)
        │           ├── json/ext/parser (0.92 ms, 112 kb)
        │           └── json/ext/generator (0.41 ms, 32 kb)
        ├── mime/types/cache (0.69 ms, 0 kb)
        ├── mime/types/loader (1.31 ms, 0 kb)
        │   └── mime/types/loader_path (0.2 ms, 0 kb)
        └── json (0.02 ms, 0 kb)
```
    
    
```ruby
printer = RequireProf::TablePrinter.new(result)
printer.print 
# or with extra options 
printer.print(output: STDOUT, sort: :memory, precision: 1, threshold: 100)
printer.print(output: STDOUT, sort: :time, precision: 3, threshold: 5)
```
    
    
```
+------------------------+-----------+-------------+
|          name          | time (ms) | memory (kb) |
+------------------------+-----------+-------------+
| mime/types             | 105.92    | 13304.0     |
| mime-types             | 3.94      | 0.0         |
| mime/type              | 3.02      | 260.0       |
| json/common            | 1.8       | 0.0         |
| mime/types/loader      | 1.02      | 0.0         |
| json/ext               | 0.93      | 0.0         |
| json/ext/parser        | 0.86      | 248.0       |
| ostruct                | 0.85      | 0.0         |
| json                   | 0.58      | 0.0         |
| mime/types/cache       | 0.51      | 0.0         |
| json/generic_object    | 0.46      | 0.0         |
| json/ext/generator     | 0.37      | 32.0        |
| mime                   | 0.32      | 0.0         |
| json/version           | 0.21      | 0.0         |
| mime/types/loader_path | 0.17      | 0.0         |
+------------------------+-----------+-------------+
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/Locke23rus/require_prof/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
