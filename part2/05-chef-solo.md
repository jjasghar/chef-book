chef-solo
---------

So we have a working _disposable_ vm with with Vagrant now? Great, let's actually start playing with Chef. We're going to start with [chef-solo](http://docs.opscode.com/chef_solo.html), which, believe it or not, can cover 75-85% of the use cases of Chef. Keep this in mind, as you go through this book, because honestly if it fits there may be no need to go farther.

The first thing to do is make sure that you are running the correct version of `chef-solo`. Restart your Vagrant box with `vagrant up` if you have stopped or destroyed it. Type these following commands in to confirm we are set up correctly.
```bash
14:51:58 [~/vagrant/chef-book] % vagrant ssh
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Mon Oct 21 13:49:19 2013 from 10.0.2.2
vagrant@chef-book:~$ sudo -i
root@chef-book:~# which chef-solo
/usr/bin/chef-solo
root@chef-book:~# ls -l /usr/bin/chef-solo
lrwxrwxrwx 1 root root 23 Oct 21 13:47 /usr/bin/chef-solo -> /opt/chef/bin/chef-solo
```
If you see something like the above, you have chef-solo installed correctly, and you are good to go. If not, I strongly suggest starting over and trying to get here cleanly.

After this, go ahead and run `chef-solo`.
```bash
root@chef-book:~# chef-solo
[2013-10-21T14:53:44-05:00] WARN: *****************************************
[2013-10-21T14:53:44-05:00] WARN: Did not find config file: /etc/chef/solo.rb, using command line options.
[2013-10-21T14:53:44-05:00] WARN: *****************************************
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
[2013-10-21T14:53:45-05:00] FATAL: No cookbook found in ["/var/chef/cookbooks", "/var/chef/site-cookbooks"], make sure cookbook_path is set correctly.
[2013-10-21T14:53:45-05:00] FATAL: No cookbook found in ["/var/chef/cookbooks", "/var/chef/site-cookbooks"], make sure cookbook_path is set correctly.
[2013-10-21T14:53:45-05:00] ERROR: Running exception handlers
[2013-10-21T14:53:45-05:00] ERROR: Exception handlers complete
[2013-10-21T14:53:45-05:00] FATAL: Stacktrace dumped to /var/chef/cache/chef-stacktrace.out
Chef Client failed. 0 resources updated
[2013-10-21T14:53:45-05:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
root@chef-book:~#
```
Yep, it ain't happy. That's expected at this stage. I just wanted to make sure you saw it in an error state before taking a stab at it.

OK, so we can start a `chef-solo` process/run, now let's actually talk about `chef-solo`. In the simplest terms, `chef-solo` is configuration management software that runs through some preset configuration operations, and renders the machine in the state they describe. `chef-solo`, nay all of chef, uses a compiled top down set of instuctions, or _recipes_, to build the machine you want. You can see that this process starts with the `Compiling Cookbooks...` line.

In a more elegant quote from the [docs](http://docs.opscode.com/chef_solo.html) on the opscode site:
> chef-solo is an open source version of the chef-client that allows using cookbooks with nodes without requiring access to a server. chef-solo runs locally and requires that a cookbook (and any of its dependencies) be on the same physical disk as the node.

Now let's go on to actually running it successfully!

Move on to [A simple cookbook](06-write-simple-base-cookbook.md)
