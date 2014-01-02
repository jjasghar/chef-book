
package 'openssh-server' do
  action :install
end

cookbook_file '/etc/ssh/ssh_config' do
  source 'ssh_config'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :reload, 'service[ssh]'
end

service 'ssh' do
  action [:enable, :start]
  supports :status => true, :restart => true
end
