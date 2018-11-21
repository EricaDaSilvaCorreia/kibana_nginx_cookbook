#
# Cookbook:: kibana_nginx
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

#====== Updae ========

apt_update 'update_sources' do
  action :update
end

#=======NGINX=========

package "nginx"

service "nginx" do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables proxy_port: node['nginx']['proxy_port']
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]', :delayed
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :restart, 'service[nginx]', :delayed
end

#=======KIBANA=========

execute "elasticsearch key" do
  command 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'
end

execute "install kibana" do
  command 'echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list'
end

execute "update all" do
  command "sudo apt-get update"
end

execute "install kibana" do
  command 'apt-get install kibana -y'
end

service 'kibana' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

template '/etc/kibana/kibana.yml' do
  source 'kibana.yml.erb'
  notifies :restart, 'service[kibana]'
end

execute "start kibana" do
  command "sudo service kibana start"
end
