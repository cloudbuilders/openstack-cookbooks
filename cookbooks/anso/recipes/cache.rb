#
# Cookbook Name:: anso
# Recipe:: settings
#
# Copyright 2011, Anso Labs
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

d = node['cache']['dir']

execute "mkdir -p #{d}/aptcache; ln -s /var/cache/apt/archive #{d}/aptcache" do
  not_if { File.exists?("/var/cache/apt/archive") }
end

execute "mkdir -p #{d}/pipcache; ln -s /var/cache/pip #{d}/pipcache" do
  not_if { File.exists?("/var/cache/pip") }
end

execute "mkdir -p #{d}/stack; ln -s /opt/stack #{d}/stack" do
  not_if { File.exists?("/opt/stack") }
end

