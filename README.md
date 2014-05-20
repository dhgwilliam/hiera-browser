# hiera-browser

This will have to be renamed.

The MVP is something like:

```
A tool that will simply make an admin aware of what values a node can expect to retrieve from hiera
```

## bootstrapping

There is real live (fake) test data so you can get a demo up and running fairly quickly:

```
bundle install
bundle exec rake demo
```

## live data

**PLEASE DON'T DO THIS** as I'm not 100% sure this won't break your production puppet master. 

As of right now, this requires the FOSS `puppet` gem, although I'm certain there is a way for me to take advantage of PE if it's already installed 

if you have a puppet master with actual `hiera.yaml`, `hieradata/`, and `$yamldir/nodes/`, I imagine deployment would go somewhat more like this:

```
git clone git@github.com:dhgwilliam/hiera-browser.git
cd hiera-browser
bundle install --deployment
HIERA_YAML=/path/to/hiera.yaml YAML_DIR=$(puppet master --configprint yamldir) bundle exec shotgun -Ilib -o 0.0.0.0
```

# testing

NOTE: as above, this will install the FOSS `puppet` gem, so be careful

```
cd hiera-browser
bundle install
bundle exec rake cucumber
```
