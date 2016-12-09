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
      # obtained from https://download.elastic.co/demos/kibana/gettingstarted/logs.jsonl.gz
      json = File.read('spec/logs.jsonl')
      result = current_server.ssh_exec("curl -XPOST 'localhost:9200/_bulk?pretty' -d '%s'" % json)
      raise ServiceNotReady if result !~ /"successful" : 1,/
    end
    expect(result).to match /"successful" : 1,/
  end
  # XXX there is a race condition when sending HTTP request to kibana.
  #
  # at start up, there are three stages:
  #
  #   a) kibana does not accept requests because it is not ready
  #   b) kibana accepts requests, returns 503 because it's now ready but it
  #      finds plugin:elasticsearch is not ready
  #   c) kibana accepts requests, returns 200 because the plugin is ready
  #
  # when the next test is executed at stage c), the test will suceeds but when
  # kibana reaches to stage b) during sleep, the test will fail.
  describe capybara("http://#{server(:kibana).server.address}:5601/status") do
    it 'returns 200' do
      retry_and_sleep(:tries => 10, :sec => 10, :verbose => true) do
        visit '/'
        raise ServiceNotReady if page.status_code == nil or page.status_code == 503
      end
      # page.save_screenshot 'screenshot.png' if page.status_code != 200
      expect(page.status_code).to eq 200
    end
  end
end
