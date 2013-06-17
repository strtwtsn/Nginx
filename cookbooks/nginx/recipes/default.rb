#gem_package "passenger" do
#action :install
#end

#package "libcurl4-openssl-dev"


#bash "Extract and install nginx" do
#user "root"
#code <<-EOH
#cd /tmp
#wget https://github.com/strtwtsn/New_Nginx/raw/master/nginx_1.4.1-1_i386.deb
#dpkg -i nginx_1.4.1-1_i386.deb
#EOH
#end

template "/etc/init.d/nginx start script" do
path "/etc/init.d/nginx"
source "startup.erb"
end

bash "Make startup file executable" do
user "root"
code <<-EOH
chmod +x /etc/init.d/nginx
EOH
end


execute "add nginx startup script to server boot" do
  command "/usr/sbin/update-rc.d -f nginx defaults"
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
end

# SETUP NGINX CONF FILE
template "nginx.conf" do
  path "/etc/nginx/nginx.conf"
  source "nginx.conf.erb"
end

directory "/etc/nginx/sites-available" do
action :create
end

directory "/etc/nginx/sites-enabled" do
action :create
end

directory "/var/www" do
action :create
end


directory "/etc/nginx/conf.d" do
action :create
end


#template "passenger.conf" do
#  path "/etc/nginx/conf.d/passenger.conf"
#  source "passenger.conf.erb"
#  owner "root"
#  group "root"
#end

bash "Tidy Up" do
user "root"
code <<-EOH
cd /usr/local/lib/ruby/gems/2.0.0/gems/passenger-4.0.5/
sudo rake nginx
EOH
end

