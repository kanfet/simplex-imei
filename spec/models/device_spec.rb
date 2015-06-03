require 'rails_helper'
require 'support/fake_apple'

RSpec.describe Device do

  before(:each) do
    allow(Device).to receive(:new_browser_session) { Capybara::Session.new(:rack_test, FakeApple) }
    allow(Device).to receive(:apple_url){ '/agreementWarrantyDynamic.do' }
  end

  let(:non_exist_imei) { '123456' }
  let(:valid_imei){ '013896000639712' }

  describe 'self#find_by_imei' do

    it 'returns nil if nothing found', js: true do
      expect(Device.find_by_imei(non_exist_imei)).to be_nil
    end

    it 'returns Device instance' do
      expect(Device.find_by_imei(valid_imei)).to be_a(Device)
    end

  end

end