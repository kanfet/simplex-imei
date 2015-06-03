require 'sinatra/base'

class FakeApple < Sinatra::Base

  get '/agreementWarrantyDynamic.do' do
    content_type :html
    status 200
    File.read(File.join(Rails.root, 'spec/fixtures/apple/imei-form.html'))
  end

  post '/wcResults.do' do
    content_type :html
    status 200
    File.read(File.join(Rails.root, "spec/fixtures/apple/#{params[:sn]}.html"))
  end

end