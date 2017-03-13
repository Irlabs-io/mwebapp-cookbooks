#
# Copyright (c) 2016 Sam4Mobile
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

# Looking for the initiator
consul_cluster = cluster_search(node[cookbook_name])
return if consul_cluster.nil?

initiator_id = node[cookbook_name]['initiator_id']
if initiator_id < 1 || initiator_id > consul_cluster['hosts'].size
  raise 'Invalid initiator_id, should be between 1 and cluster.size'
end

raise 'Cannot find myself in the cluster' if consul_cluster['my_id'] == -1

node.run_state[cookbook_name]['initiator'] =
  consul_cluster['hosts'][initiator_id - 1]

if consul_cluster['my_id'] == initiator_id
  node.run_state[cookbook_name]['iam_initiator'] = true
end
