require 'sinatra/base'

class FakeApple < Sinatra::Base

  get '/agreementWarrantyDynamic.do' do
    File.read(File.join(Rails.root, 'spec/fixtures/apple/imei-form.html'))
  end

  post '/wcResults.do' do
    File.read(File.join(Rails.root, "spec/fixtures/apple/#{params[:sn]}.html"))
  end

end

module FakeAppleTestHelper

  def stub_apple
    allow(Device).to receive(:new_browser_session) { Capybara::Session.new(:rack_test, FakeApple) }
    allow(Device).to receive(:apple_url){ '/agreementWarrantyDynamic.do' }
  end

end