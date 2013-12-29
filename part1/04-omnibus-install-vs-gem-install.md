Omnibus vs Gem
--------------

Before we go any further, we should discuss the difference and choice to use [Omnibus](https://github.com/opscode/omnibus-software) over the [Chef](http://rubygems.org/gems/chef) gem.

Omnibus is a simple binary that installs everything you need to run chef at `/opt/chef/`. It comes with a version of Ruby embedded specifically chef to work out of the box. Hell, all you need to do is run:
```bash
curl -L https://www.opscode.com/chef/install.sh | sudo bash
```
And you have it installed.

The gem installation procedure is the standard `gem install chef` which will work, but that's assuming you already have Ruby installed. The Omnibus installer will un-intrusively containerize well-tested dependencies for chef in `/opt/chef/` so you won't need to spend time installing or configuring anything further before you can start using Chef to provision your systems.

It can be a personal choice. There is nothing stopping you from doing `gem install chef`, but I strongly suggest using Omnibus.

If you are already familiar with Ruby, the gem install is not an intimidating step, and you may want to explicitly control your Ruby environment for some reason. On the other hand, if you lean towards something like python or don't have ruby installed at all, you can still use chef like we did with the Vagrant box with a simple curl install. Likewise, for a production environment Omnibus can be a good choice because that way your configuration management system doesn't depend on your system or application Ruby install. If someone breaks that, you can still use Chef to fix it.

You might also have noticed that the base box already has Chef and Puppet installed. While this is true, you never know if they are up to date versions. A reinstall with the Omnibus package should automatically supercede any existing installation.

Move on to [chef-solo](../part2/05-chef-solo.md)
