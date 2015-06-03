require 'capybara'
require 'capybara/poltergeist'

class Device

  attr_reader :imei, :in_warranty, :warranty_expiration_date

  def initialize(attrs = {})
    @imei = attrs[:imei]
    @in_warranty = attrs[:in_warranty]
    @warranty_expiration_date = attrs[:warranty_expiration_date]
  end

  def self.find_by_imei(imei)
    session = new_browser_session
    session.visit apple_url
    session.within '#serialnumbercheck' do
      session.fill_in 'sn', with: imei
      session.click_button 'Continue'
    end
    if session.has_selector?('#results')
      in_warranty = session.has_selector?('#results #hardware-true')
      expiration_date = if session.has_selector?('#hardware-text')
                          warranty_expiration_date(session.find('#hardware-text').text)
                        end
      Device.new(imei: imei, in_warranty: in_warranty, warranty_expiration_date: expiration_date)
    end
  end

  protected

  def self.warranty_expiration_date(text)
    date_match = text.match(/Expiration Date: (\w+\s+\d+,\s+\d{4})/)
    if date_match
      begin
        Date.parse(date_match[1])
      rescue ArgumentError => e
      end
    end
  end

  def self.apple_url
    'https://selfsolve.apple.com/agreementWarrantyDynamic.do'
  end

  def self.new_browser_session
    Capybara::Session.new(:poltergeist).tap do |s|
      s.driver.headers = { 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X)' }
    end
  end

end