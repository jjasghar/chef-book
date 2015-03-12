# Environments Roles Oh-my!

So you've made it this far, if you think you've grasped most of this, I really am proud of you.  Take a moment realize the feat you've accomplished and enjoy it; because now we are going to make it even more confusing.

## Environments

Ok, in a previous section i mentioned about versioning. Keep this in mind for this section. [Environments](http://docs.opscode.com/essentials_environments.html) are way's to group machines in logical groups, such as Production, Staging, and Development. The default environment is called `_default` which you might have noticed if you poked around your chef server.  Kudo's if you did. Now lets look at a typical `production.json`:

```json
{
  "name": "production",
  "description": "production environment",
  "cookbook_versions": {
    "base": "= 0.1.0",
    "postfix": "= 1.0.0"
  },
  "json_class": "Chef::Environment",
  "chef_type": "environment",
  "default_attributes": {
    },
  "override_attributes": {
     "base": {
       }
  }
}
```

Now this should look pretty straight forward, your production environment now is _pinned_ to version 0.1.0, and if you update your cookbook to 0.1.1 you it won't converge with the new code. This is obviously great for environments where you want consiantcy like *a-hem*production*a-hem*. If you also notice that section for "override_attributes" that allows for you to _on a_ per environment basis over ride possible attributes that you declare. This example is actaully superfulous, being there is no attributes in the base recipe but it's just an example. The link I put at the top of this section is a great resource, the only problem is that it's REALLY REALLY confusing. As you start thinking about your logical setups for your machines, refer back to it, over time it'll become more and more clear.

## Roles

If environments are to pin versions of cookbooks to certain groups of servers, [roles](http://docs.opscode.com/essentials_roles.html) are to put groups of cookbooks together.  You'll probably want a role of "web" for your web servers, a role of "database" for your database servers, etc, roles give you that flexibility. A small, but typical role.json is as follows:

```json
{
  "name": "web",
  "description": "Web Server",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[nagios::client]",
    "recipe[apache]",
    "role[base]"
  ],
  "env_run_lists": {
  }
}
```

As you can see it has some of the same options as the environtments but the `run_list` is the most important part of this json. In this example i'm using the client recipe from the nagios cookbook, installing apache, and calling another role called base. So you can have roles call other roles so you have have super set if you want.

So lets start talking about [getting more cookbooks](15-places-to-find-cookbooks.md) so this could be more relevent. 
