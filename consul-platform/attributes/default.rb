
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

cookbook_name = 'consul-platform'

# Cluster configuration with cluster-search
# Role used by the search to find other nodes of the cluster
default[cookbook_name]['role'] = cookbook_name
# Hosts of the cluster, deactivate search if not empty
default[cookbook_name]['hosts'] = []
# Expected size of the cluster. Ignored if hosts is not empty
default[cookbook_name]['size'] = 1

# Id of the node that will first initiate/create the cluster.
# This id is provided by cluster-search
default[cookbook_name]['initiator_id'] = 1

# consul version
default[cookbook_name]['version'] = '0.7.2'
version = node[cookbook_name]['version']
# package sha256 checksum
default[cookbook_name]['checksum'] =
  'aa97f4e5a552d986b2a36d48fdc3a4a909463e7de5f726f3c5a89b8a1be74a58'

# Where to get the zip file
binary = "consul_#{version}_linux_amd64.zip"
default[cookbook_name]['mirror'] =
  "https://releases.hashicorp.com/consul/#{version}/#{binary}"

# User and group of consul process
default[cookbook_name]['user'] = 'consul'
default[cookbook_name]['group'] = 'consul'

# Where to put installation dir
default[cookbook_name]['prefix_root'] = '/opt'
# Where to link installation dir
default[cookbook_name]['prefix_home'] = '/opt'
# Where to link binaries
default[cookbook_name]['prefix_bin'] = '/opt/bin'

# Data directory
default[cookbook_name]['data_dir'] =
  "#{node[cookbook_name]['prefix_home']}/consul/data"

# Configuration directory
default[cookbook_name]['config_dir'] =
  "#{node[cookbook_name]['prefix_home']}/consul/consul.d"

# Consul configuration
default[cookbook_name]['config'] = {
}

# Consul daemon options
default[cookbook_name]['options'] = {
  'server' => '',
  'config-dir' => node[cookbook_name]['config_dir'],
  'data-dir' => node[cookbook_name]['data_dir']
}

# Systemd service unit, include config
default[cookbook_name]['systemd_unit'] = {
  'Unit' => {
    'Description' => 'consul agent',
    'After' => 'network.target'
  },
  'Service' => {
    'Type' => 'simple',
    'User' => node[cookbook_name]['user'],
    'Group' => node[cookbook_name]['group'],
    'Restart' => 'on-failure',
    'ExecStart' => 'TO_BE_COMPLETED'
  },
  'Install' => {
    'WantedBy' => 'multi-user.target'
  }
}

# Configure retries for the package resources, default = global default (0)
# (mostly used for test purpose)
default[cookbook_name]['package_retries'] = nil
