#
# Cookbook Name:: nova
# Recipe:: vagrant
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

package "git"

execute "git clone https://github.com/vishvananda/novascript" do
  cwd "/tmp"
  not_if { File.exists?("novascript") }
  user node[:nova][:creds][:user]
  group node[:nova][:creds][:group]
end

execute "mkdir -p /tmp/bzr" do
  not_if { File.exists?("/tmp/bzr") }
  user node[:nova][:creds][:user]
  group node[:nova][:creds][:group]
end

execute "../novascript/nova.sh install" do
  cwd "/tmp/bzr"
  user node[:nova][:creds][:user]
  group node[:nova][:creds][:group]
end

execute "rm -rf /tmp/bzr/nova" do
  user node[:nova][:creds][:user]
  group node[:nova][:creds][:group]
end

execute "../novascript/nova.sh branch #{node[:nova][:source_branch]}" do
  cwd "/tmp/bzr"
  user node[:nova][:creds][:user]
  group node[:nova][:creds][:group]
end

execute "mkdir -p /tmp/instances" do
  not_if { File.exists?("/tmp/instances") }
  user "root"
end

execute "export INSTANCES_PATH=/tmp/instances; ../novascript/nova.sh run_detached" do
  cwd "/tmp/bzr"
  user "root"
  environment ({'INTERFACE' => node[:nova][:vlan_interface],
                'FLOATING_RANGE' => node[:nova][:floating_range],
                'FIXED_RANGE' => node[:nova][:fixed_range],
                'HOST_IP' => node[:nova][:my_ip]})
end

execute "unzip -o ./nova/nova.zip -d #{node[:nova][:creds][:dir]}/" do
  cwd "/tmp/bzr"
  user node[:nova][:creds][:user]
  group node[:nova][:creds][:group]
end

