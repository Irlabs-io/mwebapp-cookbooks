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

#initiator_id = node[cookbook_name]['initiator_id']

#if initiator_id < 1 || initiator_id > swarm_cluster['hosts'].size
#  raise 'Invalid initiator_id, should be between 1 and cluster.size'
#end

#raise 'Cannot find myself in the cluster' if swarm_cluster['my_id'] == -1

#added by Anil : HardCoded
#swarm_cluster['hosts'] = ["ip-192-168-10-20.us-west-2.compute.internal", "ip-192-168-11-20.us-west-2.compute.internal", "ip-192-168-12-20.us-west-2.compute.internal", "ip-192-168-10-100.us-west-2.compute.internal"]
# Use ClusterSearch for consul_backend discovery
# Only first host of cluster will be used to connect
#consul_cluster =
#  cluster_search(node[cookbook_name]['swarm']['consul'])
#consul_addr = "192.168.10.7"
#  consul_cluster['hosts'].first
#return if consul_cluster.nil?

execute 'join-swarm-as-worker' do
  command "sh /tmp/swarm_join_as_worker.sh"
end 
