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
  #   b) kibana accepts requests, returns 200, showing "please wait ..."
  #      because it still need time to return the status
  #   c) kibana accepts requests, returns 5xx because it's now ready but it
  #      finds no existing Kibana index
  #
  # when the next test is executed at stage b), the test will suceeds but when
  # kibana reaches to stage c) during sleep, the test will fail.
  #
  # the solution is loading sample logs into ES in advance.
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
