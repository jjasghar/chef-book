# chef-book
(Read this first)

NOTE: This book was inspired by [this post](http://jjasghar.github.io/blog/2013/10/18/people-keep-asking-me-how-to-start-with-chef/) I made. If you want a some background click that link. :)

## The Prerequisites (skills) you need before reading this book
First and foremost, I am writing this for Linux based OSes. I understand Chef can run on Windows and OSX, but that's not what I want to focus on.
So please, if these commands don't make sense to you, you should probably look for another book before reading this one.

- `cd` OR `ls` OR `mkdir` or `grep`
- `vim` OR `emacs` OR `nano`
- `bash` OR `zsh`

The intended audience for this book is a Junior or Intermediate Level Linux Sysadmin that needs a primer on Chef. Another way to look at it is, if you can pass the [Linux+](http://certification.comptia.org/getCertified/certifications/linux.aspx) exam you should be good for this book.

You should be able to get in and out of the editor that you choose. You should be relatively comfortable with the command line in general.
Like most technology how-to books, I want to get to the meat of the system as quickly as possible. I'm apologizing ahead of time if you are confused; most if not all should be fixed via a [google](http://lmgtfy.com/) search pretty easily.
I am writing this to be "open-source" so if there is a place that should be fleshed out better, don't hesitated to put a comment in, or hell, make a [pull request](https://github.com/jjasghar/chef-book/pulls) and flesh it out yourself!

## The situations you might be in that brought you to read/look for this book
The first situation is the one that I came from.  I started my journey with Chef about 2-3 years ago, initially as a scripter then at another company as a supporter of a `chef_repo` that was already way too complex. I had no idea what I was looking at and was overwhelmed. I used [Puppet](http://puppetlabs.com/) extensively but Chef just seemed baffling. I did my damnedest to read all the blog posts, [wiki](https://wiki.opscode.com/display/chef/Home) sites, and how-tos I could find. I eventually threw up my hands and said "no". If you are overwhelmed with Chef and yet [this](http://www.youtube.com/watch?v=UpHKVkLDBtU) video still intrigues you, hopefully this book will make your journey easier. I'm writing this book to my past self who would have KILLED for all this information in one location.

The second situation is a simpler one, you're a new Junior Linux Sysadmin (or Developer), and your team uses Chef. You have no idea what you are looking at, and your boss just told you to create a new cookbook to control something. This book will walk you through you building a test environment and hopefully give you a foundation to confidently write your first cookbook!

The third situation is a sad but true one. You're an Intermediate Linux Sysadmin; you watched [this](http://www.youtube.com/watch?v=UpHKVkLDBtU) video and you now realize your `bash` provisioning scripts are dumb and error prone, so you've decided to take the plunge. This book should walk you through enough to be extremely dangerous, and pique your interest to run with it.

## Contents

### Part one

1\. [VirtualBox](part1/01-virtualbox.md)

2\. [Vagrant](part1/02-vagrant.md)

3\. [VM setup](part1/03-vm-setup.md)

4\. [Omnibus install vs gem install](part1/04-omnibus-install-vs-gem-install.md)

### Part two

5\. [chef-solo](part2/05-chef-solo.md)

6\. [Write a simple base cookbook](part2/06-write-simple-base-cookbook.md)

7\. [Vagrant provisioning vs local chef-solo](part2/07-vagrant-provisioning-vs-local-chef-solo.md)

### Part three

8\. [knife](part3/08-knife.md)

9\. [knife plugins](part3/09-knife-plugins.md)

10\. [Open Source Chef Server vs Hosted Chef Server](part3/10-opensource-vs-hosted-chefserver.md)

11\. [Connecting Open Source or Hosted Chef to a VM](part3/11-connecting-node-to-chef-server.md)

### Part four

12\. [Uploading your cookbook to your Chef Server](part4/12-uploading-running-chef-client.md)

13\. [metadata.rb](part4/13-metadata.rb-primer.md)

14\. [Environments, Roles, oh-my](part4/14-environments-roles-oh-my.md)

15\. [Places to find cookbooks](part4/15-places-to-find-cookbooks.md)

### Part five

16\. [Berkshelf Primer](part5/16-berkshelf-primer.md)

17\. I know something should go here

18\. I know something should go here

19\. I know something should go here

### Part six

20\. [Testing with Chef](part6/20-testing-with-chef.md)

21\. [minitest handler cookbook](part6/21-minitest-handler.md)

22\. [Server Spec](part6/22-serverspec.md)

23\. [ChefSpec](part6/23-chefspec.md)

24\. [Integrating with Jenkins or CI in general](part6/24-integrating-with-jenkin-ci.md)


## Building the PDF
TODO: probably going to steal [upgradingrails4](https://github.com/alindeman/upgradingtorails4) system. Need to play with it.
I need suggestions here, [pandoc](http://johnmacfarlane.net/pandoc/installing.html) looks extremely promising

Even more promising: https://github.com/schacon/git-scribe

## Directories
meta: stuff for the book that isn't the book.

## Acknowledgements
To [everyone](meta/acknowledgements.md) I bugged and poked about helping me out, thanks so much.

## License
<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/3.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/deed.en_US">Creative Commons Attribution-ShareAlike 3.0 Unported License</a>.
