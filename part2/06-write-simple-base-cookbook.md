A simple cookbook
=================

First off, let's talk about the structure of how chef takes its instructions. 
At the core of a set of instructions there is something called a _recipe_ and a 
collection of recipes can be in a cookbook. Pretty straight forward, eh? As I 
said in the previous section, recipes are top down compiled instructions just 
like if you are reading a cookbook in real life. (enter a joke here about 
screwing up a food recipe).

A first recipe
--------------

Before we jump into a cookbook, let's look at creating a simple recipe.

Log in as root into your vagrant vm and edit a file called `whatever.rb`:

```bash
~/vagrant/chef-book$ vagrant ssh                                                                                                                               davedash@immacomputer
Welcome to Ubuntu 12.04.4 LTS (GNU/Linux 3.2.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Sat Jun 28 12:42:11 2014 from 10.0.2.2
vagrant@chef-book:~$ sudo su -
root@chef-book:~# nano whatever.rb
```

Let's add this bit of ruby, this will be our recipe:

```rb

file '/tmp/x.txt' do
  content 'hello world'
end

```

Save that file, and now run `chef-client`:

```bash
root@chef-book:~# chef-client -z whatever.rb
[2014-06-28T12:50:37-07:00] WARN: No config file found or specified on command line, using command line options.
[2014-06-28T12:50:37-07:00] WARN: No cookbooks directory found at or above current directory.  Assuming /root.
[2014-06-28T12:50:37-07:00] WARN:
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
SSL validation of HTTPS requests is disabled. HTTPS connections are still
encrypted, but chef is not able to detect forged replies or man in the middle
attacks.

To fix this issue add an entry like this to your configuration file:

```
  # Verify all HTTPS connections (recommended)
  ssl_verify_mode :verify_peer

  # OR, Verify only connections to chef-server
  verify_api_cert true
```

To check your SSL configuration, or troubleshoot errors, you can use the
`knife ssl check` command like so:

```
  knife ssl check -c
```

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Starting Chef Client, version 11.14.0.alpha.1
resolving cookbooks for run list: []
Synchronizing Cookbooks:
Compiling Cookbooks...
[2014-06-28T12:50:38-07:00] WARN: Node chef-book has an empty run list.
Converging 1 resources
Recipe: @recipe_files::/root/whatever.rb
  * file[/tmp/x.txt] action create
    - create new file /tmp/x.txt
    - update content in file /tmp/x.txt from none to b94d27
        --- /tmp/x.txt	2014-06-28 12:50:38.529763792 -0700
        +++ /tmp/.x.txt20140628-22580-1t8rh4f	2014-06-28 12:50:38.529763792 -0700
        @@ -1 +1,2 @@
        +hello world


Running handlers:
Running handlers complete

Chef Client finished, 1/1 resources updated in 1.363444007 seconds
root@chef-book:~#
```

Now you can verify that there's a new file, `/tmp/x.txt`.  
Does it contain what you expect?


Let's make things easier
------------------------

So the next thing we are going to do is make our lives a little easier. You 
already have a provisioned box with `chef-client` on it, so let's write a 
wrapper script to call `chef-client` so we only have to run one command to 
"converge" the cookbook on a new box. 
Convergence is what chef calls the process of applying the list of recipes that 
you want to run.

Go ahead and create a directory that will be your core working directory. 
`core` is probably a good term.

```bash
root@chef-book:~# mkdir core
root@chef-book:~# cd core
root@chef-book:~/core#
```

converge.sh
-----------

Go ahead and create a new file in your text editor called `converge.sh` 
containing the following:

```bash
#!/bin/bash

chef-server -z -j solo.json
```

Go ahead and run `chmod +x converge.sh` to make it executable, then run it.

```bash
root@chef-book:~/core# chmod +x converge.sh
root@chef-book:~/core# ./converge.sh
[2014-06-28T13:00:05-07:00] WARN: No config file found or specified on command line, using command line options.
[2014-06-28T13:00:05-07:00] FATAL: Cannot load configuration from core.json
root@chef-book:~#
```

Perfect, we are ready to start the next part.

core.json
---------

Open up another text editor to create `core.json` and insert the following:

```json
{
    "run_list": [ "recipe[base::default]" ]
}
```

