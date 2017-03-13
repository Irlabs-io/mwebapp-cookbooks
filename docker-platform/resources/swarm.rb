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

actions :create, :join, :put_token
default_action :create

property :docker_bin, kind_of: String, default: '/bin/docker'
property :host, kind_of: String, required: false
property :consul_addr, kind_of: String
property :consul_port, kind_of: Integer
property :swarm_node_role, kind_of: String
property :token, kind_of: String, required: true

# Options is a hash like: { 'option_name' => 'option_value' }
# Option names are assumed to begin by '--' so you must use complete names
# Note: all occurences of character '_' are replaced by '-'
property :options, kind_of: Hash, default: {}
