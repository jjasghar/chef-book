# Open Source vs Hosted Chef Server

If you've made it this far, you're either extremely determined to learn as much as you can about chef or you think you need to use chef server.  I'd like to start by saying (again) that 75-85% of use cases can be resolved with just chef-solo. chef server adds a level of overhead that unless you have a use case for it, really isn't that useful. (You have been warned...again.)

I'm going to spend this section talking about the two _main_ types of chef servers you can run.  I'll run through the requirements of each, how to set them up, and then the next section we'll attach our chef-book vm to each of them. NOTE: you can only have a machine check in with ONE chef server, so I'll start with Open Source chef, then remove it and have it check in with Hosted chef.

During the rest of the book, if I reference talking to a chef server, it should be interchangeable, if not, I'll make note of it and explain which way they differ.

## Open Source Server

In order to run [Open Source](http://www.opscode.com/chef/install/) chef server, you need either Ubuntu, or Enterprise Linux. Also you need a machine that is has at least 4 gigs of RAM. This is unfortunate because that is not possible with the Free Tier on AWS.  There is a great tutorial on the [docs](http://docs.opscode.com/install_server.html) page, but I'll go through it here.

### How to build it
After you build it, [this](http://docs.opscode.com/chef/manage_server_open_source.html) resource is invaluable.  But the beauty of chef server, is as soon as you get it set up and `knife` can talk to it, you really don't ever have to touch it again.

First thing you need is a 4 gig of RAM on a box. So if you are looking at EC2, you have to use at least a m1.medium, which yes, it is 3.75 gigs, but for testing and learning that is ok.  If you are looking at production, you should seriously look at greater than 4 gigs. 

After you get in the box, the next step is getting the binary, all you have to is go to [here](http://www.opscode.com/chef/install/) or run this on the box: (my box is 12.04 ubuntu 64 bit if you want to mimic me)
```bash
ubuntu@ip-10-141-164-25:~$ sudo su -
root@ip-10-141-164-25:~# wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.8-1.ubuntu.12.04_amd64.deb
--2013-10-28 15:26:33--  https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.8-1.ubuntu.12.04_amd64.deb
Resolving opscode-omnibus-packages.s3.amazonaws.com (opscode-omnibus-packages.s3.amazonaws.com)... 176.32.99.39
Connecting to opscode-omnibus-packages.s3.amazonaws.com (opscode-omnibus-packages.s3.amazonaws.com)|176.32.99.39|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 197934506 (189M) [application/x-debian-package]
Saving to: `chef-server_11.0.8-1.ubuntu.12.04_amd64.deb'

100%[==============================================================================================>] 197,934,506 19.9M/s   in 9.7s

2013-10-28 15:26:42 (19.4 MB/s) - `chef-server_11.0.8-1.ubuntu.12.04_amd64.deb' saved [197934506/197934506]

root@ip-10-141-164-25:~#
```

Now install it :)
```bash
root@ip-10-141-164-25:~# dpkg -i chef-server_11.0.8-1.ubuntu.12.04_amd64.deb
Selecting previously unselected package chef-server.
(Reading database ... 47490 files and directories currently installed.)
Unpacking chef-server (from chef-server_11.0.8-1.ubuntu.12.04_amd64.deb) ...
Setting up chef-server (11.0.8-1.ubuntu.12.04) ...
Thank you for installing Chef Server!

The next step in the install process is to run:

sudo chef-server-ctl reconfigure
Processing triggers for initramfs-tools ...
update-initramfs: Generating /boot/initrd.img-3.2.0-54-virtual
root@ip-10-141-164-25:~#
```
And as it says, run `sudo chef-server-ctl reconfigure` to get it going :)
```bash
root@ip-10-141-164-25:~# sudo chef-server-ctl reconfigure
```
You'll notice that it's running chef-solo, and setting everything up for you.
```bash

[-- snip --]
        +    "postgresql": {
        +      "enable": true,
        +      "ha": false,
        +      "dir": "/var/opt/chef-server/postgresql",
        +      "data_dir": "/var/opt/chef-server/postgresql/data",
        +      "log_directory": "/var/log/chef-server/postgresql",
        +      "svlogd_size": 1000000,
        +      "svlogd_num": 10,
        +      "username": "opscode-pgsql",
        +      "shell": "/bin/sh",
        +      "home": "/var/opt/chef-server/postgresql",
        +      "user_path": "/opt/chef-server/embedded/bin:/opt/chef-server/bin:$PATH",
        +      "sql_user": "opscode_chef",
        +      "sql_password": "d93a938fa04a98a151be85e47b36b39299d286aeaa3c15eb315ff0b5d8aa4e94349bfb368de15c4657be11ed4a51ac41a4e8",
        +      "sql_ro_user": "opscode_chef_ro",
        +      "sql_ro_password": "9a2a1f5d93ea95e769901820ba823f842154f52a00455f162561251fc44a936d12c3f8e1fc5b08f04ad2ebf8c15d7ab74cbd",
        +      "vip": "127.0.0.1",
        +      "port": 5432,
        +      "listen_address": "localhost",
        +      "max_connections": 200,
        +      "md5_auth_cidr_addresses": [
        +
        +      ],
        +      "trust_auth_cidr_addresses": [
        +        "127.0.0.1/32",
        +        "::1/128"
        +      ],
        +      "shmmax": 17179869184,
        +      "shmall": 4194304,
        +      "shared_buffers": "937MB",
        +      "work_mem": "8MB",
        +      "effective_cache_size": "1875MB",
        +      "checkpoint_segments": 10,
        +      "checkpoint_timeout": "5min",
        +      "checkpoint_completion_target": 0.9,
        +      "checkpoint_warning": "30s"
        +    }
        +  },
        +  "run_list": [
        +    "recipe[chef-server]"
        +  ]
        +}

Recipe: chef-server::erchef
  * service[erchef] action restart
    - restart service service[erchef]

Chef Client finished, 270 resources updated
chef-server Reconfigured!
root@ip-10-141-164-25:~#
```
Next check to make sure that nginx is now running on your box, it's the front end for chef server.
```bash
root@ip-10-141-164-25:~# ps waux | grep nginx
root      4166  0.0  0.0   4176   356 ?        Ss   15:30   0:00 runsv nginx
root      4167  0.0  0.0   4320   356 ?        S    15:30   0:00 svlogd -tt /var/log/chef-server/nginx
root      4168  0.0  0.0  82180  3568 ?        Ss   15:30   0:00 nginx: master process /opt/chef-server/embedded/sbin/nginx -c /var/opt/chef-server/nginx/etc/nginx.conf
999       4169  0.0  0.1  86192  5144 ?        S    15:30   0:00 nginx: worker process
999       4170  0.0  0.0  82368  1448 ?        S    15:30   0:00 nginx: cache manager process
root      4244  0.0  0.0   8108   920 pts/0    S+   15:32   0:00 grep --color=auto nginx
root@ip-10-141-164-25:~#
```

Awesome, now go ahead and hit the _HTTPS_ website, you should see Open source chef server! The http to https forward is a tad bit funky, I found a [fix](http://jjasghar.github.io/blog/2013/10/05/how-to-fix-https-slash-slash-chef-defaulting-running-chef-client-on-open-source-chef-server/) for it, but lets just get it working before messing with it. 

You'll see a Login page, the default user name and password is: admin/p@ssw0rd1 you should be able to login. It'll ask for a new password, so I'd suggest something strong. Be sure to click "Regenerate Private Key" and click "Save User." Let's talk about that "Private Key" now.

The next screen that pops up is the Public and Private key for the main admin user to talking to your new chef server. These keys are _EXTREMELY_ important. Copy it out of your web browser, put it in at least 2 locations, because you really should have a backup.

I'm going to run this from my chef-book vm. Go ahead and create a `admin.pem` in your `~/.chef/` directory:
```bash
root@chef-book:~/.chef# vim admin.pem
```
Next, edit your `knife.rb` to look something like this:
```ruby
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '~/.chef/admin.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef/chef-validator.pem'
chef_server_url          'https://the-server-you-just-spunup.domain.com'
cookbook_path            ["~/cookbooks"]
cache_type               'BasicFile'
cookbook_copyright       "My company that want's the copyright"
cookbook_license         "apachev2"
cookbook_email           "jj.asghar@peopleadmin.com"
```
Make sure you change the `chef_server_url` to the machine you just spun up. Go ahead and run `knife status`.
You should see something like this:
```bash
root@chef-book:~/.chef# knife status
ERROR: Your private key could not be loaded from /root/.chef
Check your configuration file and ensure that your private key is readable
root@chef-book:~/.chef#
```
You didn't put your private key in `.chef` did you? ;) Grab that `admin.pem` and put in in that location, and run `knife client list` you should see something like this:
```bash
root@chef-book:~# knife client list
chef-validator
chef-webui
root@chef-book:~#
```

Congrats! You now can upload and manipulate your new chef server! Now just for completion sake lets try this with hosted chef. copy your `.chef` location to something else, we'll want to keep it around.

## Hosted Chef Server

NOTE: Hosted chef is free up to 5 nodes, so you should easily be able to test this out with chef-book vm.

First thing you'll need to do is go [here](https://getchef.opscode.com/signup) fill in the relevant data, and click the Get Started button.
The most important part of it is your `Chef Organization` name. That is the unique name that identifies your grouping of machines.Last time I checked you can't change it, so pick something important enough but unique at the same time.

The next window that comes up is the "Thank you for choosing Enterprise Chef" and gives you 3 steps to get going. Go ahead and click the "Set up your workstation" you can come back to the "Download Starter Kit" at another time. So you can see it clicks you over to [here](https://learnchef.opscode.com/quickstart/workstation-setup/) and must if not all of it should make sense by now ;). Awesome lets move on.

Go ahead and find the `Sign In` page, I did it by refreshing the page. It seems odd that there isn't a way directly to it from all that information, but meh, I found it.  Login and you should see "Opscode Manage" in the top right.  This is the main site to work from.

Now we need a key right? Lets get one going.  Go ahead and click "Administrative" at the top, and click your user. Click "Reset Key" on the left hand side, and you should see something that looks extremely familiar. Go ahead and copy that off in 2 locations because that's how you talk to your Org at opscode.

Go ahead and click on "Organizations" and click on the little Gear by your organization name. There is a drop down box that allows a creation of a `knife.rb`, and take that data and put it in your `knife.rb`. The most important parts obviously is the `chef_server_url` and the `client_key` make sure that's correct, and run your `knife client list` and you should see:
```bash
root@chef-book:~/.chef# knife client list
jonathanasghar-validator
root@chef-book:~/.chef#
```
Congrats, you just got Hosted Chef running. Yes significantly easier than Open source chef, but where's the fun in that?

Now there are a ton more things you can do with the different chef servers, but for now I'm going to focus only on open source. Open source is actually just a subset of Hosted, so everything you learn from now on should be functional. (some way or another in Hosted)
