require "spec_helper"
require "serverspec"

kibana_package_name = "kibana"
kibana_service_name = "kibana"
kibana_config_path  = "/etc/kibana.yml"
kibana_user_name    = "kibana"
kibana_user_group   = "kibana"

case os[:family]
when "freebsd"
  kibana_package_name = "kibana45"
  kibana_config_path = "/usr/local/etc/kibana.yml"
end

describe package(kibana_package_name) do
  it { should be_installed }
end

describe file(kibana_config_path) do
  it { should be_file }
  its(:content_as_yaml) { should include("server.port" => 5601) }
  its(:content_as_yaml) { should include("server.host" => "0.0.0.0") }
  its(:content_as_yaml) { should include("elasticsearch.url" => "http://localhost:9200") }
  its(:content_as_yaml) { should include("kibana.index" => ".kibana") }
  its(:content_as_yaml) { should include("logging.dest" => "/var/log/kibana/kibana.log") }
end

describe service(kibana_service_name) do
  it { should be_enabled }
  it { should be_running }
end

describe port(5601) do
  it { should be_listening }
end
