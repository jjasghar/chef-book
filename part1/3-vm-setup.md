The beginning of your playground
-------------------------------

So you have virtualbox and vagrant running; you feel more comfortable with your _disposable_ vm, so now here's where some of the fun starts.  I have a `Vagrantfile` here that I'm going to use as a base for this book.
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :
$script = <<SCRIPT
apt-get update
apt-get upgrade -y
apt-get install git-core curl build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev -y
if ! [ -a /usr/local/bin/gem ]; then
  cd /tmp
  wget http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p0.tar.gz
  tar -xvzf ruby-2.0.0-p0.tar.gz
  cd ruby-2.0.0-p0/
  ./configure --prefix=/usr/local
  make
  make install
  cd /tmp
  rm -rf ruby-2.0.0-p0*
fi
echo "America/Chicago" > /etc/timezone # because this is the timezone where I live ;)
dpkg-reconfigure -f noninteractive tzdata
mkdir /etc/chef/
if ! [ -a /etc/chef/client.pem ]; then
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

As you can see it does A LOT. I build ruby as part of the provisioning, also I install chef via the omnibus (which we'll talk about in the next section). Initially I want to use the `:shell` provisioning, I dont want to muddy the waters with putting chef-solo in before you can understand everything going on already. With the [docs](http://docs.vagrantup.com/v2/) you should be able to decipher most if not all of what's going on here.

Don't worry, we'll add/hack on this file as we go through this book. This is just the beginning.

You should be able to put this `Vagrantfile` in a new directory, example `~/vagrant/chef-book/` and do a `vagrant up`. You should see something like this:
```bash
[~/vagrant/chef-book] % vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
[default] Box 'vagrant' was not found. Fetching box from specified URL for
the provider 'virtualbox'. Note that if the URL does not have
a box for this provider, you should interrupt Vagrant now and add
the box yourself. Otherwise Vagrant will attempt to download the
full box prior to discovering this error.
Downloading or copying the box...
Progress:
```
After it's been pulled down, you should see that the machines is `Machine booted and ready!`. You'll be able to go into the box right then and there by `vagrant ssh` or you can `vagrant provision`.
Then you should see a lot of provisioning text. That's good. Let it run, grab some coffee, or energy drink, what ever is your fancy. I also noticed that my terminal started throwing funky looking characters.  From what I could tell it was doing what it was supposed to, but you might have to close your terminal and reopen in to `vagrant ssh` into the box. If you are truly paranoid, you can `vagrant provision` again, to make sure everything is what you expect before `vagrant ssh`.

NOTE: after the initial import of the box, it'll always go through the provisioning automatically.
