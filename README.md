# hiera-browser

The MVP is something like: a tool that will simply make an admin aware of what values a node can expect to retrieve from hiera.

## bootstrapping

There is real live (fake) test data so you can get a demo up and running fairly quickly:

```
bundle install
bundle exec rake demo
```

## live data

**PLEASE DON'T DO THIS** as I'm not 100% sure this won't break your production puppet master. 

Until I publish this gem, you can build it yourself to test on live data:

```
git clone git@github.com:dhgwilliam/hiera-browser.git
gem build hiera-browser.gemspec
gem install hiera-browser*.gem
hiera-browser
```

as of right now, this runs hiera-browser as a totally exposed web server, so be careful

# testing

NOTE: as above, this will install the FOSS `puppet` gem, so be careful

```
cd hiera-browser
bundle install
bundle exec rake cucumber
```
