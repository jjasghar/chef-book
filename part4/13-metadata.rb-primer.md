# metadata.rb

The [metadata](http://docs.opscode.com/essentials_cookbook_metadata.html).rb is the core file that gives extemely useful data about the cookbook. Also if you noticed when you uploaded the cookbook the version was `[0.0.0]`.

```bash
root@chef-book:~# knife cookbook upload base
Uploading base         [0.0.0]
Uploaded 1 cookbook.
root@chef-book:~#
```

The metadata.rb controls the version number like above, and a lot other basic generic data. If you recall back to the [knife.rb](part3/8-knife.md#kniferb) section where you created the cookbook, `new_cookbook/metadata.rb` was created. If you have blown it away, this is what it looks like:

```ruby
name             'new_cookbook'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures new_cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
```

Pretty straight forward eh? Now because we didn't have `metadata.rb` in your base cookbook, you couldn't control your version number. Lets do that now:

```ruby
name             'base'
maintainer       'JJ Asghar'
maintainer_email 'jj.asghar@peopleadmin.com'
license          'All rights reserved'
description      'Installs/Configures base'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
```

As of chef 11.8, the `name` is required for converges to complete. I've searched high and low for the ticket that's associated with this; but here's the general [release notes](http://docs.opscode.com/release_notes.html).  Luckily the error is extremely obvious if you don't have have `name`, and the fix is to add it. ;)

And lets upload it:

```bash
root@chef-book:~/cookbooks/base# cd ..
root@chef-book:~/cookbooks# knife cookbook upload base
ERROR: Errno::ENOENT: No such file or directory - /root/cookbooks/base/README.md
root@chef-book:~/cookbooks#
```

Do'h! It seem we need a `README.md` now, this is great habit to have. I'm lazy so I'll just touch the file:

```bash
root@chef-book:~/cookbooks# touch /root/cookbooks/base/README.md
root@chef-book:~/cookbooks# knife cookbook upload base
Uploading base           [0.1.0]
Uploaded 1 cookbook.
root@chef-book:~/cookbooks#
```

Now check out your cookbooks on your server and you should see `[0.1.0]`.

Lets take a step back from chef and talk about versioning. The chef community has basiclly decided that [Semantic Versioning](http://semver.org/) is the defacto standard for cookbooks. There is A TON of data on that link, but to sum it up I explain it like this:
> A patch change is "x.y.Z". Anything larger than a patch, example adding a test, is a "x.Y.z" change. Anything that adds new functionality for an internal cookbook is "X.y.z," if you are pulling public run cookbooks stick with the system they use.

It's not 100% accurate, but it's a great rule of thumb.

Ok, so why should I care about versioning, well it's good to track your changes right? It's also a great way "pin" versions for different environments, which I'll talk about [next](14-environments-roles-oh-my.md).
