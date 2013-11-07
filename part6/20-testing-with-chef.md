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
NOTE: I'm only going to run it against ubuntu10.04 here, if you don't specify it'll run against them all. You can delete them from the `.kitchen.yml` or specify them with a REGEX after the test.
```bash
[~/vagrant/chef-book/cookbooks/base] % bundle exec kitchen test default-ubuntu-1004
-----> Cleaning up any prior instances of <default-ubuntu-1004>
-----> Destroying <default-ubuntu-1004>...
       Finished destroying <default-ubuntu-1004> (0m0.01s).
-----> Testing <default-ubuntu-1004>
-----> Creating <default-ubuntu-1004>...
       Bringing machine 'default' up with 'virtualbox' provider...
       [default] Importing base box 'opscode-ubuntu-10.04'...

[-- snip --]

       Resolving cookbook dependencies with Berkshelf...
!!!!!! The `berkshelf' gem is missing and must be installed or cannot be properly activated. Run `gem install berkshelf` or add the following to your Gemfile if you are using Bundler: `gem 'berkshelf'`.
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: Failed to complete #converge action: [Could not load or activate Berkshelf (cannot load such file -- berkshelf)]
>>>>>> ----------------------
>>>>>> Please see .kitchen/logs/kitchen.log for more details

```

Oh crap! That's a problem eh? So you have two options here, you can remove the `Berksfile` or you can add it to your Gemfile like it says, let's add it. Add it to your Gemfile, like it says and run `bundle install` You should see a signifgant increase in gems used.

Run the `bundle exec kitchen test` again:
```bash
       [2013-11-07T02:58:44+00:00] INFO: Forking chef instance to converge...
       Starting Chef Client, version 11.8.0
       [2013-11-07T02:58:44+00:00] INFO: *** Chef 11.8.0 ***
       [2013-11-07T02:58:44+00:00] INFO: Chef-client pid: 956
       [2013-11-07T02:58:44+00:00] INFO: Setting the run_list to ["base::default"] from JSON
       [2013-11-07T02:58:44+00:00] INFO: Run List is [recipe[base::default]]
       [2013-11-07T02:58:44+00:00] INFO: Run List expands to [base::default]
       [2013-11-07T02:58:44+00:00] INFO: Starting Chef Run for default-ubuntu-1004
       [2013-11-07T02:58:44+00:00] INFO: Running start handlers
       [2013-11-07T02:58:44+00:00] INFO: Start handlers complete.
       Compiling Cookbooks...
       [2013-11-07T02:58:44+00:00] ERROR: Running exception handlers
       [2013-11-07T02:58:44+00:00] ERROR: Exception handlers complete
       [2013-11-07T02:58:44+00:00] FATAL: Stacktrace dumped to /tmp/kitchen-chef-solo/cache/chef-stacktrace.out
       Chef Client failed. 0 resources updated
       [2013-11-07T02:58:44+00:00] ERROR: Cookbook base not found. If you're loading base from another cookbook, make sure you configure the dependency in your metadata
       [2013-11-07T02:58:44+00:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
>>>>>> Converge failed on instance <default-ubuntu-1004>.
>>>>>> Please see .kitchen/logs/default-ubuntu-1004.log for more details
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: SSH exited (1) for command: [sudo -E chef-solo --config /tmp/kitchen-chef-solo/solo.rb --json-attributes /tmp/kitchen-chef-solo/dna.json  --log_level info]
>>>>>> ----------------------
```

Hmm...that's interesting, what's the next step?
