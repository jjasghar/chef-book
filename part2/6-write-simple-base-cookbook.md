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
root@chef-book:~/base# chmod +x converge.sh
root@chef-book:~/base# ./converge.sh
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
root@chef-book:~/base# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
[2013-10-21T15:21:36-05:00] ERROR: Running exception handlers
[2013-10-21T15:21:36-05:00] ERROR: Exception handlers complete
[2013-10-21T15:21:36-05:00] FATAL: Stacktrace dumped to /root/base/chef-stacktrace.out
Chef Client failed. 0 resources updated
[2013-10-21T15:21:36-05:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
root@chef-book:~/base# cat /root/base/chef-stacktrace.out
```
The most important part about the chef-stacktrace.out is this one:
```ruby
Chef::Exceptions::CookbookNotFound: Cookbook base not found. If you're loading base from another cookbook, make sure you configure the dependency in your metadata
```
And that's expected, you haven't created one yet!

base cookbook
-------------

Ok, you are at `~/base` right? Good, go ahead and type `mkdir -p cookbooks/base/recipes/` and `cd` to that directory.
```bash
root@chef-book:~/base# mkdir -p cookbooks/base/recipes/
root@chef-book:~/base# cd cookbooks/base/recipes/
root@chef-book:~/base/cookbooks/base/recipes#
```
Now we need to create the `default.rb` file. Open up your favorite text editor and write the following. Now you'll notice that I'm using `nano` here, it's not my favor, far be it, but this is to show the first installation of software.
```bash
root@chef-book:~/base/cookbooks/base/recipes# nano default.rb
```

```ruby
package 'vim'
```
Now logically this will install `vim` right? Yep, and we're about to see that. Go ahead and go up to `~/base`, and run `./converge.sh`, you should see something like this:
```bash
root@chef-book:~/base/cookbooks/base/recipes# cd ~/base
root@chef-book:~/base# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 1 resources
Recipe: base::default
  * package[vim] action install
    - install version 2:7.3.429-2ubuntu2.1 of package vim

Chef Client finished, 1 resources updated
root@chef-book:~/base#
```
Congratulations! You have successfully installed the greatest editor using `chef-solo`! Don't believe me? type `vim`. Go ahead and run `./converge.sh` again, it should look like this:
```bash
root@chef-book:~/base# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 1 resources
Recipe: base::default
  * package[vim] action install (up to date)
Chef Client finished, 0 resources updated
root@chef-book:~/base#
```
This is important, as you can see it didn't _reinstall_ it. It just checked that `vim` was installed and then it moved on. Badass.

If you want to skip ahead, check out the [resources](http://docs.opscode.com/resource.html) and see what cool things you can do. Don't worry I'll walk y'all through some more.

So let's add a couple more packages to our base recipe (`~/base/cookbooks/base/recipes/default.rb`), there are two ways you can do this. One is just add line by line, like:
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
Both are basiclly, the same, the second one is just more rubyish. Go ahead and `cd ~/base/` and run `./convege.sh` again.
```bash
root@chef-book:~/base# ./converge.sh
Starting Chef Client, version 11.6.2
Compiling Cookbooks...
Converging 3 resources
Recipe: base::default
  * package[vim] action install (up to date)
  * package[ntp] action install (up to date)
  * package[build-essential] action install (up to date)
Chef Client finished, 0 resources updated
root@chef-book:~/base#
```

Congrats man, no you can install packages via chef and confirm that they are there.


