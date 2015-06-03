require 'capybara'
require 'capybara/poltergeist'

class Device

  def self.find_by_imei(imei)
    session = new_browser_session
    session.visit apple_url
    session.within '#serialnumbercheck' do
      session.fill_in 'sn', with: imei
      session.click_button 'Continue'
    end
    if session.has_selector?('#results')
      Device.new
    end
  end

  protected

  def self.apple_url
    'https://selfsolve.apple.com/agreementWarrantyDynamic.do'
  end

  def self.new_browser_session
    Capybara::Session.new(:poltergeist).tap do |s|
      s.driver.headers = { 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X)' }
    end
  end

end