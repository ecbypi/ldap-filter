# ldap-filter

While working on a Rails application that leaned heavily on my school's LDAP server, I started off writing inflexible methods like:

    def uid_filter(uid)
      "(uid=#{uid})"
    end

    def uid_or_email_filter(uid, email)
      "(|(#{uid_filter(uid)})(#{email_filter(email)}))"
    end

And decided it would be easier to do:

    filter = LDAP::Filter::Base.new :uid, 'mrhalp' # (uid=mrhalp)
    if search[:email] # mrhalp@email.org
      email = LDAP::Filter::Base.new :mail, search[:email]
      filter = filter | email
    end
    MyLDAPLibrary.search filter.to_s # (|(email=mrhalp@email.org)(uid=mrhalp))

You also don't have to worry about all those nested parentheses.

## Install

    gem install ldap-filter

With Bundler:

    gem 'ldap-filter'

## Usage

More to come soon.
