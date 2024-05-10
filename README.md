# Google Translate Free

This repository is a robust translation service designed to help you with a variety of language-based features including direct translations, alternate translations, definitions, examples, transliterations, spelling suggestions, language detection, and highly relevant keyword suggestions.

Let's read the [documents](https://api.datpmt.com) before using it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google-translate-free', '~> 0.0.2'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install google-translate-free

## Usage
To translate
```ruby
Translate.translate('summer', :vi, :en)
# => "mùa hè"
```
Without third params, Google Translate will auto-detect your source language.
```ruby
Translate.translate('summer', :vi)
# => "mùa hè"
```
For definitions
```ruby
Translate.definitions('summer')
# =>
#[
#  {
#    :noun=>[
#      ["The warmest season of the year, in the northern hemisphere from june to august and in the southern hemisphere from december to february.", "<b>summer</b> vacation.", nil],
#      ["A horizontal bearing beam, especially one supporting joists or rafters.", nil, nil]
#    ]
#  },
#  {
#    :verb=>[
#      ["Spend the summer in a particular place.", nil, nil]
#    ]
#  }
#]
```
For examples
```ruby
Translate.examples('summer')
# =>
#[
#  "The plant flowers in late <b>summer</b>.",
#  "The golden <b>summer</b> of her life.",
#  "A long hot <b>summer</b>.",
#  "<b>summer</b> vacation."
#]
```
For transliteration
```ruby
Translate.transliteration('summer')
# => "ˈsəmər"
```
For spelling suggestions
```ruby
Translate.suggest('summmer')
# => "summer"
```
For language detection
```ruby
Translate.detection('summer')
# => ["en", 0.93254006]
```
For keyword suggestions
```ruby
Translate.see_more('summers')
# => "summer"
```

## Contributors

- [datpmt](https://github.com/datpmt)

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
