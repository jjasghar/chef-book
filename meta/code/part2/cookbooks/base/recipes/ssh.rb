
package 'openssh-server' do
  action :install
end

service "ssh" do
  action [:enable, :start]
  supports :status => true, :start => true, :stop => true, :restart => true
end

cookbook_file "/etc/ssh/ssh_config" do
  source "ssh_config"
  owner "root"
  group "root"
  mode "0640"
  notifies :reload, "service[ssh]", :immediately
  notifies :start, "service[ssh]", :immediately 
end
