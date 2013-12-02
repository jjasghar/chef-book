omnibus vs gem
--------------

Before we go any farther, we should discuss the difference and choice to use [omnibus](https://github.com/opscode/omnibus-software) over the [chef](http://rubygems.org/gems/chef) gem.

Omnibus is a simple binary that installs everything you need to run chef at `/opt/chef/`. It installs a version of ruby specifically for the chef binaries and is designed to work out of the box. Hell, all you need to do is run:
```bash
curl -L https://www.opscode.com/chef/install.sh | sudo bash
```
And you have it installed.

The gem installation procedure is the standard `gem install chef` which will work, but that's assuming you already have ruby installed. The omnibus installer will un-intrusively containerize well-tested dependencies for chef in `/opt/chef/` so you won't need to spend time installing or configuring anything further before you can start using chef to provision your systems.

It can be a personal choice. There is nothing stopping you from doing `gem install chef`, but I strongly suggest using omnibus.

If you are already familiar with ruby, the gem install is not an intimidating step. On the other hand, if you lean towards something like python or don't have ruby installed at all, you can still use chef like we did with the vagrant box with a simple curl install.

You might also have noticed that the base box already has chef and puppet installed. While this is true, you never know if they are up to date versions. A reinstall with the omnibus package should automatically supercede any existing installation.

Move on to [chef-solo](../part2/05-chef-solo.md)