This is the "run_list" for `chef-client`.  It tells `chef-client` to use the 
`base` cookbook and run the `default` recipe. You can have as long of a 
run_list as you want, but let's start with a single recipe for now.

Go ahead and run `./converge.sh` again, the output should be different:
```bash
root@chef-book:~/core# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
[2013-10-21T15:21:36-05:00] ERROR: Running exception handlers
[2013-10-21T15:21:36-05:00] ERROR: Exception handlers complete
[2013-10-21T15:21:36-05:00] FATAL: Stacktrace dumped to /root/core/chef-stacktrace.out
Chef Client failed. 0 resources updated
[2013-10-21T15:21:36-05:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
root@chef-book:~/base# cat /root/core/chef-stacktrace.out
```

The error that stands out in `chef-stacktrace.out` is this one:

```ruby
Chef::Exceptions::CookbookNotFound: Cookbook base not found. If you're loading base from another cookbook, make sure you configure the dependency in your metadata
```

And that's expected, you haven't created one yet!

base cookbook
-------------

Ok, you are at `~/core` right? Good, go ahead and type 
`mkdir -p cookbooks/base/recipes/` and `cd` to that directory.

```bash
root@chef-book:~/core# mkdir -p cookbooks/base/recipes/
root@chef-book:~/core# cd cookbooks/base/recipes/
root@chef-book:~/core/cookbooks/base/recipes#
```

Now we need to create the `default.rb` file. Open up your favorite text 
editor and write the following. Now you'll notice that I'm using `nano` here, 
it's not my favorite, far be it, but this is to show the first installation of 
software.

```bash
root@chef-book:~/core/cookbooks/base/recipes# nano default.rb
```

```ruby
package 'vim'
```

Now logically this will install `vim` right? Yep, and we're about to see that. 
Go ahead and go up to `~/core`, and run `./converge.sh`, 
you should see something like this:

```bash
root@chef-book:~/core/cookbooks/base/recipes# cd ~/core
root@chef-book:~/core# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 1 resources
Recipe: base::default
  * package[vim] action install
    - install version 2:7.3.429-2ubuntu2.1 of package vim

Chef Client finished, 1 resources updated
root@chef-book:~/core#
```
Congratulations! You have successfully installed the greatest editor using `chef-solo`! Don't believe me? type `vim`. Go ahead and run `./converge.sh` again, it should look like this:
```bash
root@chef-book:~/core# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 1 resources
Recipe: base::default
  * package[vim] action install (up to date)
Chef Client finished, 0 resources updated
root@chef-book:~/core#
```

This is important, as you can see it didn't _reinstall_ it. It just checked that `vim` was installed and then it moved on. Badass.

