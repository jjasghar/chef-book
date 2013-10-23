vagrant
-------
Vagrant is a great tool designed for developers to create disposable machines with quick turn a quick turn around.  Is our case we want to install the binary NOT the gem, so go [here](http://downloads.vagrantup.com/)

After you installed it, go ahead and spin up [Terminal|iTerm2|xterm|cmd] and type `vagrant`. You should see something like the following:
```bash
[~] % vagrant
Usage: vagrant [-v] [-h] command [<args>]

    -v, --version                    Print the version and exit.
    -h, --help                       Print this help.

Available subcommands:
     box
     destroy
     halt
     help
     init
     package
     plugin
     provision
     reload
     resume
     ssh
     ssh-config
     status
     suspend
     up

For help on any individual command run `vagrant COMMAND -h`
```
If you see this, you are ready for the next step.

I personally like creating a `vagrant/` directory, and place a directory inside each of them for different vms.  The first test to make sure you have everything working is this.

```bash
[~] % cd ~
[~] % mkdir vagrant
[~] % mkdir vagrant/lucid32
[~] % cd vagrant/lucid32
[~/vagrant/lucid32] % vagrant box add base http://files.vagrantup.com/lucid32.box
[~/vagrant/lucid32] % vagrant init
[~/vagrant/lucid32] % vagrant up
```
Then you should see something that resembles this:

```bash
Bringing machine 'default' up with 'virtualbox' provider...
[default] Importing base box 'base'...
[default] Matching MAC address for NAT networking...
[default] Setting the name of the VM...
[default] Clearing any previously set forwarded ports...
[default] Fixed port collision for 22 => 2222. Now on port 2200.
[default] Creating shared folders metadata...
[default] Clearing any previously set network interfaces...
[default] Preparing network interfaces based on configuration...
[default] Forwarding ports...
[default] -- 22 => 2200 (adapter 1)
[default] Booting VM...
[default] Waiting for machine to boot. This may take a few minutes...
[default] Machine booted and ready!
[default] Mounting shared folders...
[default] -- /vagrant
```

Go ahead and `vagrant ssh` into the box and you'll see that you have a complete box that can run linux commands, basically anything. Type something like `sudo apt-get update && sudo apt-get intsall vim -y` You'll see vim being installed. Start it up with `vim test-file` and write some things in there. `wq` out of it. Go ahead and `logout` of the machine. You should see your original command prompt from your host machine now. Type `vagrant ssh` and you should see the file that you wrote out, `cat test-file`.
As you can see you have been able to create a base box ssh into it, and change it around, log out then log back in and not loose any of your data.
The next step is to destroy it and start over, so in the place you did your `vagrant up` type `vagrant destroy -f` this is a "Do not pass Go" type of destroy, so be careful, you have been warned.
As you can see with the `vagrant destroy -f`:
```bash
[~/vagrant/lucid32] % vagrant destroy -f
[default] Forcing shutdown of VM...
[default] Destroying VM and associated drives...
[~/vagrant/lucid32] %
```
It shuts down the machine, and blows it up. If you attempt to `vagrant ssh` it'll say:
```bash
[~/vagrant/lucid32] % vagrant ssh
VM must be created before running this command. Run `vagrant up` first.
[~/vagrant/lucid32] %
```
Because the machine is gone. You can simply run `vagrant up` to re-create it. You'll notice that the `test-file` nor vim is there anymore, and that's expected, you blew it up didn't you?  I strongly suggest playing around with `vagrant` the [docs](http://docs.vagrantup.com/v2/) for version 2 are extremely straight forward, and you should spend the time to get comfortable with it. It'll make your chef experance so much better. 

Bonus round: Try to set up an apache server/nginx server and use the [port forwarding](http://docs.vagrantup.com/v2/networking/forwarded_ports.html) with vagrant and be able to hit your http://localhost:8080 and see the default page for it.

Move on to [The beginning of your playground](part1/3-vm-setup.md)
