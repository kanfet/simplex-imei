require 'rails_helper'
require 'support/fake_apple'

RSpec.describe 'Devices', type: :feature do
  include FakeAppleTestHelper

  before(:each){ stub_apple }

  let(:invalid_imei) { 'invalid' }
  let(:in_warranty_imei){ '013977000323877' }
  let(:expired_warranty_imei){ '013896000639712' }

  it 'finds device with warranty' do
    visit devices_path
    fill_in 'imei', with: in_warranty_imei
    click_button 'Search'
    expect(page).to have_content(I18n.t('in_warranty'))
  end

  it 'finds device without warranty' do
    visit devices_path
    fill_in 'imei', with: expired_warranty_imei
    click_button 'Search'
    expect(page).to have_content(I18n.t('out_of_warranty'))
  end

  it 'does not find device with invalid IMEI' do
    visit devices_path
    fill_in 'imei', with: invalid_imei
    click_button 'Search'
    expect(page).to have_content(I18n.t('device_not_found', imei: invalid_imei))
  end

end