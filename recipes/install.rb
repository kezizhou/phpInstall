#
# Cookbook:: phpInstall
# Recipe:: install
#
# Copyright:: 2019, Keziah Zhou, All Rights Reserved.

execute 'Yum update' do
    command 'yum update -y'
end

yum_package %w(httpd24 php70 mysql56-server php70-mysqlnd) do
    action :install
end

service 'httpd' do  
    action [:enable, :start]
end

group 'dev-golfathon' do
    members 'ec2-user'
    action :create
end

execute 'Give dev group permissions and others read' do
    command "chgrp -R dev-golfathon #{['phpInstall']['htmlRootDir']}
        chmod -R 2774 #{['phpInstall']['htmlRootDir']}"
end

execute 'Get files from S3' do
    command "aws s3 cp s3:://golfathon-web-app-dev/ #{node['phpInstall']['htmlRootDir'l} --recursive"
    not_if { ::File.exist?("#{node['phpInstall']['htmlRootDir'l}/default_site") }
end