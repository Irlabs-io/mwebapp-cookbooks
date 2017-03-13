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

# unzip & rsync may not be installed by default
package %w(unzip rsync) do
  retries node[cookbook_name]['package_retries']
end

# Create prefix directories
[
  node[cookbook_name]['prefix_root'],
  node[cookbook_name]['prefix_home'],
  node[cookbook_name]['prefix_bin']
].uniq.each do |dir_path|
  directory "#{cookbook_name}:#{dir_path}" do
    path dir_path
    mode '0755'
    recursive true
    action :create
  end
end

ark 'consul' do
  action :install
  url node[cookbook_name]['mirror']
  prefix_root node[cookbook_name]['prefix_root']
  prefix_bin node[cookbook_name]['prefix_bin']
  prefix_home node[cookbook_name]['prefix_home']
  has_binaries []
  strip_components 0
  checksum node[cookbook_name]['checksum']
  version node[cookbook_name]['version']
  owner node[cookbook_name]['user']
  group node[cookbook_name]['group']
end
