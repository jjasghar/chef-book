Running vagrant provisioning vs a local chef-solo run
-----------------------------------------------------

With a working `chef-solo` converge, this is a good time to talk about using local chef-solo and running chef outside via vagrant. As I am developing/testing a cookbook I personally prefer the local chef-solo install. It allows for a faster iterations which is great. But when you get your cookbook where you want it to be,`vagrant provision` is the way to go. For fun let's convert the cookbook we wrote `base` to the `Vagrant` file.

Luckily vagrant has mounted the `/vagrant` directory where you did the `vagrant up` from. Go ahead and do something like the following:
```bash
root@chef-book:~/solo# cp -r cookbooks/ /vagrant/
root@chef-book:~/solo#
```
This will copy the cookbooks directory from your `~/solo` working directory into the host file system. Go ahead and drop out of the vm now.
```bash
root@chef-book:~/solo# exit
logout
vagrant@chef-book:~$ exit
logout
Connection to 127.0.0.1 closed.
[~/vagrant/chef-book] % ls
Vagrantfile cookbooks
```
As you can see your `cookbooks` directory is there.  Next you'll need to open up the `Vagrantfile` and add the run_list to it so chef-solo can do it's magic.
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :
$script = <<SCRIPT
apt-get update
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
ntpdate tick.uh.edu
SCRIPT

Vagrant::Config.run do |config|
  config.vm.box = "chef-book"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.host_name = 'chef-book'

  #config.vm.provision :shell, :inline => $script
  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "base"
  end
end
```
If you noticed I commented out the `:shell` provisioning and added the `chef_solo` provisioner. Write quit out of this, and run `vagrant halt` then `vagrant up` and if needed `vagrant provision` and you should see something like this:
```bash
[~/vagrant/chef-book] % vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
[default] Clearing any previously set forwarded ports...
[default] Creating shared folders metadata...
[default] Clearing any previously set network interfaces...
[default] Preparing network interfaces based on configuration...
[default] Forwarding ports...
[default] -- 22 => 2222 (adapter 1)
[default] Booting VM...
[default] Waiting for machine to boot. This may take a few minutes...
[default] Machine booted and ready!
[default] Setting hostname...
[default] Mounting shared folders...
[default] -- /vagrant
[default] -- /tmp/vagrant-chef-1/chef-solo-1/cookbooks
[~/vagrant/chef-book] % vagrant provision
[default] Running provisioner: chef_solo...
Generating chef JSON and uploading...
Running chef-solo...
stdin: is not a tty
[2013-10-22T15:17:25-05:00] INFO: Forking chef instance to converge...
[2013-10-22T15:17:25-05:00] INFO: *** Chef 11.6.2 ***
[2013-10-22T15:17:26-05:00] INFO: Setting the run_list to ["recipe[base::default]"] from JSON
[2013-10-22T15:17:26-05:00] INFO: Run List is [recipe[base::default]]
[2013-10-22T15:17:26-05:00] INFO: Run List expands to [base::default]
[2013-10-22T15:17:26-05:00] INFO: Starting Chef Run for chef-book
[2013-10-22T15:17:26-05:00] INFO: Running start handlers
[2013-10-22T15:17:26-05:00] INFO: Start handlers complete.
[2013-10-22T15:17:26-05:00] INFO: Chef Run complete in 0.48791292 seconds
[2013-10-22T15:17:26-05:00] INFO: Running report handlers
[2013-10-22T15:17:26-05:00] INFO: Report handlers complete
[~/vagrant/chef-book] %
```
Hopefully you get the beauty of the built in provisioner. You can pull the cookbooks that you'd like to test out, edit the run_list and run the provisioning to get the box how you want. Don't get me wrong there's much more to it, the [docs](http://docs.vagrantup.com/v2/provisioning/chef_solo.html) have a ton more to do, but this is just a basic example.
Now lets move on to your most important tool as a chef; [knife](../part3/08-knife.md).
