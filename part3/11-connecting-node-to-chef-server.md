# Connecting a Node to chef server

The main part of chef that allows you to connect a _node_ to a chef server is called `chef-client`. [chef-client](http://docs.opscode.com/chef_client.html) is pretty straight forward, it looks at your node name, then checks your client.pem file, and if that isnt there looks at your vaildation.pem and sends an API call out saying; hey what should my `run_list` be? Then pulls down the cookbooks or relivant files, kicks off the compile, then applies the deltas. Or in simpler terms, chef-client checks the `run_list` against the chef-server, pulls any changes then runs chef-solo locally. NOTE: the previous statement isn't 100% true, but logically speaking it's really really close.

As you can see, the difference between chef-client/server and chef-solo is actaully pretty negagiable; so yes I was telling the truth about the 75-85% coverage of chef-solo. ;)

Being that Hosted chef and open source chef have a tad differance hooking up nodes to the chef-server, i'll cover both here. Ideally this will be the last time i call out the differance.

## Open Source Chef server

With the open source chef server, the best way to get a random machince to "check-in" with it, is using the `vaildation.pem` or `chef-validator`. In order to get it, you need to go to the chef-webui, and click on the client tab  then edit by "chef-validator" and then click the box "Regenerate Private Key", then "Save Client", copy the Private Key down put it in 2 locations calling it `validation.pem`. This is your "key" into the open source chef server box.

On the vm do this:

```bash
root@chef-book:~# mkdir /etc/chef
root@chef-book:~# cp opensource_vaildation.pem /etc/chef/validation.pem
```

Now open your `knife.rb` and make these changes.

```ruby
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '~/.chef/admin.pem'
chef_server_url          'https://awesome-chef-server.domain.com'
syntax_check_cache_path  '/root/.chef/syntax_check_cache'
validation_client_name   'chef-validator'
validation_key           '/etc/chef/validation.pem'
```

Next create a `/etc/chef/client.rb` file:

```ruby
log_level        :info
log_location     STDOUT
chef_server_url  "https://awesome-chef-server.domain.com"
validation_client_name "chef-validator"
node_name "chef-book"
```

Now run `chef-client` and you should see something like this:

```bash
root@chef-book:~# chef-client
[2013-10-29T16:51:12+00:00] INFO: Forking chef instance to converge...
Starting Chef Client, version 11.6.2
[2013-10-29T16:51:12+00:00] INFO: *** Chef 11.6.2 ***
Creating a new client identity for chef-book using the validator key.
[2013-10-29T16:51:12+00:00] INFO: Client key /etc/chef/client.pem is not present - registering
[2013-10-29T16:51:13+00:00] INFO: Run List is []
[2013-10-29T16:51:13+00:00] INFO: Run List expands to []
[2013-10-29T16:51:13+00:00] INFO: Starting Chef Run for chef-book
[2013-10-29T16:51:13+00:00] INFO: Running start handlers
[2013-10-29T16:51:13+00:00] INFO: Start handlers complete.
resolving cookbooks for run list: []
[2013-10-29T16:51:14+00:00] INFO: Loading cookbooks []
Synchronizing Cookbooks:
Compiling Cookbooks...
[2013-10-29T16:51:14+00:00] WARN: Node chef-book has an empty run list.
Converging 0 resources
[2013-10-29T16:51:14+00:00] INFO: Chef Run complete in 0.983694725 seconds
[2013-10-29T16:51:14+00:00] INFO: Running report handlers
[2013-10-29T16:51:14+00:00] INFO: Report handlers complete
Chef Client finished, 0 resources updated
root@chef-book:~#
```

HUZZAH! You have successfully connected your chef-book vm to your opensource chef server, check the WebUI again and you should see `chef-book` under nodes and clients.

Congrats!

## Hosted Chef server

First things first, you need to go [here](https://manage.opscode.com/login) and log in with you credentials you created earlier. Assuming you haven't added any nodes yet you should see a friendly "You have no nodes - try connecting one, or creating or editing a node" reminder. Don't bother with creating a node by hand right now, let's use the validator like we did with Open Source chef. Click on "Clients" and you should see "<your-org-name>-validator". Click on that "Regenerate API Key" and copy it to two locations because this is your key to authenticatiing your machnines to this hosted box.
Go ahead and copy that pem file to your Vagrant box, i suggest throwing it in the location of Vagrantfile, so you can just copy it in via /vagrant. So something like this:

```bash
[~] % cp Downloads/<org-name>-validator.pem ~/vagrant/chef-book
root@chef-book:~# cp /vagrant/<org-name>-validator.pem ./
```

Ok, now lets edit the `~/.chef/knife.rb`, `/etc/chef/client.rb` files so they can talk to it:

```ruby
log_level                :info
log_location             STDOUT
node_name                "nodename"
client_key               '~/.chef/nodename.pem'
chef_server_url          "https://api.opscode.com/organizations/<org-name>"
syntax_check_cache_path  '/root/.chef/syntax_check_cache'
validation_client_name   'chef-validator'
validation_key           '/root/<org-name>-validator.pem'
```

Before you edit the next file, if you used Open Source chef you need to move the `/etc/chef/client.pem` away because you'll get in some nasty auth issues. After that then you can edit the `/etc/chef/client.rb`:

```ruby
log_level        :info
log_location     STDOUT
chef_server_url  "https://api.opscode.com/organizations/<org-name>"
validation_client_name "<org-name>-validator"
node_name "chef-book"
validation_key           "/root/<org-name>-validator.pem"
```

Now run `chef-client` and you should see something like this:

```bash
root@chef-book:~# chef-client
[2013-10-29T17:40:14+00:00] INFO: Forking chef instance to converge...
Starting Chef Client, version 11.6.2
[2013-10-29T17:40:14+00:00] INFO: *** Chef 11.6.2 ***
Creating a new client identity for chef-book using the validator key.
[2013-10-29T17:40:15+00:00] INFO: Client key /etc/chef/client.pem is not present - registering
[2013-10-29T17:40:16+00:00] INFO: Run List is []
[2013-10-29T17:40:16+00:00] INFO: Run List expands to []
[2013-10-29T17:40:16+00:00] INFO: Starting Chef Run for chef-book
[2013-10-29T17:40:16+00:00] INFO: Running start handlers
[2013-10-29T17:40:16+00:00] INFO: Start handlers complete.
resolving cookbooks for run list: []
[2013-10-29T17:40:16+00:00] INFO: Loading cookbooks []
Synchronizing Cookbooks:
Compiling Cookbooks...
[2013-10-29T17:40:16+00:00] WARN: Node chef-book has an empty run list.
Converging 0 resources
[2013-10-29T17:40:16+00:00] INFO: Chef Run complete in 0.736758934 seconds
[2013-10-29T17:40:16+00:00] INFO: Running report handlers
[2013-10-29T17:40:16+00:00] INFO: Report handlers complete
Chef Client finished, 0 resources updated
root@chef-book:~#
```

Congrats! You've connected a your chef-book vm to Hosted Chef!

Now lets go on to [uploading cookbooks](../part4/12-uploading-running-chef-client.md).
