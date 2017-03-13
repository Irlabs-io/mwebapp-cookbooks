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

# We need an initiator node before attempting any config of systemd
run_state = node.run_state[cookbook_name]
return if run_state.nil? || run_state['initiator'].nil?

# Construct command line options
options = node.run_state[cookbook_name]['options'].map do |key, opt|
  "-#{key.to_s.tr('_', '-')}#{" #{opt}" unless opt.nil?}"
end.join(' ')

# Configure systemd unit with options
unit = node[cookbook_name]['systemd_unit'].to_hash
bin = "#{node[cookbook_name]['prefix_home']}/consul/consul"
unit['Service']['ExecStart'] = "#{bin} agent #{options}"

systemd_unit 'consul.service' do
  enabled true
  active true
  masked false
  static false
  content unit
  triggers_reload true
  action [:create, :enable, :start]
end
