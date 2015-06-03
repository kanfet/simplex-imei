require 'rails_helper'
require 'support/fake_apple'

RSpec.describe DevicesController, type: :controller do
  include FakeAppleTestHelper

  describe 'GET #index' do

    it do
      get :index
      should render_template(:index)
    end

  end

  describe 'GET #search' do
    before(:each){ stub_apple }

    let(:imei){ '1234567890' }

    it 'assigns device founded by imei to @device' do
      device = double
      expect(Device).to receive(:find_by_imei){ device }.with(imei)
      get :search, imei: imei
      expect(assigns[:device]).to eq(device)
    end

    it do
      get :search, imei: imei
      should render_template(:search)
    end

  end

end
