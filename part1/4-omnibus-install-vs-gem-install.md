omnibus vs gem
--------------

Before we go any farther, we should discuss the difference and choice to use [omnibus](https://github.com/opscode/omnibus-software) over the [chef](http://rubygems.org/gems/chef) gem.

Omnibus is a simple binary that installs everything you need to run chef at `/opt/chef/`. It comes with a version of ruby specifically for the chef binaries and it basically works out of the box. Hell all you need to do is run:
```bash
curl -L https://www.opscode.com/chef/install.sh | sudo bash
```
And you have it installed.

The gem is the typical `gem install chef` installation which for most will work, but that's assuming you have ruby already installed. Omnibus dosen't require ruby,  and extremely un-intrusive, and dosen't require separate ruby installation on every box it runs.

It can be a personal choice though, there is nothing stopping you from doing the `gem install chef`, but I strongly suggest omnibus.

If you are already a ruby leaning person, the gem install is not much of a step to get going. On the other hand, if you lean towards something like python, and don't have ruby installed at all, you can still use chef like we did with the vagrant box, with a simple curl install.

You might have realized also that the base box that comes from vagrant already has chef and puppet installed. Yes this is true, but you never know if it's up to date or not. Hence the reinstall with the omnibus package.

Move on to [chef-solo](../part2/5-chef-solo.md)
