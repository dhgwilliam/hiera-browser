# hiera-browser

This will have to be renamed.

The MVP is something like:

```
A tool that will simply make an admin aware of what values a node can expect to retrieve from hiera
```

## bootstrapping

as of right now, this is very much a dev-only toy, but you should be able to get it "working" like this:

```
vagrant up master agent --no-provision
vagrant provision master agent
vagrant ssh master
sudo -s
export PATH=$PATH:/opt/puppet/bin
cd /vagrant
ln -s /vagrant/hiera.yaml /etc/hiera.yaml
mkdir -p /etc/puppet
ln -s /vagrant/hieradata /etc/puppet/hieradata
gem install bundler
bundle install
bundle exec shotgun -Ilib -o 0.0.0.0
```

And then in a browser, open `http://<url>:9393`

## live data

As of right now, this requires the FOSS `puppet` gem, although I'm certain there is a way for me to take advantage of PE if it's already installed 
if you have a puppet master with actual `hiera.yaml`, `hieradata/`, and `$yamldir/nodes/`, I imagine deployment would go somewhat more like this:

```
git clone git@github.com:dhgwilliam/hiera-browser.git
cd hiera-browser
bundle install
HIERA_YAML=/path/to/hiera.yaml YAML_DIR=$(puppet master --configprint yamldir) bundle exec shotgun -Ilib -o 0.0.0.0
```
