# Connecting a Node to chef server

The main part of chef that allows you to connect a _node_ to a chef server is called `chef-client`. [chef-client](http://docs.opscode.com/chef_client.html) is pretty straight forward, it looks at your node name, then checks your client.pem file, and if that isnt there looks at your vaildation.pem and sends an API call out saying; hey what should my `run_list` be? Then pulls down the cookbooks or relivant files, kicks off the compile, then applies the deltas. Or in simpler terms, chef-client checks the `run_list` against the chef-server, pulls any changes then runs chef-solo locally. NOTE: the previous statement isn't 100% true, but logically speaking it's really really close.

As you can see, the difference between chef-client/server and chef-solo is actaully pretty negagiable; so yes I was telling the truth about the 75-85% coverage of chef-solo. ;)

Being that Hosted chef and open source chef have a tad differance hooking up nodes to the chef-server, i'll cover both here. Ideally this will be the last time i call out the differance.

## Open Source Chef server


## Hosted Chef server
