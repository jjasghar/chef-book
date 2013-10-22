chef-book
=========
(Read this first)

The Prereqs you need before reading this book
----------------------------------------------
The first and foremost is that I'm writing this for Linux based OSes. I understand chef can can run on Windows and OSX, but that's not what I want to focus on.
So please if these commands don't make sense to you, you should probably look for another book before reading this one.

- `grep`
- `cd` `ls` `cat`
- `vim` OR `emacs` OR `nano`
- `bash` OR `zsh`

I'm looking to aim this at a Junior Level Linux Sysadmin, or a Intermediate Level Linux Sysadmin that needs a primer on chef. Another way to look at it, if you can pass the [Linux+](http://certification.comptia.org/getCertified/certifications/linux.aspx) you should be good for this book.

You should be able to get in and out of the editor that you choose. You should have a relatively comfortable with the command line in general.
Like most technology howto books, I want to get to the meat of the system as quickly as possible. I'm apologizing ahead of time if you are confused; most if not all should be fixed via a [google](http://lmgtfy.com/) search pretty easily.
I am writing this to me "open-source" so if there is a place that should be fleshed out better, don't hesitated to put a comment in or hell, make a [pull request](https://github.com/jjasghar/chef-book/pulls) and flesh it out yourself!

The situations you might be in that brought you to read/look for this book
--------------------------------------------------------------------------
The first situation is the one that I came from.  I started my journey with chef about 2-3 years ago, as a supporter of a `chef_repo` that was already way to complex. I had no idea what I was looking at and was overwhelmed. I used [puppet](http://puppetlabs.com/) extensively but chef just seemed baffling. I did my damnest to read all the blog posts, [wiki](https://wiki.opscode.com/display/chef/Home) sites, and how-tos I could find. I eventually threw up my hands and said no. If you have just been whelmed with the chef and [this](http://www.youtube.com/watch?v=UpHKVkLDBtU) video still intrigues you hopefully this book will make your journey easier. I'm writing this book to my old past self who would have KILLED for all this information in one location.

The second situation is a simpler one, you're a new Junior Linux Sysadmin (or Developer), and your team uses chef. You have no idea what you are looking at, and your boss just told you to create a new cookbook to control something. This book will walk you through you building a test environment; and hopefully the foundation to be able to confidently write a cookbook to do what your boss wants done.

The third situation is a sad but true one. You're an Intermediate Linux Sysadmin, you watched [this](http://www.youtube.com/watch?v=UpHKVkLDBtU) video, realize your `bash` provisioning scripts are dumb and error prone, so you've decided to take this plunge. This book should walk you through enough to be extremely dangerous, and enough to peak your interest to run with it.

Contents
--------

### Part one

1. [Virtualbox](part1/1-virtualbox.md)
2. [Vagrant](part1/2-vagrant.md)
3. [VM setup](part1/3-vm-setup.md)
4. [Omnibus install vs gem install](part1/4-omnibus-install-vs-gem-install.md)

### Part two

1. 5-chef-solo
2. 6-write-simple-base-cookbook
3. 7-vagrant-provisioning-vs-local-chef-solo

Directories
-----------
meta: stuff for the book that isn't the book.

