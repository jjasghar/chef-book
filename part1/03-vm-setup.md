The beginning of your playground
-------------------------------

So you have virtualbox and vagrant running; you feel more comfortable with your _disposable_ vm, so now here's where some of the fun starts.  I have a `Vagrantfile` here that I'm going to use as a base for this book.
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :
$script = <<SCRIPT
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
apt-get install git-core curl build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev -y
if ! [ -a /usr/local/bin/gem ]; then
  cd /tmp
  wget http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.gz
  tar -xvzf ruby-2.0.0-p247.tar.gz
  cd ruby-2.0.0-p247/
  ./configure --prefix=/usr/local
  make
  make install
  cd /tmp
  rm -rf ruby-2.0.0-p247*
fi
echo "America/Chicago" > /etc/timezone # because this is the timezone where I live ;)
dpkg-reconfigure -f noninteractive tzdata
mkdir -p /etc/chef/
if ! [ -x /opt/chef/bin/chef-solo ]; then
  curl -L https://www.opscode.com/chef/install.sh | sudo bash
fi
SCRIPT

Vagrant::Config.run do |config|
  config.vm.box = "chef-book"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.host_name = 'chef-book'

  config.vm.provision :shell, :inline => $script
end
```

As you can see it does A LOT. I build ruby as part of the process, and I install chef via the omnibus installer (which we'll talk about in the next section). Initially I want to use the `:shell` provisioner so I don't muddy the waters by adding chef-solo to the mix until we're more familiar with these new tools. With the [docs](http://docs.vagrantup.com/v2/) and some familiarity with bash scripting, you should be able to decipher what's going on here.

Don't worry, we'll add/hack on this file as we go through this book. This is just the beginning.

Put this `Vagrantfile` in a new directory, example `~/vagrant/chef-book/` and do a `vagrant up`. We will use it in step 5. You should see something like this:
```bash
[~/vagrant/chef-book] % vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
[default] Box 'chef-book' was not found. Fetching box from specified URL for
the provider 'virtualbox'. Note that if the URL does not have
a box for this provider, you should interrupt Vagrant now and add
the box yourself. Otherwise Vagrant will attempt to download the
full box prior to discovering this error.
Downloading or copying the box...
Progress:
```
After it's been pulled down, you should see vagrant report `Machine booted and ready!`. In a different terminal window, you'll be able to go into the box right then and there by changing to the same directory as the Vagrantfile and typing `vagrant ssh`. Now you should see a lot of provisioning output. That's good. Let it run, grab some coffee or energy drink, this will take 15 to 30 minutes. Vagrant will automatically attempt to provision your box after it is created for the first time, and when it is recreated after being destroyed.

Move on to [omnibus vs gem](04-omnibus-install-vs-gem-install.md)
