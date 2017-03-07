#
# Cookbook Name:: docker
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "sudo apt-get -y update"
execute "sudo apt-get -y install apt-transport-https ca-certificates"
execute "sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D"
execute "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' >> /etc/apt/sources.list.d/docker.list"
execute "sudo apt-get -y update"
execute "sudo apt-get -y install docker-engine"
execute "sudo service docker restart"

