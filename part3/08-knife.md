knife
=====
Ok, believe it or not, you're a chef now. You can create simple (but extremely useful) recipes to get provisioning done. You may have even started to pull down cookbooks from the [community](http://community.opscode.com/) and started playing around with them. The next step is the main tool of all chefs, [knife](http://docs.opscode.com/knife.html). 
Before we go any farther, there is a quote in context that as a new chef you need to always keep in your head (I'm paraphrasing it as best I can here):
> Every chef should have a knife, it'll be your best friend you'll use it constantly, but always remember it'll cut you in a heart beat.

Please take that to heart; I have many times screwed up a knife command and caused significant pain.

So let's make sure you have knife. Initally we'll start in the chef-book vm, and we'll move on from there. Type the following:
```bash
root@chef-book:~# knife
ERROR: You need to pass a sub-command (e.g., knife SUB-COMMAND)

Usage: knife sub-command (options)
    -s, --server-url URL             Chef Server URL
    -k, --key KEY                    API Client Key
        --[no-]color                 Use colored output, defaults to false on Windows, true otherwise
    -c, --config CONFIG              The configuration file to use
        --defaults                   Accept default values for all questions
    -d, --disable-editing            Do not open EDITOR, just accept the data as is
    -e, --editor EDITOR              Set the editor to use for interactive commands
    -E, --environment ENVIRONMENT    Set the Chef environment
    -F, --format FORMAT              Which format to use for output
    -u, --user USER                  API Client Username
        --print-after                Show the data after a destructive operation
    -V, --verbose                    More verbose output. Use twice for max verbosity
    -v, --version                    Show chef version
    -y, --yes                        Say yes to all prompts for confirmation
    -h, --help                       Show this message

Available subcommands: (for details, knife SUB-COMMAND --help)

[-- snip --]

** STATUS COMMANDS **
knife status QUERY (options)

** TAG COMMANDS **
knife tag create NODE TAG ...
knife tag delete NODE TAG ...
knife tag list NODE

** UPLOAD COMMANDS **
knife upload PATTERNS

** USER COMMANDS **
knife user create USER (options)
knife user delete USER (options)
knife user edit USER (options)
knife user list (options)
knife user reregister USER (options)
knife user show USER (options)

** XARGS COMMANDS **
knife xargs [COMMAND]

root@chef-book:~#
```
Holy crap that's a lot of stuff. I'm not going to go through each and every one, but if you saw it, then great you're ready to start. If not...well you might want to confirm chef is installed correctly on your vm.

knife.rb
-------

The [knife.rb](http://docs.opscode.com/config_rb_knife.html) file is the configuration file for using knife. Apropos right? Lets start setting one up, if you clicked on the link you'll see that there are a good amount of options, but let's go through the basic configurations you should keep with you. By the way let's start doing this in the  chef-book vm, but you could easyily do these same things on a Mac/Linux box too.
```bash
root@chef-book:~# mkdir .chef
root@chef-book:~# touch .chef/knife.rb
root@chef-book:~# vim .chef/knife.rb
```

```ruby
log_level                :info
log_location             STDOUT
node_name                'chef-book'
client_key               '/etc/chef/chef-book.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef/chef-validator.pem'
chef_server_url          'https://awesomechef-server.at.some.domain.com'
cookbook_path            ["~/cookbooks"]
cache_type               'BasicFile'
cookbook_copyright       "My company that want's the copyright"
cookbook_license         "apachev2"
cookbook_email           "jj.asghar@peopleadmin.com"
```

So this is just an example, but this will be much useful when we move on to the chef-server and knife plugins. The most important out of these are probably `log_level` how much data you want to see, `log_location` where to log it, `cookbook_path` the path to your cookbooks, and the `cookbook_[copyright|licence|email]` because if you fill them out here you want need to do it for `knife cookbook create`.

So let's talk about `knife cookbook create`. Originally you created a simple cookbook, by making the directories, adding the files, good ol' knife creates a foundation for you. As an example:
```bash
root@chef-book:~# mkdir cookbooks
root@chef-book:~# cd cookbooks/
root@chef-book:~/cookbooks# knife cookbook create new_cookbook
** Creating cookbook new_cookbook
** Creating README for cookbook: new_cookbook
** Creating CHANGELOG for cookbook: new_cookbook
** Creating metadata for cookbook: new_cookbook
root@chef-book:~/cookbooks# find new_cookbook/
new_cookbook/
new_cookbook/recipes
new_cookbook/recipes/default.rb
new_cookbook/definitions
new_cookbook/README.md
new_cookbook/CHANGELOG.md
new_cookbook/attributes
new_cookbook/files
new_cookbook/files/default
new_cookbook/providers
new_cookbook/metadata.rb
new_cookbook/resources
new_cookbook/libraries
new_cookbook/templates
new_cookbook/templates/default
root@chef-book:~/cookbooks#
```

As you can see, you have your `recipes/default.rb` your `files/default/` directory. Laziness wins out! Oh, I should mention you didn't have to run `knife cookbook create new_cookbook` from the `~/cookbooks` directory, I just did it so I could run `find new_cookbook/` for the demonstration.

Ok, let's move on to [knife-plugins](09-knife-plugins.md), you are probably wondering why, mainly because `knife` is designed to interact with something provisioning, so lets add pick up some plugins.
