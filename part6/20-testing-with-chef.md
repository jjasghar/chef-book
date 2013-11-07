# Testing with chef

So now you have a great foundation and a "pretty" good understanding of chef. Yes I haven't gone over data_bags, and a couple other fiddly bits (as my mom would say) but I'll let you spend the time to research them.
You probably have looked back on your initial cookbook you wrote and said, "Hey this is pretty neat, I've added a bunch of stuff to it, but man I've lost track of it all." Well if you haven't trust me you will one day. ;)
That's where testing comes into play. Watching [this](http://www.youtube.com/watch?v=qJgMb7hmqLQ&feature=share&t=13m32s) having [Seth Vargo](https://twitter.com/sethvargo) explain Regression testing it should open your eyes to creating a saftey net of testing. That's what we are going to do there with a couple technologies; now you can do more, actually write your tests as you write your future cookbooks, but this is a great place to start.

## test-kitchen

test-kitchen is bad ass. There is no other words that bad ass for test-kitchen. It's a wrapper around your vagrant+(virtualbox|lxc|ec2|openstack|others) and runs your tests. I have the utmost respect for [Fletcher Nichol](https://twitter.com/fnichol) and what he has spear headed. I hope I you justice with this setup tutorial.

I should mention that [Dr Nic](https://twitter.com/drnic) has a good [primer](http://www.youtube.com/watch?v=0sPuAb6nB2o) but I'm focusing on just setting it up here. The following sections will be to use the different software.

First step will be to get test-kitchen installed. As of this writing it's a ruby gem, so you should create a `Gemfile` in your base cookbook folder. Something like this:
```bash
[~/vagrant/chef-book/cookbooks/base] % vim Gemfile
```
Then add something like this to that file:
```ruby
source 'http://rubygems.org'

gem 'kitchen-vagrant', git: 'git://github.com/opscode/kitchen-vagrant.git'
gem 'test-kitchen', git: 'git://github.com/opscode/test-kitchen.git'
```
Now run `bundle install`:
```bash
[~/vagrant/chef-book/cookbooks/base] % bundle install
Updating git://github.com/opscode/kitchen-vagrant.git
Updating git://github.com/opscode/test-kitchen.git
Fetching gem metadata from http://rubygems.org/........
Fetching gem metadata from http://rubygems.org/..
Resolving dependencies...
Using buff-ignore (1.1.0)
Using mixlib-shellout (1.2.0)
Using net-ssh (2.7.0)
Using net-scp (1.1.2)
Using safe_yaml (0.9.7)
Using thor (0.18.1)
Using test-kitchen (1.0.0.dev) from git://github.com/opscode/test-kitchen.git (at master)
Using kitchen-vagrant (0.11.2.dev) from git://github.com/opscode/kitchen-vagrant.git (at master)
Using bundler (1.3.5)
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.
[~/vagrant/chef-book/cookbooks/base] %
```

You should have a `kitchen` binary now, test it out with something like this:
```bash
[~/vagrant/chef-book/cookbooks/base] % bundle exec kitchen
Commands:
  kitchen console                          # Kitchen Console!
  kitchen converge [(all|<REGEX>)] [opts]  # Converge one or more instances
  kitchen create [(all|<REGEX>)] [opts]    # Create one or more instances
  kitchen destroy [(all|<REGEX>)] [opts]   # Destroy one or more instances
  kitchen driver                           # Driver subcommands
  kitchen driver create [NAME]             # Create a new Kitchen Driver gem project
  kitchen driver discover                  # Discover Test Kitchen drivers published on RubyGems
  kitchen driver help [COMMAND]            # Describe subcommands or one specific subcommand
  kitchen help [COMMAND]                   # Describe available commands or one specific command
  kitchen init                             # Adds some configuration to your cookbook so Kitchen ca...
  kitchen list [(all|<REGEX>)]             # List all instances
  kitchen login (['REGEX']|[INSTANCE])     # Log in to one instance
  kitchen setup [(all|<REGEX>)] [opts]     # Setup one or more instances
  kitchen test [all|<REGEX>)] [opts]       # Test one or more instances
  kitchen verify [(all|<REGEX>)] [opts]    # Verify one or more instances
  kitchen version                          # Print Kitchen's version information

[~/vagrant/chef-book/cookbooks/base] %
```

Awesome! Now we need to initalize the repo, that's done by this:
```bash
[~/vagrant/chef-book/cookbooks/base] % bundle exec kitchen init
      create  .kitchen.yml
      create  test/integration/default
      create  .gitignore
      append  .gitignore
      append  .gitignore
[~/vagrant/chef-book/cookbooks/base] %
```

Go ahead and open up that `.kitchen.yml`:
```yml
---
driver_plugin: vagrant
driver_config:
  require_chef_omnibus: true

platforms:
- name: ubuntu-12.04
  driver_config:
    box: opscode-ubuntu-12.04
    box_url: https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box
- name: ubuntu-10.04
  driver_config:
    box: opscode-ubuntu-10.04
    box_url: https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-10.04_provisionerless.box
- name: centos-6.4
  driver_config:
    box: opscode-centos-6.4
    box_url: https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_centos-6.4_provisionerless.box
- name: centos-5.9
  driver_config:
    box: opscode-centos-5.9
    box_url: https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_centos-5.9_provisionerless.box

suites:
- name: default
  run_list: []
  attributes: {}
```

As you can see it has some pre-built boxes from opscode, and by default it uses the vagrant driver. That's cool, that's all we expect here.

Note the `run_list` you need to add the `run_list` for your cook book here, in my case:
```
run_list: ["base::default"]
```

Now you can do a straight `bundle exec kitchen test` here, but before we do that we should talk about the other options.

`bundle exec kitchen converge` is the first part of the "test" command. Like at the beginning of the book you used `./converge.sh` this tells `kitchen` to do it for you.

`bundle exec kitchen verify` is the second part of the "test" command. It runs something called   "busser" to run [bats](https://github.com/sstephenson/bats) tests. I'll get to that in a bit.

Ok, so go ahead and run `bundle exec kitchen test` and lets see what happens:

NOTE: I'm only going to run it against ubuntu10.04 here, if you don't specify it'll run against them all. You can delete them from the `.kitchen.yml` or specify them with a REGEX after the test. I also removed the `Berksfile` and `Berksfile.lock` to make it simpler. I'm betting if you create a `sites-cookooks/` directory you should be able to use that `Berksfile` but that's for another time.

```bash
[~/vagrant/chef-book/cookbooks/base] % rm Berksfile*
[~/vagrant/chef-book/cookbooks/base] % bundle exec kitchen test default-ubuntu-1004
      [default] Booting VM...
       [default] Waiting for machine to boot. This may take a few minutes...
       [default] Machine booted and ready!
       [default] Setting hostname...
       [default] Mounting shared folders...
       Vagrant instance <default-ubuntu-1004> created.
       Finished creating <default-ubuntu-1004> (0m48.25s).
-----> Converging <default-ubuntu-1004>...
-----> Installing Chef Omnibus (true)
       downloading https://www.opscode.com/chef/install.sh
         to file /tmp/install.sh
       trying wget...
       Downloading Chef  for ubuntu...
       Installing Chef
       Selecting previously deselected package chef.
(Reading database ... 60%...
(Reading database ... 44103 files and directories currently installed.)
       Unpacking chef (from .../tmp.0JUVszhT/chef__amd64.deb) ...
       Setting up chef (11.8.0-1.ubuntu.10.04) ...
       Thank you for installing Chef!

!!!!!! Berksfile, Cheffile, cookbooks/, or metadata.rb must exist in /Users/jasghar/vagrant/chef-book/cookbooks/base
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: Failed to complete #converge action: [Cookbooks could not be found]
>>>>>> ----------------------
>>>>>> Please see .kitchen/logs/kitchen.log for more details
```

Oh crap! That's a problem eh?  Ok, so open up `metadata.rb` and add something like the following:
```ruby
name 'base'
version '0.1.0'
maintainer 'JJ Asghar'
```
Now run your test again:
```bash
[~/vagrant/chef-book/cookbooks/base] % bundle exec kitchen test default-ubuntu-1004
-----> Cleaning up any prior instances of <default-ubuntu-1004>
-----> Destroying <default-ubuntu-1004>...
       [default] Forcing shutdown of VM...
       [default] Destroying VM and associated drives...
       Vagrant instance <default-ubuntu-1004> destroyed.
       Finished destroying <default-ubuntu-1004> (0m8.43s).
-----> Testing <default-ubuntu-1004>
-----> Creating <default-ubuntu-1004>...
       Bringing machine 'default' up with 'virtualbox' provider...
       [default] Importing base box 'opscode-ubuntu-10.04'...

[-- snip --]

      STDERR: Failed to fetch http://security.ubuntu.com/ubuntu/pool/main/p/python2.6/libpython2.6_2.6.5-1ubuntu6.1_amd64.deb  404  Not Found [IP: 91.189.92.184 80]
       E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
       ---- End output of apt-get -q -y install vim=2:7.2.330-1ubuntu3.1 ----
       Ran apt-get -q -y install vim=2:7.2.330-1ubuntu3.1 returned 100


       Resource Declaration:
       ---------------------
       # In /tmp/kitchen-chef-solo/cookbooks/base/recipes/default.rb

         2:    package pkg do
         3:      action [:install]
         4:   end
         5: end



       Compiled Resource:
       ------------------
       # Declared in /tmp/kitchen-chef-solo/cookbooks/base/recipes/default.rb:2:in `block in from_file'

       package("vim") do
         action [:install]
         retries 0
         retry_delay 2
         package_name "vim"
         version "2:7.2.330-1ubuntu3.1"
         cookbook_name :base
         recipe_name "default"
       end

[-- snip --]

       STDERR: Failed to fetch http://security.ubuntu.com/ubuntu/pool/main/p/python2.6/libpython2.6_2.6.5-1ubuntu6.1_amd64.deb  404  Not Found [IP: 91.189.92.184 80]
       E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
       ---- End output of apt-get -q -y install vim=2:7.2.330-1ubuntu3.1 ----
       Ran apt-get -q -y install vim=2:7.2.330-1ubuntu3.1 returned 100
       [2013-11-07T21:19:18+00:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
>>>>>> Converge failed on instance <default-ubuntu-1004>.
>>>>>> Please see .kitchen/logs/default-ubuntu-1004.log for more details
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: SSH exited (1) for command: [sudo -E chef-solo --config /tmp/kitchen-chef-solo/solo.rb --json-attributes /tmp/kitchen-chef-solo/dna.json  --log_level info]
>>>>>> ----------------------
```
Ok, that looks like we need to update the `apt-get` repo, I'll fix this here: (this is a hack, but I just want it to work ;) )
I'll open the `default.rb` and do:
```ruby
execute "apt-get update"

%w{vim ntp build-essential}.each do |pkg|
   package pkg do
     action [:install]
  end
end

include_recipe "base::ssh"
```
Now run the test again: `bundle exec kitchen test default-ubuntu-1004`
```bash
[~/vagrant/chef-book/cookbooks/base] % bundle exec kitchen test default-ubuntu-1004
-----> Cleaning up any prior instances of <default-ubuntu-1004>
-----> Destroying <default-ubuntu-1004>...
       [default] Forcing shutdown of VM...
       [default] Destroying VM and associated drives...
       Vagrant instance <default-ubuntu-1004> destroyed.
       Finished destroying <default-ubuntu-1004> (0m7.39s).
-----> Testing <default-ubuntu-1004>
-----> Creating <default-ubuntu-1004>...
       Bringing machine 'default' up with 'virtualbox' provider...
       [default] Importing base box 'opscode-ubuntu-10.04'...

[-- snip --]

      * execute[apt-get update] action run[2013-11-07T21:23:31+00:00] INFO: Processing execute[apt-get update] action run (base::default line 1)
       Hit http://us.archive.ubuntu.com lucid Release.gpg
       Get:1 http://us.archive.ubuntu.com lucid-updates Release.gpg [198B]
       Hit http://us.archive.ubuntu.com lucid Release
       Get:2 http://us.archive.ubuntu.com lucid-updates Release [58.3kB]
       Get:3 http://security.ubuntu.com lucid-security Release.gpg [198B]
       Get:4 http://security.ubuntu.com lucid-security Release [57.3kB]
       Hit http://us.archive.ubuntu.com lucid/main Packages
       Hit http://us.archive.ubuntu.com lucid/restricted Packages
       Hit http://us.archive.ubuntu.com lucid/main Sources
       Hit http://us.archive.ubuntu.com lucid/restricted Sources
       Hit http://us.archive.ubuntu.com lucid/universe Packages
       Hit http://us.archive.ubuntu.com lucid/universe Sources
       Hit http://us.archive.ubuntu.com lucid/multiverse Packages
       Hit http://us.archive.ubuntu.com lucid/multiverse Sources

[-- snip --]

       [2013-11-07T21:24:05+00:00] INFO: cookbook_file[/etc/ssh/ssh_config] sending reload action to service[ssh] (immediate)
         * service[ssh] action reload[2013-11-07T21:24:05+00:00] INFO: Processing service[ssh] action reload (base::ssh line 6)
       [2013-11-07T21:24:05+00:00] INFO: service[ssh] reloaded

           - reload service service[ssh]

       [2013-11-07T21:24:05+00:00] INFO: cookbook_file[/etc/ssh/ssh_config] sending start action to service[ssh] (immediate)
         * service[ssh] action start[2013-11-07T21:24:05+00:00] INFO: Processing service[ssh] action start (base::ssh line 6)
        (up to date)
       [2013-11-07T21:24:05+00:00] INFO: Chef Run complete in 34.624801857 seconds
       [2013-11-07T21:24:05+00:00] INFO: Running report handlers
       [2013-11-07T21:24:05+00:00] INFO: Report handlers complete
       Chef Client finished, 6 resources updated
       Finished converging <default-ubuntu-1004> (0m59.77s).
-----> Setting up <default-ubuntu-1004>...
       Finished setting up <default-ubuntu-1004> (0m0.00s).
-----> Verifying <default-ubuntu-1004>...
       Finished verifying <default-ubuntu-1004> (0m0.00s).
-----> Destroying <default-ubuntu-1004>...
       [default] Forcing shutdown of VM...
       [default] Destroying VM and associated drives...
       Vagrant instance <default-ubuntu-1004> destroyed.
       Finished destroying <default-ubuntu-1004> (0m7.92s).
       Finished testing <default-ubuntu-1004> (2m5.08s).
```

Sweet! It works! Ok, now lets move on to testing...

## bats

bats stands for "Bash Automated Testing System" and for a sysadmin is a great introduction to testing.  You can find the [repo](https://github.com/sstephenson/bats) there. I'm going to explain how to tie bats in with test-kitchen. Seriously, it's great. You've probably been using bash for years, this is just a simple layer on top of that foundation.
