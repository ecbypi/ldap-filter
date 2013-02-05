# ldap-filter

Instead of manually building LDAP filters with strings:

```ruby
def uid_filter(uid)
  "(uid=#{uid})"
end

def uid_or_email_filter(uid, email)
  "(|(#{uid_filter(uid)})(#{email_filter(email)}))"
end
```

Construct them in a more fluent way.

```ruby
filter = LDAP::Filter.new(:uid, 'username')
filter | :email, 'username@domain.foo' # => (|(uid=username)(email=username@domain.foo))
```

## Installation

Add this line to your application's Gemfile:

    gem 'ldap-filter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ldap-filter

## Usage

Setup a filter with a key, defaulting to a presence filter. You can initialize
a filter with all values you would like to filter for. Construct the filter
using `:to_s` or `:compile`.

```ruby
filter = LDAP::Filter.new(:givenName)
filter.compile # => (givenName=*)

filter = LDAP::Filter.new(:givenName, 'Jon', 'Sara'
filter.to_s # => (|(givenName=Jon)(givenName=Sara))
```

You can later add values to the filter after initializing it:

```ruby
# Add values
filter << 'Jon'
filter << 'Sara', 'Ben'
filter.compile # => (|(givenName=Jon)(givenName=Sara)(givenName=Ben))
```

Create compound filters that filter against more than one property:

```ruby
filter | :sn
filter.to_s # => (|(|(givenName=Jon)(givenName=Sara)(givenName=Ben))(sn=*)

# OR
filter & :sn, 'Smith'
filter.to_s # => (&(|(givenName=Jon)(givenName=Sara)(givenName=Ben))(sn=Smith))

# OR
filter & LDAP::Filter.new(:sn)
```

To combine similar filters, use `:merge` or `:merge!`. Merging filters combines
the values for shared keys. Currently only works with filters having one key.

```ruby
other = LDAP::Filter.new(:giveName, 'James', 'Josh')

combined = filter.merge(other)
combined.to_s # => (|(givenName=Jon)(givenName=Sara)(givenName=Ben)(givenName=James)(givenName=Josh))
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
