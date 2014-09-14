# Uploading your cookbook to your chef server

So you have a working chef server eh? Great! Now let's actually start working with it.  Before you start anything, I need you to run something like this:
```bash
root@chef-book:~# knife status
1 minute  ago, chef-book, chef-book, 10.0.2.15, ubuntu 12.04.
root@chef-book:~#
```
If `knife` can talk to your chef server you are good to go. If not, [hop back](../README.md#contents) a couple sections and try to figure out what broke. Don't worry I'll be here when you get back.

Perfect, lets start off.

Remember that cookbook you created? Way back in [Part 2-6](../part2/06-write-simple-base-cookbook.md) we're gonna upload that one first off. Go ahead and look at your `knife.rb` for me:
```bash
root@chef-book:~# cat .chef/knife.rb
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key     '~/.chef/admin.pem'
chef_server_url          'https://ec2-23-20-27-29.compute-1.amazonaws.com'
syntax_check_cache_path  '/root/.chef/syntax_check_cache'
root@chef-book:~#
```
If you notice I don't have a `cookbook_path` directory, i need add one:
```bash
root@chef-book:~# cat .chef/knife.rb
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key     '~/.chef/admin.pem'
cookbook_path            ["~/cookbooks"]
chef_server_url          'https://awesome-chef-server.domain.com'
syntax_check_cache_path  '/root/.chef/syntax_check_cache'
root@chef-book:~#
```
Pretty self explaintory eh? Go ahead and copy that `base/` cookbook into the directory that you declare on that line:
```bash
root@chef-book:~# cp -r /vagrant/cookbooks/base/ cookbooks/
```

Lets try and upload the cookbook:
```bash
root@chef-book:~# knife cookbook upload base
Uploading base         [0.0.0]
Uploaded 1 cookbook.
root@chef-book:~#
```
Awesome! You uploaded your first cookbook. Notice the `[0.0.0]` that is controlled about the [metadata.rb](http://docs.opscode.com/essentials_cookbook_metadata.html) file. We'll talk about that is a sec.

Now let's add base to the `run_list`:
```bash
root@chef-book:~# knife node run_list add chef-book base
chef-book:
  run_list: recipe[base]
  root@chef-book:~#
```

Nice! That looks a tad bit fimilar right? Go ahead and run `chef-client` now:
```bash
root@chef-book:~# chef-client
[2013-10-29T18:44:51+00:00] INFO: Forking chef instance to converge...
Starting Chef Client, version 11.6.2
[2013-10-29T18:44:51+00:00] INFO: *** Chef 11.6.2 ***
[2013-10-29T18:44:52+00:00] INFO: Run List is [recipe[base]]
[2013-10-29T18:44:52+00:00] INFO: Run List expands to [base]
[2013-10-29T18:44:52+00:00] INFO: Starting Chef Run for chef-book
[2013-10-29T18:44:52+00:00] INFO: Running start handlers
[2013-10-29T18:44:52+00:00] INFO: Start handlers complete.
resolving cookbooks for run list: ["base"]
[2013-10-29T18:44:52+00:00] INFO: Loading cookbooks [base]
Synchronizing Cookbooks:
  - base
Compiling Cookbooks...
Converging 6 resources
Recipe: base::default
  * package[vim] action install[2013-10-29T18:44:52+00:00] INFO: Processing package[vim] action install (base::default line 2)
 (up to date)
  * package[ntp] action install[2013-10-29T18:44:52+00:00] INFO: Processing package[ntp] action install (base::default line 2)
 (up to date)
  * package[build-essential] action install[2013-10-29T18:44:52+00:00] INFO: Processing package[build-essential] action install (base::default line 2)
 (up to date)
Recipe: base::ssh
  * package[openssh-server] action install[2013-10-29T18:44:53+00:00] INFO: Processing package[openssh-server] action install (base::ssh line 2)
 (up to date)
  * service[ssh] action enable[2013-10-29T18:44:53+00:00] INFO: Processing service[ssh] action enable (base::ssh line 6)
 (up to date)
  * service[ssh] action start[2013-10-29T18:44:53+00:00] INFO: Processing service[ssh] action start (base::ssh line 6)
 (up to date)
  * cookbook_file[/etc/ssh/ssh_config] action create[2013-10-29T18:44:53+00:00] INFO: Processing cookbook_file[/etc/ssh/ssh_config] action create (base::ssh line 11)
 (up to date)
[2013-10-29T18:44:53+00:00] INFO: Chef Run complete in 1.207592063 seconds
[2013-10-29T18:44:53+00:00] INFO: Removing cookbooks/base/files/default/ssh_config from the cache; it is no longer needed by chef-client.
[2013-10-29T18:44:53+00:00] INFO: Running report handlers
[2013-10-29T18:44:53+00:00] INFO: Report handlers complete
Chef Client finished, 0 resources updated
```
CHA-CHING!!!! Congrats you have uploaded your cookbook and run the client to apply it. Awesome!

Lets talk about that [metadata.rb](13-metadata.rb-primer.md).
