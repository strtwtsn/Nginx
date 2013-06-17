bash "install postfix" do
  code "DEBIAN_FRONTEND=noninteractive apt-get install -y postfix"
end

service "postfix" do
  service_name "postfix"
  supports :restart => true, :status => true, :reload => true
end

gem_package "pony" do
  action :install
  version "1.0"
end

