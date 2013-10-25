knife plugins
=============
There are a TON more of [knife-plugins](http://docs.opscode.com/plugin_knife.html), then officially posted on the docs site.  [Github](https://github.com/search?q=knife+plugin&type=Repositories&ref=searchresults) is a great place to look but I'm going to focus on 4 here. 

So far all the knife plugins I've seen are ruby gems.  So before you can use any of these be sure you have an ability to use `gem install`.

knife-solo is a great tool to emulate a chef-server with just knife commands, this is a poormans version, but it works extremely well.

knife rackspace is a way to interact directly with the rackspace Openstack api, allowing you to spin up boxes via the commandline and even provision them farther leveraging the chef-server of your choice. I'm only going to show spinning up and down boxes here, we don't have a chef-server running yet right?.....right? ;)

knife ec2, is the amazon version of knife rackspace if you will, there aren't terribly number of differences, but i wanted to make sure you realize that you have to choose which version to run to talk to which back end.

knife spork is a great tool for multiple chefs working with one chef-server. I'm only going to touch on it briefly, being again, we _shouldn't_ have a chef-server running....yet.

knife solo
----------
So [knife solo](http://matschaffer.github.io/knife-solo/) as I say above is a poor mans chef-server. In a nutshell it takes your local directory/cookbooks, uploads them to your box, and runs chef-solo. This is different than how [chef-server|chef-client] so keep that in mind as you work with it.  Lets get it working :)

First thing first, installation. You can either add it to a Gemfile, or in my case I like just using 'gem install knife-solo`.  Notice the "-" between the name. You should see something like this:
```bash
root@chef-book:~# gem install knife-solo
Fetching: mixlib-config-1.1.2.gem (100%)
Successfully installed mixlib-config-1.1.2
Fetching: mixlib-cli-1.3.0.gem (100%)
Successfully installed mixlib-cli-1.3.0
Fetching: mixlib-log-1.6.0.gem (100%)
Successfully installed mixlib-log-1.6.0
Fetching: mixlib-authentication-1.3.0.gem (100%)
Successfully installed mixlib-authentication-1.3.0
Fetching: mixlib-shellout-1.2.0.gem (100%)
Successfully installed mixlib-shellout-1.2.0
Fetching: systemu-2.5.2.gem (100%)
Successfully installed systemu-2.5.2
Fetching: yajl-ruby-1.1.0.gem (100%)
Building native extensions.  This could take a while...
Successfully installed yajl-ruby-1.1.0
Fetching: ipaddress-0.8.0.gem (100%)
Successfully installed ipaddress-0.8.0
Fetching: ohai-6.18.0.gem (100%)
Successfully installed ohai-6.18.0
Fetching: mime-types-1.25.gem (100%)
Successfully installed mime-types-1.25
Fetching: rest-client-1.6.7.gem (100%)
Successfully installed rest-client-1.6.7
Fetching: net-ssh-2.7.0.gem (100%)
Successfully installed net-ssh-2.7.0
Fetching: net-ssh-gateway-1.2.0.gem (100%)
Successfully installed net-ssh-gateway-1.2.0
Fetching: net-ssh-multi-1.1.gem (100%)
Successfully installed net-ssh-multi-1.1
Fetching: highline-1.6.20.gem (100%)
Successfully installed highline-1.6.20
Fetching: erubis-2.7.0.gem (100%)
Successfully installed erubis-2.7.0
Fetching: chef-11.6.2.gem (100%)
Successfully installed chef-11.6.2
Fetching: knife-solo-0.3.0.gem (100%)
Thanks for installing knife-solo!

If you run into any issues please let us know at:
  https://github.com/matschaffer/knife-solo/issues

If you are upgrading knife-solo please uninstall any old versions by
running `gem clean knife-solo` to avoid any errors.

See http://bit.ly/CHEF-3255 for more information on the knife bug
that causes this.
Successfully installed knife-solo-0.3.0
Parsing documentation for mixlib-config-1.1.2
Installing ri documentation for mixlib-config-1.1.2
Parsing documentation for mixlib-cli-1.3.0
Installing ri documentation for mixlib-cli-1.3.0
Parsing documentation for mixlib-log-1.6.0
Installing ri documentation for mixlib-log-1.6.0
Parsing documentation for mixlib-authentication-1.3.0
Installing ri documentation for mixlib-authentication-1.3.0
Parsing documentation for mixlib-shellout-1.2.0
Installing ri documentation for mixlib-shellout-1.2.0
Parsing documentation for systemu-2.5.2
Installing ri documentation for systemu-2.5.2
Parsing documentation for yajl-ruby-1.1.0
unable to convert "\xAF" from ASCII-8BIT to UTF-8 for lib/yajl/yajl.so, skipping
Installing ri documentation for yajl-ruby-1.1.0
Parsing documentation for ipaddress-0.8.0
Installing ri documentation for ipaddress-0.8.0
Parsing documentation for ohai-6.18.0
Installing ri documentation for ohai-6.18.0
Parsing documentation for mime-types-1.25
Installing ri documentation for mime-types-1.25
Parsing documentation for rest-client-1.6.7
Installing ri documentation for rest-client-1.6.7
Parsing documentation for net-ssh-2.7.0
Installing ri documentation for net-ssh-2.7.0
Parsing documentation for net-ssh-gateway-1.2.0
Installing ri documentation for net-ssh-gateway-1.2.0
Parsing documentation for net-ssh-multi-1.1
Installing ri documentation for net-ssh-multi-1.1
Parsing documentation for highline-1.6.20
Installing ri documentation for highline-1.6.20
Parsing documentation for erubis-2.7.0
Installing ri documentation for erubis-2.7.0
Parsing documentation for chef-11.6.2
Installing ri documentation for chef-11.6.2
Parsing documentation for knife-solo-0.3.0
Installing ri documentation for knife-solo-0.3.0
Done installing documentation for mixlib-config, mixlib-cli, mixlib-log, mixlib-authentication, mixlib-shellout, systemu, yajl-ruby, ipaddress, ohai, mime-types, rest-client, net-ssh, net-ssh-gateway, net-ssh-multi, highline, erubis, chef, knife-solo (37 sec).
18 gems installed
```
You can already leverage `knife solo` with the cookbook you created. Lets do that now. NOTE: this is a tad bit tricky with virtualbox, so bear with me.

There are three/four main commands with `knife solo`.

`knife solo init mychefrepo`: it creates a directory structure that `knife solo` needs to be able to upload and run your cookbooks. example:
```
mychefrepo/
├── .chef
│   └── knife.rb
├── cookbooks
├── data_bags
├── nodes
├── roles
└── site-cookbooks
```

`knife solo prepare root@hostname`: which checks for the version of chef-solo on the box, and if it's too low installs the newest.

`knife solo cook root@hostname`: runs the cookbooks that you put in the `nodes/hostname.json` `run_list` which is just like the `run_list` like the `solo.json` from earlier.

`knife solo bootstrap root@hostname`: combines the prepare and cook into one command. In theory you can have a `node/hostname.json` set up and run one command and provision a box exactly how you want. Pretty neat eh?

So, lets actually do it.  Go to your `cookbooks` directory in the chef-book vm.
```bash
root@chef-book:~# cd solo/
root@chef-book:~/solo# cd cookbooks/
root@chef-book:~/solo/cookbooks# ls
base
root@chef-book:~/solo/cookbooks#
```
Great, now go ahead and go to your `~/` and create a `knife_solo` directory you can play out of.
```bash
root@chef-book:~/solo/cookbooks# cd ~
root@chef-book:~# mkdir knife_solo
root@chef-book:~# cd knife_solo/
root@chef-book:~/knife_solo#
```
Now type the `knife solo init .` command to make it `knife solo`ized. 
```bash
root@chef-book:~/knife_solo# knife solo init .
Creating kitchen...
Creating knife.rb in kitchen...
Creating cupboards...
root@chef-book:~/knife_solo#
```
Change directory into the `site-cookbook` directory.

I'd like to take a quick moment to talk about the _two_ directories that are here. `cookbooks/` and `site-cookbooks/`, the `cookbook/` directory is for [berkshelf](http://berkshelf.com/) or [librarian](https://github.com/applicationsonline/librarian-chef) to put cookbooks before uploading them to your provisioning box. So remember that, `site-cookbooks/` is the place to put _your_ cookbooks that you want to upload. (If you do put them in `cookbooks/` it'll delete them after the run _and_ can't find them either, so it's a waste, don't bother.)
```bash
root@chef-book:~/knife_solo# cd site-cookbooks/
root@chef-book:~/knife_solo/site-cookbooks# cp -r ~/solo/cookbooks/base/ ./
```
Great, now go up a directory to the `nodes/` directory, and create a file called `localhost.json````bash
root@chef-book:~/knife_solo/site-cookbooks# cd ../nodes/
root@chef-book:~/knife_solo/nodes# vim localhost.json
```
Add the save `solo.json` file that you had from the chef-solo section.
```json
{
    "run_list": [ "recipe[base::default]","recipe[base::ssh]","recipe[base::deployer]" ]
}
```
Just because I want to make sure this goes off without a hitch, go ahead and confirm your public key is in `.ssh/authorized_keys` for root as root. Yes, I realize that's confusing, but read the following commands to make sense of it:
```bash
root@chef-book:~/knife_solo/nodes# cd
root@chef-book:~# cd .ssh/
root@chef-book:~/.ssh# ls
id_rsa  id_rsa.pub  known_hosts
root@chef-book:~/.ssh# cp id_rsa.pub authorized_keys
root@chef-book:~/.ssh# ssh localhost
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

root@chef-book:~# exit
logout
Connection to localhost closed.
root@chef-book:~/.ssh#
```
If that works, we're ready to start playing with `knife solo`.


knife rackspace
----------

knife ec2
----------

knife spork
----------
