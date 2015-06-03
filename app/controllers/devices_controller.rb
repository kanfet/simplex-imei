class DevicesController < ApplicationController

  def index
    respond_to do |format|
      format.html
    end
  end

  def search
    @device = Device.find_by_imei(params[:imei])
    respond_to do |format|
      format.html
    end
  end

end
