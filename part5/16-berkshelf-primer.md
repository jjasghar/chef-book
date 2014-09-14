# Berkshelf

[Berkshelf](http://berkshelf.com/) has become the defacto standard for dealing with dependancies with cookbooks. To quote from the site:
> If you’re familiar with Bundler, then Berkshelf is a breeze.

A great example is straight from the main site:
## Install
```bash
root@chef-book:~# gem install berkshelf
1 gem installed
root@chef-book:~#
```

Next, let's create a `Berksfile`. Go to a your base cookbook and type `berks init .` you should see something like this:
```bash
root@chef-book:~/core# berks init .
By default, this cookbook was generated to support bundler, however, bundler is not installed.
To skip support for bundler, use --no-bundler
To install bundler: gem install bundler
      create  Berksfile
      create  Thorfile
      create  .gitignore
         run  git init from "."
      create  Gemfile
      create  Vagrantfile
Successfully initialized
```
Go ahead and add the following to your `Berksfile`:
```ruby
site :opscode

cookbook 'mysql'
cookbook 'nginx', '~> 0.101.5'
```
Then run `berks install` to grab the depenancies:
```bash
root@chef-book:~/cookbooks# cd base/
root@chef-book:~/cookbooks/base# berks install
Installing mysql (3.0.12) from site: 'http://cookbooks.opscode.com/api/v1/cookbooks'
Installing nginx (0.101.6) from site: 'http://cookbooks.opscode.com/api/v1/cookbooks'
Installing openssl (1.1.0) from site: 'http://cookbooks.opscode.com/api/v1/cookbooks'
Installing build-essential (1.4.2) from site: 'http://cookbooks.opscode.com/api/v1/cookbooks'
Installing runit (1.3.0) from site: 'http://cookbooks.opscode.com/api/v1/cookbooks'
Installing yum (2.4.0) from site: 'http://cookbooks.opscode.com/api/v1/cookbooks'
Installing bluepill (2.3.0) from site: 'http://cookbooks.opscode.com/api/v1/cookbooks'
Installing rsyslog (1.9.0) from site: 'http://cookbooks.opscode.com/api/v1/cookbooks'
Installing ohai (1.0.2) from site: 'http://cookbooks.opscode.com/api/v1/cookbooks'
root@chef-book:~/cookbooks/base#
```
Nice! Go ahead and upload it if neeed, add it to your `run_list` and run `chef-solo` or `chef-client` you should get mysql and nginx installed.

## knife-solo

Remember that [knife-solo](../part3/09-knife-plugins.md#knife-solo) thing? I mentioned the _cookbooks_ directory. This is the temp location that berks dumps the cookboks you want to push up. Keep this in mind as you start to play with it.

With knife-solo you can add the above to the `Berksfile` that was created, and it'll automatically install what you are looking for, something like this:
```bash
[~/do]% vim nodes/162.244.68.215.json
```
```json
{"run_list":["recipe[nginx::default]","recipe[mysql::default]"]}
```
Then:
```bash
[~/do] % knife solo cook root@162.243.68.215
Running Chef on 162.243.68.215...
Checking Chef version...
Installing Berkshelf cookbooks to 'cookbooks'...
Using mysql (3.0.12)
Using nginx (0.101.6)
Using openssl (1.1.0)
Using build-essential (1.4.0)
Using runit (1.0.6)
Using bluepill (2.3.0)
Using rsyslog (1.9.0)
Using yum (2.3.0)
Using ohai (1.0.2)
Uploading the kitchen...
Generating solo config...
Running Chef...
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Recipe: ohai::default
  * remote_directory[/etc/chef/ohai_plugins] action create
    - create new directory /etc/chef/ohai_plugins
    - change mode from '' to '0755'
    - change owner from '' to 'root'
    - change group from '' to 'root'Recipe: <Dynamically Defined Resource>
  * cookbook_file[/etc/chef/ohai_plugins/README] action create
    - create new file /etc/chef/ohai_plugins/README
    - update content in file /etc/chef/ohai_plugins/README from none to 775fa7

[-- snip --]

Recipe: nginx::default
  * service[nginx] action start
    - start service service[nginx]

Recipe: mysql::client
  * package[mysql-client] action install
    - install version 5.1.72-0ubuntu0.10.04.1 of package mysql-client

  * package[libmysqlclient-dev] action install
    - install version 5.1.72-0ubuntu0.10.04.1 of package libmysqlclient-dev

Chef Client finished, 13 resources updated
```

There's a ton more to Berkshelf, but as you can see it can make file a lot easier.  But like `apt-get` or `yum` it'll install it as the defaults from the cookbook maintainers. You'll still need to go in and configure it locally. Hint: maybe a recipe in a "company" cookbook that overwrites the defaults?
