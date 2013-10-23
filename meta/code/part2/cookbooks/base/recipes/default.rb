%w{vim ntp build-essential}.each do |pkg|
   package pkg do
     action [:install]
  end
end

include_recipe "base::ssh"
