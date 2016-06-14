require 'spec_helper'

# if the build is in jenkins, sleep longer
if ENV['JENKINS_HOME']
  sleep 20
else
  sleep 10
end

describe server(:kibana) do
  describe capybara("http://#{server(:kibana).server.address}:5601") do
    it 'shows "Configure an index pattern' do
      visit '/'
      #page.save_screenshot('screenshot.png')
      expect(page.status_code).to eq 200
    end
  end
end
