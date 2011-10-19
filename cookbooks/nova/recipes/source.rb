#
# Cookbook Name:: nova
# Recipe:: source
#
# Copyright 2010, Opscode, Inc.
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

execute "git clone #{node[:nova][:source][:repository]}" do
  cwd node[:nova][:source][:dir]
  user node[:nova][:source][:user]
  group node[:nova][:source][:group]
  not_if { File.directory?("#{node[:nova][:source][:dir]}/devstack") }
end

execute "su -c 'set -e; cd #{node[:nova][:source][:dir]}/devstack; bash stack.sh' #{node[:nova][:source][:user]}" do
  environment ({"FORCE" => "yes",
                "MYSQL_PASSWORD" => node[:nova][:source][:mysql_password],
                "RABBIT_PASSWORD" => node[:nova][:source][:rabbit_password],
                "SERVICE_TOKEN" => node[:nova][:source][:service_token],
                "ADMIN_PASSWORD" => node[:nova][:source][:admin_password],
                "SHELL_AFTER_RUN" => "no"})
end
