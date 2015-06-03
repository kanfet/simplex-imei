require 'rails_helper'
require 'support/fake_apple'

RSpec.describe Device, type: :model do

  before(:each) do
    allow(Device).to receive(:new_browser_session) { Capybara::Session.new(:rack_test, FakeApple) }
    allow(Device).to receive(:apple_url){ '/agreementWarrantyDynamic.do' }
  end

  let(:invalid_imei) { 'invalid' }
  let(:in_warranty_imei){ '013977000323877' }
  let(:expired_warranty_imei){ '013896000639712' }

  describe 'self#find_by_imei' do

    it 'returns nil for invalid imei', js: true do
      expect(Device.find_by_imei(invalid_imei)).to be_nil
    end

    it 'returns Device instance' do
      expect(Device.find_by_imei(in_warranty_imei)).to be_a(Device)
    end

    it 'returns in warranty device' do
      expect(Device.find_by_imei(in_warranty_imei).in_warranty).to be_truthy
    end

    it 'returns expired warranty device' do
      expect(Device.find_by_imei(expired_warranty_imei).in_warranty).to be_falsey
    end

    it 'returns device with warranty expiration date' do
      expect(Device.find_by_imei(in_warranty_imei).warranty_expiration_date).to eq(Date.new(2016, 8, 10))
    end

    it 'returns device without warranty expiration date' do
      expect(Device.find_by_imei(expired_warranty_imei).warranty_expiration_date).to be_nil
    end

  end

end