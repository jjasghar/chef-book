A simple cookbook
=================

First off, lets talk about the structure of how chef takes it's instructions. At the core of a set of instructions there is something called a _recipe_ and a collection of recipes can be in a cookbook. Pretty straight forward eh? As I said in the previous section, recipes are top down compiled bits of software, just like if you are reading a cookbook in real life. (enter a joke here about screwing up a food recipe).

So the first thing we are going to do is make our life's a little easier. You already have a provisioned box, with `chef-solo` on it, so lets write a wrapper script to call `chef-solo` so we only have to run one command to `converge` the cookbook. 

Note: converge, is used a chef term to run through the list of chef cookbook(s) that you want to run. 

Go ahead and create a directory that'll be your core working directory. `core` or `solo` is probably a good term.
```bash
root@chef-book:~# mkdir solo
root@chef-book:~# cd solo
root@chef-book:~/solo#
```


converge.sh
-----------
Go ahead and open a text editor and call the file `converge.sh` and the following to the file:
```bash
#!/bin/bash

chef-solo -c solo.rb -j solo.json
```
Yep, not that hard. I created a more verbose [script](http://jjasghar.github.io/blog/2013/10/18/people-keep-asking-me-how-to-start-with-chef/) here, but we are going a tad bit different direction than I wanted to do in that post.

Go ahead and `chmod +x converge.sh` and run it.
```bash
root@chef-book:~/solo# chmod +x converge.sh
root@chef-book:~/solo# ./converge.sh
[2013-10-21T15:10:17-05:00] WARN: *****************************************
[2013-10-21T15:10:17-05:00] WARN: Did not find config file: solo.rb, using command line options.
[2013-10-21T15:10:17-05:00] WARN: *****************************************
[2013-10-21T15:10:17-05:00] FATAL: I cannot find solo.json
root@chef-book:~#
```
Perfect, we are ready to start the next part.

solo.rb
-------
Next, open up a text editor and create `solo.rb`, yep that file that it was `WARN` about, add the following to it:
```ruby
root = File.absolute_path(File.dirname(__FILE__))

file_cache_path root
cookbook_path root + '/cookbooks'
```
It's pretty straight forward, it's a ruby script telling chef-solo that the directory that it's running from is where it wants to be, and the `/cookbooks` is the `cookbook_path`.

solo.json
---------
Next we need to create the solo.json. Open up another text editor and create `solo.json` and put the following in it:
```json
{
    "run_list": [ "recipe[base::default]" ]
}
```
This is the "run_list" for `chef-solo`.  It tells it that `chef-solo` needs to go into the base cookbook and run the `default` recipe. You can have as long of a run_list as you want, but this is the first one so lets just start with one.

Go ahead and run `./converge.sh` again, it should be different:
```bash
root@chef-book:~/solo# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
[2013-10-21T15:21:36-05:00] ERROR: Running exception handlers
[2013-10-21T15:21:36-05:00] ERROR: Exception handlers complete
[2013-10-21T15:21:36-05:00] FATAL: Stacktrace dumped to /root/solo/chef-stacktrace.out
Chef Client failed. 0 resources updated
[2013-10-21T15:21:36-05:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
root@chef-book:~/base# cat /root/solo/chef-stacktrace.out
```
The most important part about the chef-stacktrace.out is this one:
```ruby
Chef::Exceptions::CookbookNotFound: Cookbook base not found. If you're loading base from another cookbook, make sure you configure the dependency in your metadata
```
And that's expected, you haven't created one yet!

base cookbook
-------------

Ok, you are at `~/solo` right? Good, go ahead and type `mkdir -p cookbooks/solo/recipes/` and `cd` to that directory.
```bash
root@chef-book:~/solo# mkdir -p cookbooks/base/recipes/
root@chef-book:~/solo# cd cookbooks/base/recipes/
root@chef-book:~/solo/cookbooks/base/recipes#
```
Now we need to create the `default.rb` file. Open up your favorite text editor and write the following. Now you'll notice that I'm using `nano` here, it's not my favor, far be it, but this is to show the first installation of software.
```bash
root@chef-book:~/solo/cookbooks/base/recipes# nano default.rb
```

```ruby
package 'vim'
```
Now logically this will install `vim` right? Yep, and we're about to see that. Go ahead and go up to `~/solo`, and run `./converge.sh`, you should see something like this:
```bash
root@chef-book:~/solo/cookbooks/base/recipes# cd ~/solo
root@chef-book:~/solo# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 1 resources
Recipe: base::default
  * package[vim] action install
    - install version 2:7.3.429-2ubuntu2.1 of package vim

Chef Client finished, 1 resources updated
root@chef-book:~/solo#
```
Congratulations! You have successfully installed the greatest editor using `chef-solo`! Don't believe me? type `vim`. Go ahead and run `./converge.sh` again, it should look like this:
```bash
root@chef-book:~/solo# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 1 resources
Recipe: base::default
  * package[vim] action install (up to date)
Chef Client finished, 0 resources updated
root@chef-book:~/solo#
```
This is important, as you can see it didn't _reinstall_ it. It just checked that `vim` was installed and then it moved on. Badass.

If you want to skip ahead, check out the [resources](http://docs.opscode.com/resource.html) and see what cool things you can do. Don't worry I'll walk y'all through some more.

So let's add a couple more packages to our base recipe (`~/solo/cookbooks/base/recipes/default.rb`), there are two ways you can do this. One is just add line by line, like:
```ruby
package 'vim'
package 'ntp'
package 'build-essential'
```
Or you can do:
```ruby
%w{vim ntp build-essential}.each do |pkg|
  package pkg do
    action [:install]
  end
end
```
Both are basiclly, the same, the second one is just more rubyish. Go ahead and `cd ~/solo/` and run `./convege.sh` again.
```bash
root@chef-book:~/solo# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 3 resources
Recipe: base::default
  * package[vim] action install (up to date)
  * package[ntp] action install (up to date)
  * package[build-essential] action install (up to date)
Chef Client finished, 0 resources updated
root@chef-book:~/solo#
```

Congrats man, no you can install packages via chef and confirm that they are there.

Next up is the chef version of the puppet "[trifecta](http://docs.puppetlabs.com/puppet_core_types_cheatsheet.pdf)".  In the puppet world it's "Package/file/service: Learn it, live it, love it. If you can only do this, you can still do a lot." Which is very true.  Let's try to leverage this in the chef world.  In the real world you probably don't want to log into your boxes as `vagrant ssh` right? So lets create a `deploy` user.  I'll first start out with the chef trifecta, then move to the user account.

chef trifecta
-------------

If you looked at the cheat sheet above you would have seen:
```python
package { 'openssh-server':
 ensure => installed,
}
file { '/etc/ssh/sshd_config':
 source => 'puppet:///modules/sshd/sshd_config',
 owner => 'root',
 group => 'root',
 mode => '640',
 notify => Service['sshd'], # sshd will restart whenever you edit this file.
 require => Package['openssh-server'],
}
service { 'sshd':
 ensure => running,
 enable => true,
 hasstatus => true,
 hasrestart => true,
}
```
Lets create this in chef, I'm going to create another recipe and link it to the chef-solo run. Here we go.

Oh, you'll need an ssh_config file, copying it from `/etc/ssh/` won't hurt.

```bash
root@chef-book:~# cd solo/cookbooks/base/recipes/
root@chef-book:~/solo/cookbooks/base/recipes# vim ssh.rb
```

```ruby
package 'openssh-server' do
  action :install
end

service "ssh" do
  action [:enable, :start]
  supports :status => true, :start => true, :stop => true, :restart => true
end

cookbook_file "/etc/ssh/ssh_config" do
  source "ssh_config"
  owner "root"
  group "root"
  mode "0640"
  notifies :reload, "service[ssh]", :immediately
  notifies :start, "service[ssh]", :immediately
end
```

```bash
root@chef-book:~/solo/cookbooks/base/recipes# cd ../
root@chef-book:~/solo/cookbooks/base# mkdir -p files/default
root@chef-book:~/solo/cookbooks/base# cd files/default/
root@chef-book:~/solo/cookbooks/base/files/default# cp /etc/ssh/ssh_config ./
```
As you can see the `cookbook_file` is the stanza that tells chef-solo, that you need to put this file in this location with these settings and this is the source. You should have noticed that you created a `files/default` directory, that's the first location that `cookbook_file` looks at. You can create different directories in `files/` like `ubuntu` or `ubuntu12.04` or `redhat` so you can have a different format per file. Now I should mention that `files` is just for _static_ files, not templatized files. We'll get there in a bit.

Go ahead and run your `./converge` again, you should see something like this:
```bash
root@chef-book:~/solo# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 3 resources
Recipe: base::default
  * package[vim] action install (up to date)
  * package[ntp] action install (up to date)
  * package[build-essential] action install (up to date)
Chef Client finished, 0 resources updated
```
Ah you got me. We didn't type in the ssh recipe to the default run did we; good eye. Go ahead and open up `cookbooks/base/recipes/default.rb` and do the following:
```ruby
%w{vim ntp build-essential}.each do |pkg|
   package pkg do
     action [:install]
  end
end

include_recipe "base::ssh"
```
Ok, now go ahead and run `./converge.sh` again, you should see something like this:
```bash
root@chef-book:~/solo# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 6 resources
Recipe: base::default
  * package[vim] action install (up to date)
  * package[ntp] action install (up to date)
  * package[build-essential] action install (up to date)
Recipe: base::ssh
  * package[openssh-server] action install (up to date)
  * service[ssh] action enable (up to date)
  * service[ssh] action start (up to date)
  * cookbook_file[/etc/ssh/ssh_config] action create (up to date)
Chef Client finished, 0 resources updated
```
Ok, so let's take this one step farther. Go ahead and open up `cookbooks/base/files/default/ssh_config` and put a comment at the top of the file. Diff the file and the main one. 
```bash
root@chef-book:~/solo# vim cookbooks/base/files/default/ssh_config
root@chef-book:~/solo# diff -u /etc/ssh/ssh_config cookbooks/base/files/default/ssh_config
--- /etc/ssh/ssh_config 2012-04-02 06:48:45.000000000 -0500
+++ cookbooks/base/files/default/ssh_config 2013-10-22 14:29:22.561680067 -0500
@@ -1,4 +1,4 @@
-
+# this is a comment i added at the top
 # This is the ssh client system-wide configuration file.  See
 # ssh_config(5) for more information.  This file provides defaults for
 # users, and the values can be changed in per-user configuration files
root@chef-book:~/solo#
```
Go ahead and run the `./converge.sh` again. You should see no differance now.
```bash
root@chef-book:~/solo# diff -u /etc/ssh/ssh_config cookbooks/base/files/default/ssh_config
root@chef-book:~/solo#
```

Nice, we now have the ability to install a package, install a config file, and confirm that the service is up and running.

Ok, if you have any chef knowalage, you are probably wondering why we didn't add this to the `run_list`. That's a great question, why not? Well honestly, I wanted to show how different recipes can call other recipes, or even cookbooks. If you want to use the `run_list` idea, all you have to do is the following, `vim ~/solo/solo.json` and:
```json
{
    "run_list": [ "recipe[base::default]","recipe[base::ssh]" ]
}
```
Don't get me wrong this is extremely important, but I was going to revisit this when we started adding external cookbooks. You made me jump my gun. :P

Now lets go on to the deploy user.

deploy user
----------