If you want to skip ahead, check out the [resources](http://docs.opscode.com/resource.html) and see what cool things you can do. Don't worry I'll walk y'all through some more.

So let's add a couple more packages to our base recipe (`~/core/cookbooks/base/recipes/default.rb`). There are two ways you can do this. One is to just add them line by line, like:
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

Both are basically, the same, the second one is just more rubyish. 
Go ahead and `cd ~/core/` and run `./convege.sh` again.

```bash
root@chef-book:~/core# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 3 resources
Recipe: base::default
  * package[vim] action install (up to date)
  * package[ntp] action install (up to date)
  * package[build-essential] action install (up to date)
Chef Client finished, 0 resources updated
root@chef-book:~/core#
```

Congrats man, now you can install packages via chef and confirm that they are there.

Next up is the chef version of the puppet 
"[trifecta](http://docs.puppetlabs.com/puppet_core_types_cheatsheet.pdf)".  
In the puppet world it's "Package/file/service: Learn it, live it, love it. 
If you can only do this, you can still do a lot." This is very true.  
Let's try to leverage this in the chef world.  In the real world you probably don't want to log into your boxes as `vagrant ssh` right? So lets create a `deploy` user.  
I'll first start out with the chef trifecta, then move to the user account.

chef trifecta
-------------

If you looked at the cheat sheet above you would have seen:

```puppet
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

Let's create this in chef. I'm going to create another recipe and link it to the
chef run. Here we go.

Oh, you'll need an sshd_config file. Copying it from `/etc/ssh/` will be fine.

```bash
root@chef-book:~# cd core/cookbooks/base/recipes/
root@chef-book:~/core/cookbooks/base/recipes# vim ssh.rb
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

*Note*: If you decided to use Ubuntu 14.04 Trusty Tahr, you will need to modify 
the `service "ssh"` block as below to call the Upstart provider instead of the 
shell as in previous versions.

```ruby
service "ssh" do
  provider Chef::Provider::Service::Upstart
  # as before...
end
```

```bash
root@chef-book:~/core/cookbooks/base/recipes# cd ../
root@chef-book:~/core/cookbooks/base# mkdir -p files/default
root@chef-book:~/core/cookbooks/base# cd files/default/
root@chef-book:~/core/cookbooks/base/files/default# cp /etc/ssh/ssh_config ./
```

As you can see, `cookbook_file` is the stanza that tells chef-solo to put this
file in this location with these settings and this is the source. You should 
have noticed that you created a `files/default` directory, that's the first l
ocation that `cookbook_file` looks. You can create different directories in 
`files/` like `ubuntu` or `ubuntu12.04` or `redhat` so you can have a different 
format per file. Now I should mention that `files` is just for _static_ files, 
not template-ized files. We'll get there in a bit.

Go ahead and run your `./converge` again, you should see something like this:

```bash
root@chef-book:~/core# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 3 resources
Recipe: base::default
  * package[vim] action install (up to date)
  * package[ntp] action install (up to date)
  * package[build-essential] action install (up to date)
Chef Client finished, 0 resources updated
```

Ah, you got me. We didn't add the ssh recipe to the default run, did we? Go 
ahead and open up `cookbooks/base/recipes/default.rb` and add the following:

```ruby
%w{vim ntp build-essential}.each do |pkg|
   package pkg do
     action [:install]
  end
end

include_recipe "base::ssh"
```

Ok, now go ahead and run `./converge.sh` again. You should see something like this:

```bash
root@chef-book:~/core# ./converge.sh
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
root@chef-book:~/core# vim cookbooks/base/files/default/ssh_config
root@chef-book:~/core# diff -u /etc/ssh/ssh_config cookbooks/base/files/default/ssh_config
--- /etc/ssh/ssh_config 2012-04-02 06:48:45.000000000 -0500
+++ cookbooks/base/files/default/ssh_config 2013-10-22 14:29:22.561680067 -0500
@@ -1,4 +1,4 @@
-
+# this is a comment i added at the top
 # This is the ssh client system-wide configuration file.  See
 # ssh_config(5) for more information.  This file provides defaults for
 # users, and the values can be changed in per-user configuration files
root@chef-book:~/core#
```

Go ahead and run the `./converge.sh` again. You should see no difference now.

```bash
root@chef-book:~/core# diff -u /etc/ssh/ssh_config cookbooks/base/files/default/ssh_config
root@chef-book:~/core#
```

Nice, we now have the ability to install a package, install a config file, and confirm that the service is up and running.

Ok, if you have any chef knowledge, you are probably wondering why we didn't add this to the `run_list`. That's a great question, why not? I wanted to demonstrate how different recipes can call other recipes, or even cookbooks. If you want to use the `run_list` way, all you have to do is add it to `~/core/solo.json`:
```json
{
    "run_list": [ "recipe[base::default]","recipe[base::ssh]" ]
}
```
Don't get me wrong this is extremely important, but I was going to revisit this when we started adding external cookbooks. You made me jump my gun. :P

Now, let's go on to the deployer user.

deployer user
-------------

If you want to [read](http://docs.opscode.com/resource_user.html) about this, here's the [link](http://docs.opscode.com/resource_user.html).

Now first things first; we need to create ssh-keys or you can use your own. If you don't know what ssh-keys are, you could start [here](https://wiki.archlinux.org/index.php/SSH_Keys). If this doesn't make sense....sigh, you probably shouldn't have read this far.

Since I'm lazy, I'll set up passwordless keys with root on the vm that I created:
```bash
root@chef-book:~# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
87:c2:46:95:9a:bc:a6:d9:88:a3:fa:68:e0:c1:c3:75 root@chef-book
The key's randomart image is:
+--[ RSA 2048]----+
|        ..       |
|       ..        |
|     ..o         |
|   . E+  .       |
|o . . +.S .      |
|.=   .o. .       |
|o o. *           |
| +o + .          |
|*o..             |
+-----------------+
root@chef-book:~#
```
Great, now we go to your base cookbook recipes and can define the deployer user.
```
root@chef-book:~# cd solo/cookbooks/base/recipes/
root@chef-book:~/core/cookbooks/base/recipes# vim deployer.rb
```
Let's start out the file:
```ruby
group "deployer" do
  gid 15000
  action :create
end

user "deployer" do
  supports :manage_home => true
  comment "D-Deployer"
  uid 15000
  gid 15000
  home "/home/deployer"
  shell "/bin/bash"
end

directory "/home/deployer/.ssh" do
  owner "deployer"
  group "deployer"
  action :create
end

cookbook_file "/home/deployer/.ssh/authorized_keys" do
  source "deployer_key.pub"
  owner "deployer"
  group "deployer"
  action :create_if_missing
  mode 0600
end
```
Well that seems pretty straight forward right? Walk through it, the `directory` is new, but other than that we've used everything else. Next copy that key you created in and put it as `depolyer_key.pub`.
```bash
root@chef-book:~/core/cookbooks/base/recipes# cd ../files/default/
root@chef-book:~/core/cookbooks/base/files/default# cp ~/.ssh/id_rsa.pub deployer_key.pub
```
And let's converge.
```bash
root@chef-book:~# cd ~/core/
root@chef-book:~/core# ./converge.sh
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
root@chef-book:~/core#
```
Do'h! We did it again, we didn't add it to the recipe. This time, let's add it to the `run_list`.
```bash
root@chef-book:~/core# vim solo.json
```
And change the file to look like this:
```json
{
    "run_list": [ "recipe[base::default]","recipe[base::ssh]","recipe[base::deployer]" ]
}
```
Now `./converge` and you should see something like this. Being that I debugged this as I was writing it, it'll be a tad bit different but you get the point:
```bash
root@chef-book:~/core# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 10 resources
Recipe: base::default
  * package[vim] action install (up to date)
  * package[ntp] action install (up to date)
  * package[build-essential] action install (up to date)
Recipe: base::ssh
  * package[openssh-server] action install (up to date)
  * service[ssh] action enable (up to date)
  * service[ssh] action start (up to date)
  * cookbook_file[/etc/ssh/ssh_config] action create (up to date)
Recipe: base::deployer
  * group[deployer] action create (up to date)
  * user[deployer] action create (up to date)
  * directory[/home/deployer/.ssh] action create (up to date)
  * cookbook_file[/home/deployer/.ssh/authorized_keys] action create_if_missing
    - create new file /home/deployer/.ssh/authorized_keys
    - update content in file /home/deployer/.ssh/authorized_keys from none to d8b45a
        --- /home/deployer/.ssh/authorized_keys 2013-10-23 11:04:00.880898901 -0500
        +++ /tmp/.authorized_keys20131023-3087-wza2om 2013-10-23 11:04:00.880898901 -0500
        @@ -0,0 +1 @@
        +ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkm+Ak5Vmyjq4AzoiqN7NXjPLHgsb62TMYg8TkXB72HDOqqI6e32GVqLRqi4ML08rsQQhRKM/XmGC4LbUplcBt/uPDIidPcT/tl16/M6d9vfvCtQwXvVCxB3gkh61UlxJPayYyJgIeNTVTsgKIiR3+q0KSvGLqpmlCob1tsTgVLFhRKojjUs9OasmY0he4niDQAcMrGYCGiA/I0pTqjcc8NE98bZvqFLlrXEGZP2qvssREfAUYWKm3xK24Viv6VGasNEry3BkhqKUG2JO7QokUp6Chn7PXBElOi2XY9QWG5cEPeb83RZjUEuTaTmYuNBVs9Aewewd5gRXDbj+vrOqx root@chef-book
    - change mode from '' to '0600'
    - change owner from '' to 'deployer'
    - change group from '' to 'deployer'

Chef Client finished, 1 resources updated
root@chef-book:~/core#
```
Now let's test this out.
```bash
root@chef-book:~/core# ssh deployer@localhost
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

deployer@chef-book:~$
```
Badass! Now you can create a default deployer user and change things around as needed. (This will be much more useful later on in the book when we start spinning machines up in the "cloud")

Move on to [Running vagrant provisioning vs a local chef-solo run](07-vagrant-provisioning-vs-local-chef-zero.md)
