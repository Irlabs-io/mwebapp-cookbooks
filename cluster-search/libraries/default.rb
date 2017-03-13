#
# Copyright (c) 2015-2016 Sam4Mobile
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

# ClusterSearch module
module ClusterSearch
  def cluster_search(cluster_config)
    raise 'cluster_search: empty argument' if cluster_config.to_h.empty?
    Chef::Log.info "Searching for cluster: #{cluster_config}"

    include_me = include_me? cluster_config['role']
    hosts_config = [cluster_config['hosts']].flatten.compact
    hosts, cluster_size = get_hosts(cluster_config, hosts_config, include_me)
    return nil unless correct_size?(hosts, cluster_size) # Verify size
    my_id = getcheck_my_id(hosts, include_me)
    { 'hosts' => hosts, 'my_id' => my_id }
  end

  private

  def include_me?(role)
    include_me = node['roles'].include? role
    if include_me
      Chef::Log.info 'I should be included in the results'
    else
      Chef::Log.info 'It seems I am not part of the cluster'
    end
    include_me
  end

  def get_hosts(cluster_config, hosts_config, include_me)
    if Chef::Config[:solo] || !hosts_config.empty?
      Chef::Log.info 'Using \'hosts\' attribute and ignoring \'size\''
      hosts = hosts_config.uniq
      cluster_size = hosts.size
    else
      cluster_size = getcheck_cluster_size(cluster_config['size'])
      hosts = search_nodes(cluster_config['role'], include_me)
    end
    Chef::Log.info "Hosts found: #{hosts}"
    [hosts.to_a.sort.uniq, cluster_size]
  end

  def getcheck_cluster_size(cluster_size)
    unless cluster_size.is_a? Integer
      raise "cluster_search: 'size' is not defined while 'hosts' is empty"
    end
    cluster_size
  end

  def search_nodes(role, include_me)
    raise 'cluster_search: undefined search role' if role.to_s.empty?
    Chef::Log.info "Searching in role #{role}"
    hosts = search(:node, "roles:#{role}")
    hosts = hosts.collect { |n| n['fqdn'] }

    if include_me
      Chef::Log.info 'Including myself in the search result, as requested'
      hosts << node['fqdn']
    end
    hosts
  end

  def correct_size?(hosts, cluster_size)
    Chef::Log.info "I want #{cluster_size} servers and I've got #{hosts.size}"
    if hosts.size == cluster_size
      Chef::Log.info "so it's fine, let's continue!"
      return true
    end
    if hosts.size > cluster_size
      raise 'cluster_search: too many servers, configuration problem?'
    end
    Chef::Log.warn 'Need more, waiting other nodes to declare themselves'
    false
  end

  def getcheck_my_id(hosts, include_me)
    Chef::Log.info "I am node #{node['fqdn']}"
    my_id = get_my_id hosts
    if include_me && my_id == -1
      raise "cluster_search: should I be listed in 'hosts'?"
    end
    Chef::Log.info "My ID: #{my_id}"
    my_id
  end

  def get_my_id(hosts)
    index = hosts.index node['fqdn']
    return -1 if index.nil? # Not a member of this cluster
    index + 1
  end
end
