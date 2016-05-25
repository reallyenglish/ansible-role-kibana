require 'spec_helper'
require 'serverspec'

# waits for kibana to start listening. in my test environment, it takes around
# 40 sec. without this, 'kitchen test' would fail.
#
# {"type":"log","@timestamp":"2016-04-11T23:38:36+00:00","tags":["info","optimize"],"pid":1029,"message":"Optimizing and caching bundles for kibana and statusPage. This may take a few minutes"}
# {"type":"log","@timestamp":"2016-04-11T23:39:17+00:00","tags":["info","optimize"],"pid":1029,"message":"Optimization of bundles for kibana and statusPage complete in 40.45 seconds"}
# ...
# {"type":"log","@timestamp":"2016-04-11T23:39:17+00:00","tags":["listening","info"],"pid":1029,"message":"Server running at http://0.0.0.0:5601"}

sleep 150

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
