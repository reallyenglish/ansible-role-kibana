require 'spec_helper'

class ServiceNotReady < StandardError
end

describe server(:kibana) do
  describe capybara("http://#{server(:kibana).server.address}:5601") do
    it 'returns 200' do
      retry_and_sleep(:tries => 10, :sec => 10, :verbose => true) do
        visit '/'
        raise ServiceNotReady if page.status_code == nil
      end
      expect(page.status_code).to eq 200
    end
  end
end
