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

# Use ClusterSearch
::Chef::Recipe.send(:include, ClusterSearch)

node.run_state[cookbook_name] = {}
node.run_state[cookbook_name]['swarm_cluster'] =
  cluster_search(node[cookbook_name])
swarm_cluster = node.run_state[cookbook_name]['swarm_cluster']
return if swarm_cluster.nil?

initiator_id = node[cookbook_name]['initiator_id']

if initiator_id < 1 || initiator_id > swarm_cluster['hosts'].size
  raise 'Invalid initiator_id, should be between 1 and cluster.size'
end

raise 'Cannot find myself in the cluster' if swarm_cluster['my_id'] == -1

# Use ClusterSearch for consul_backend discovery
# Only first host of cluster will be used to connect
consul_cluster =
  cluster_search(node[cookbook_name]['swarm']['consul'])
consul_addr =
  consul_cluster['hosts'].first
return if consul_cluster.nil?

consul_port = node[cookbook_name]['consul']['port']

swarm_node_role =
  node[cookbook_name]['swarm']['node_role']

# Gem needed to interact with consul
chef_gem 'diplomat' do
  compile_time false
end

# Create swarm and deploy service using custom resources/providers on
# the node having the initiator_id
if swarm_cluster['my_id'] == initiator_id

  # Init the swarm
  resource = docker_platform_swarm('init swarm')
  (node[cookbook_name]['swarm']['options'] || {}).each_pair do |name, conf|
    resource = docker_platform_service(name)
    conf.each_pair { |key, value| resource.send(key, value) }
  end
  resource.send('action', 'create')

  # Put swarm token on consul backend
  resource = docker_platform_swarm('put token in consul backend')
  resource.send('swarm_node_role', swarm_node_role)
  resource.send('consul_addr', consul_addr)
  resource.send('consul_port', consul_port)
  resource.send('action', 'put_token')

  # Make sure docker networks are created before deploying swarm services
  if node[cookbook_name]['networks']
    networks = node[cookbook_name]['networks']
    (networks || {}).each_pair do |name, conf|
      resource = docker_platform_network(name)
      conf.each_pair { |key, value| resource.send(key, value) }
    end
  end

  # Create swarm services
  (node[cookbook_name]['services'] || {}).each_pair do |name, conf|
    resource = docker_platform_service(name)
    conf.each_pair { |key, value| resource.send(key, value) }
  end
end

# Join an existing swarm
docker_platform_swarm 'join swarm' do
  swarm_node_role swarm_node_role
  consul_addr consul_addr
  consul_port consul_port
  retries node[cookbook_name]['swarm']['join_retry_number']
  retry_delay node[cookbook_name]['swarm']['join_retry_delay']
  host swarm_cluster['hosts'][initiator_id - 1]
  action :join
end
