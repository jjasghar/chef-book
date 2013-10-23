group "deployer" do
  gid 15000
  action :create
end

user "deployer" do
  supports :manage_home => true
  comment "D-Deployer"
  uid 15000
  gid 15000
  home "/home/deployer"
  shell "/bin/bash"
end

directory "/home/deployer/.ssh" do
  owner "deployer"
  group "deployer"
  action :create
end 

cookbook_file "/home/deployer/.ssh/authorized_keys" do
  source "deployer_key.pub"
  owner "deployer"
  group "deployer"
  action :create_if_missing
  mode 0600
end
