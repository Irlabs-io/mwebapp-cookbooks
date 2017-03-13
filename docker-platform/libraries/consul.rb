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

def configure_backend(consul_addr, consul_port)
  require 'diplomat'
  Diplomat.configure do |config|
    config.url = "http://#{consul_addr}:#{consul_port}"
  end
end

def retrieve_swarm_token(bin, node_role)
  shell_out("#{bin} swarm join-token -q #{node_role}").stdout
end

def token_exist?(bin, node_role)
  consul_token = get_token_consul("swarm-token-#{node_role}")
  local_token = retrieve_swarm_token(bin, node_role)
  consul_token == local_token
end

def get_token_consul(key)
  Diplomat::Kv.get(key)
rescue
  return 1
end

def put_token_consul(token, swarm_node_role)
  Diplomat::Kv.put("swarm-token-#{swarm_node_role}", token)
end
