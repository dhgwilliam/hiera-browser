# hiera-browser

[![Gem Version](https://badge.fury.io/rb/hiera-browser.svg)](http://badge.fury.io/rb/hiera-browser)
[![Inline docs](http://inch-ci.org/github/dhgwilliam/hiera-browser.png?branch=master)](http://inch-ci.org/github/dhgwilliam/hiera-browser)
[![Code Climate](https://codeclimate.com/github/dhgwilliam/hiera-browser.png)](https://codeclimate.com/github/dhgwilliam/hiera-browser)


`hiera-browser` is a tool that simply makes an admin aware of what values a node can expect to retrieve from hiera.

# installing

For open source puppet:

```
gem install hiera-browser
HIERA_YAML=$(puppet master --configprint hiera_config) hiera-browser
```

For PE:

```
/opt/puppet/bin/gem install hiera-browser
HIERA_YAML=$(/opt/puppet/bin/puppet master --configprint hiera_config) /opt/puppet/bin/hiera-browser
```

as of right now, this runs `hiera-browser` as a totally exposed web server, so be careful

# testing

NOTE: as above, this will install the FOSS `puppet` gem, so be careful

```
bundle install
bundle exec rake cucumber
bundle exec rake rspec
```

or, alternatively, if you're actively developing against `hiera-browser`, it might be worthwhile to run `guard`:

```
bundle exec guard
```

This will launch a `guard` process that should run tests whenever you save classes or spec tests.

# demoing

There is real live (fake) test data so you can get a demo up and running fairly quickly:

```
bundle install
bundle exec rake demo
```

