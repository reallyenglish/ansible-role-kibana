require 'spec_helper'

class ServiceNotReady < StandardError
end

describe server(:kibana) do
  describe capybara("http://#{server(:kibana).server.address}:5601") do
    it 'shows "Configure an index pattern' do
      limit = 10
      try = 1
      begin
        visit '/'
        raise ServiceNotReady if page.status_code == nil
      rescue ServiceNotReady, Capybara::Poltergeist::StatusFailError
        if (try + 1) <= limit
          warn "the service is not ready, retrying (remaining retry: %s)" % [ limit - try ]
          sleep 10 * try
          try += 1
          retry
        end
      end
      expect(page.status_code).to eq 200
      expect(page).to have_content 'Configure an index pattern'
    end
  end
end
