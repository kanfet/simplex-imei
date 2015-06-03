require 'rails_helper'
require 'support/fake_apple'

RSpec.describe Device, type: :model do
  include FakeAppleTestHelper

  before(:each) { stub_apple }

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

  describe 'self#warranty_expiration_date' do

    it 'returns date extracted from text' do
      text = <<TEXT
Your product is covered for eligible hardware repairs and service under AppleCare+.
Estimated Expiration Date: March 21, 2020
Learn about Apple's coverage information for your product.
TEXT
      expect(Device.send(:warranty_expiration_date, text)).to eq(Date.new(2020, 03, 21))
    end

    it 'returns nil if date not found' do
      text = <<TEXT
Our records indicate that your product is not covered under Apple's 1-year limited warranty or AppleCare Protection Plan for hardware repairs and service based on the estimated expiration date.
Learn about Apple's coverage information for your product.
TEXT
      expect(Device.send(:warranty_expiration_date, text)).to be_nil
    end

  end

end