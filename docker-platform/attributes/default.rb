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

cookbook_name = 'docker-platform'

default[cookbook_name]['version'] = 'latest'
default[cookbook_name]['yum_repo'] =
  'https://yum.dockerproject.org/repo/main/centos/7/'
default[cookbook_name]['yum_gpgkey'] =
  'https://yum.dockerproject.org/gpg'

# Define who is the initiator of swarm cluster
default[cookbook_name]['initiator_id'] = 1

# Define default swarm node role for nodes joining the swarm
default[cookbook_name]['swarm']['node_role'] = 'worker'

default[cookbook_name]['swarm']['join_retry_number'] = 5
default[cookbook_name]['swarm']['join_retry_delay'] = 5

# Cluster configuration with cluster-search
# Role used by the search to find other nodes of the cluster
#default[cookbook_name]['role'] = cookbook_name
default[cookbook_name]['role'] = 'worker'
# Hosts of the cluster, deactivate search if not empty
#default[cookbook_name]['hosts'] = []
default[cookbook_name]['hosts'] = ["ip-192-168-10-20.us-west-2.compute.internal", "ip-192-168-10-100.us-west-2.compute.internal", "ip-192-168-12-20.us-west-2.compute.internal", "ip-192-168-10-20.us-west-2.compute.internal"]
# Expected size of the cluster. Ignored if hosts is not empty
#default[cookbook_name]['size'] = 1
default[cookbook_name]['size'] = 3

# Systemd unit configuration (used for overrinding the default)
default[cookbook_name]['systemd_unit'] = {}

default[cookbook_name]['bin'] = '/bin/docker'

# Configure retries for the package resources, default = global default (0)
# (mostly used for test purpose)
default[cookbook_name]['package_retries'] = nil

# Create docker networks
default[cookbook_name]['networks'] = {}
#default[cookbook_name]['networks'] = 'mwebapp'
#default[cookbook_name]['services'] = 'redis'
#default[cookbook_name]['services']['replicas'] = 1
#default[cookbook_name]['services']['image'] = 'redis:latest'
#default[cookbook_name]['services']['network'] = 'mwebapp'
