require 'spec_helper'
require 'serverspec'

kibana_package_name = 'kibana'
kibana_service_name = 'kibana'
kibana_config_path  = '/etc'
kibana_user_name    = 'kibana'
kibana_user_group   = 'kibana'

case os[:family]
when 'freebsd'
  kibana_package_name = 'kibana45'
  kibana_config_path = '/usr/local/etc'
end

describe package(kibana_package_name) do
  it { should be_installed }
end

describe file("#{kibana_config_path}/kibana.yml") do
  it { should be_file }
  its(:content) { should match /^server\.port: 5601/ } 
  its(:content) { should match /^server\.host: 0\.0\.0\.0/ }
  its(:content) { should match /^elasticsearch\.url: "http:\/\/localhost:9200"/ } 
  its(:content) { should match /^kibana\.index: "\.kibana"/ }
  its(:content) { should match /^logging\.dest: "stdout"/ }
end

describe service(kibana_service_name) do
  it { should be_enabled }
  it { should be_running }
end

describe port(5601) do
  it { should be_listening }
end
