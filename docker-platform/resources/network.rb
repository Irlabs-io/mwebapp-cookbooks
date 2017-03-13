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

actions :create
default_action :create

property :bin, kind_of: String, default: '/bin/docker'
property :name, kind_of: String, name_property: true

# Options is a hash like: { 'option_name' => 'option_value' }
# Option names are assumed to begin by '--' so you must use complete names
# Note: all occurences of character '_' are replaced by '-'
property :options, kind_of: Hash, default: {}
