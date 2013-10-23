knife
=====
Ok, believe it or not, you're a chef now. You can create simple (but extremely useful) recipes to get provisioning done. You may have even started to pull down cookbooks from the [community](http://community.opscode.com/) and started playing around with them. The next step is the main tool of all chefs, [knife](http://docs.opscode.com/knife.html). 
Before we go any farther, there is a quote in context that as a new chef you need to always keep in your head (I'm paraphrasing it as best I can here):
> Every chef should have a knife, it'll be your best friend you'll use it constantly, but always remember it'll cut you in a heart beat.
Please take that to heart, so many times have a screwed up my knife command causing significant pain.

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
