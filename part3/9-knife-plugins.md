knife plugins
=============
There are a TON more of [knife-plugins](http://docs.opscode.com/plugin_knife.html), then officially posted on the docs site.  [Github](https://github.com/search?q=knife+plugin&type=Repositories&ref=searchresults) is a great place to look but I'm going to focus on 4 here. 

knife-solo is a great tool to emulate a chef-server with just knife commands, this is a poormans version, but it works extremely well.

knife rackspace is a way to interact directly with the rackspace Openstack api, allowing you to spin up boxes via the commandline and even provision them farther leveraging the chef-server of your choice. I'm only going to show spinning up and down boxes here, we don't have a chef-server running yet right?.....right? ;)

knife ec2, is the amazon version of knife rackspace if you will, there aren't terribly number of differences, but i wanted to make sure you realize that you have to choose which version to run to talk to which back end.

knife spork is a great tool for multiple chefs working with one chef-server. I'm only going to touch on it briefly, being again, we _shouldn't_ have a chef-server running....yet.

knife-solo
----------

knife rackspace
----------

knife ec2
----------

knife spork
----------
