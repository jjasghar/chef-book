chef-solo
---------

So we have a working _disposable_ vm with with vagrant now? 
Great, let's actually start playing with chef.  
We're going to start with [chef-zero][cz] (or chef-client that uses a local server), 
which believe it or not can cover 75-85% of the use cases of chef. 
Keep this in mind as you go through this book, because honestly if it fits then 
there is no need to over-engineer your solutions.

Since we installed the chef-dk during our vm-setup, we already have the 
chef-client with chef-zero.

Restart your vagrant box with `vagrant up` if you have stopped or destroyed it. 
Type these following commands in to confirm we are set up correctly.


Let's run chef-zero:

```bash

~/vagrant/chef-book $ vagrant ssh                                                                                                                               davedash@immacomputer
Welcome to Ubuntu 12.04.4 LTS (GNU/Linux 3.2.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Sat Jun 28 10:35:10 2014 from 10.0.2.2
vagrant@chef-book:~$ sudo su -
root@chef-book:~# chef-client -z
[2014-06-28T12:42:31-07:00] WARN: No config file found or specified on command line, using command line options.
[2014-06-28T12:42:31-07:00] WARN: No cookbooks directory found at or above current directory.  Assuming /root.
[2014-06-28T12:42:31-07:00] WARN:
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
[2014-06-28T12:42:33-07:00] WARN: Node chef-book has an empty run list.
Converging 0 resources

Running handlers:
Running handlers complete

Chef Client finished, 0/0 resources updated in 1.523881501 seconds
root@chef-book:~#

```

A few complaints about SSL, but other than that... nothing really happened. 
Chef, uses a compiled top down set of instructions, or _recipes_, 
to build a machine how 
you want it to be. You can see that this process starts with 
the `Compiling Cookbooks...` line.  But there's nothing to compile.

Now let's go on to actually running it successfully!

Move on to [A simple cookbook](06-write-simple-base-cookbook.md)

[cz]: http://www.getchef.com/blog/2013/10/31/chef-client-z-from-zero-to-chef-in-8-5-seconds/
