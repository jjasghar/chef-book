Running chef-solo via vagrant provisioning
------------------------------------------

With a working `chef-solo` converge, this is a good time to talk about using local chef-solo and running chef outside via vagrant. As I am developing/testing a cookbook I personally prefer the local chef-solo install. It allows for a faster turn around which is great. But when you get your cookbook where you want it to be,`vagrant provision` is the way to go. For fun let's convert the cookbook we wrote `base` to the `Vagrant` file.

First thing, you need to get to your `Vagrant` file. Go ahead and create your `cookbooks` directory, and add the base name. Like this:
```bash
[~/vagrant/chef-book] % mkdir cookbooks
[~/vagrant/chef-book] % mkdir -p cookbooks/base/recipes
[~/vagrant/chef-book] % vim cookbooks/base/recipes/default.rb
```
Add the this to the `default.rb`.
```ruby
%w{vim ntp build-essential}.each do |pkg|
  package pkg do
    action [:install]
  end
end
```

