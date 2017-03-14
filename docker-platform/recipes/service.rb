#
# Copyright (c) 2016-2017 Sam4Mobile
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#systemd_unit 'docker.service' do
#  enabled true
#  active true
##  masked false
#  static false
#  content node[cookbook_name]['systemd_unit']
#  triggers_reload true
#  action [:create, :enable, :start]
#  not_if { node[cookbook_name]['systemd_unit'].empty? }
#end

execute 'create-webapp-network' do
  command "docker network create --driver overlay --subnet 10.0.9.0/24 --opt encrypted mwebapp-network"
end 

execute 'create-db-service' do
  command "docker service create  --replicas 1 --name mysqldb -e MYSQL_ROOT_PASSWORD=irlabs123 --network mwebapp-network --publish 3306:3306 mysql:5.6"
end 


execute 'create-mwebapp-service' do
  command "docker service create  --replicas 1  --name mwebapp  --network mwebapp-network --publish 4000:8080  irlabs/mwebapp:v1"
end 
