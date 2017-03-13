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
  unless been_created?
    converge_by("Create swarm #{new_resource.name} service") do
      shell_out(create_service(new_resource.options)).error!
    end
  end
end

def create_service(options)
  <<-eos
    /bin/docker service create \
    --name #{new_resource.name} #{service_options(options)} #{options['image']}
  eos
end

def service_options(options)
  options.map do |key, opt|
    next if key == 'image'
    "--#{key.to_s.tr('_', '-')} #{opt}".chomp(' ')
  end.join(' ')
end

def been_created?
  shell_out(
    "#{new_resource.bin} service ls | grep #{new_resource.name}"
  ).exitstatus.zero?
end

def whyrun_supported?
  true
end
