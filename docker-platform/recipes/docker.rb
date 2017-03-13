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

config = node['docker-platform']

resource_types = config.select { |key| key.start_with? 'docker_' }
resource_types.each_pair do |type, resources|
  resources.each_pair do |name, resource_conf|
    resource = send(type.to_sym, name)
    (resource_conf || {}).each_pair do |key, value|
      value = [value] unless value.is_a? Array
      resource.send(key, *value)
    end
  end
end
