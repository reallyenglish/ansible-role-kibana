require 'spec_helper'

class ServiceNotReady < StandardError
end

describe server(:kibana) do

  it 'returns ES status' do
    result = nil
    retry_and_sleep(:tries => 5, :sec => 10, :verbose => true) do
      result = current_server.ssh_exec('curl -q localhost:9200/_stats')
      raise ServiceNotReady if result !~ /"successful":/
    end
    expect(result).to match /"successful":/
  end

  it 'uploads sample logs to elasticsearch' do
    result = nil
    retry_and_sleep do
      json = File.read('spec/logs.jsonl')
      puts json
      result = current_server.ssh_exec("curl -XPUT http://localhost:9200/logstash-2015.05.18 -d '%s' >/dev/null 2>&1 && echo -n OK" % json)
      raise ServiceNotReady if result !~ /OK/
    end
    expect(result).to match /OK/
  end
  describe capybara("http://#{server(:kibana).server.address}:5601") do
    it 'returns 200' do
      retry_and_sleep(:tries => 10, :sec => 10, :verbose => true) do
        visit '/'
        raise ServiceNotReady if page.status_code == nil
      end
      # page.save_screenshot 'screenshot.png' if page.status_code != 200
      expect(page.status_code).to eq 200
    end
  end
end
