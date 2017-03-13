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

use_inline_resources

action :create do
  unless been_initialized?
    converge_by("Init swarm on #{node['fqdn']}") do
      shell_out(init_swarm(new_resource.options)).error!
    end
  end
end

action :join do
  swarm_node_role = new_resource.swarm_node_role
  consul_addr = new_resource.consul_addr
  consul_port = new_resource.consul_port
  if new_resource.host
    host = new_resource.host
    unless been_joined?
      converge_by("Join swarm on #{host}") do
        configure_backend(consul_addr, consul_port)
        token = get_token_consul("swarm-token-#{swarm_node_role}")
        shell_out(join_swarm(new_resource.options, token)).error!
      end
    end
  end
end

action :put_token do
  docker_bin = new_resource.docker_bin
  swarm_node_role = new_resource.swarm_node_role
  consul_addr = new_resource.consul_addr
  consul_port = new_resource.consul_port
  configure_backend(consul_addr, consul_port)
  unless token_exist?(docker_bin, swarm_node_role)
    converge_by('Put token on backend') do
      token = retrieve_swarm_token(docker_bin, swarm_node_role)
      put_token_consul(token, swarm_node_role)
    end
  end
end

def init_swarm(options)
  <<-eos
    #{new_resource.docker_bin} swarm init #{swarm_options(options)}
  eos
end

def join_swarm(options, token)
  <<-eos
    #{new_resource.docker_bin} swarm join #{swarm_options(options)} \
    #{new_resource.host} --token #{token}
  eos
end

def swarm_options(options)
  o = options.map { |key, opt| "--#{key.to_s.tr('_', '-')} #{opt}".chomp(' ') }
  o.join(' ')
end

def been_initialized?
  shell_out("#{new_resource.docker_bin} node ls").exitstatus.zero?
end

def been_joined?
  shell_out(
    "#{new_resource.docker_bin} info | grep 'Swarm: active'"
  ).exitstatus.zero?
end

def whyrun_supported?
  true
end
