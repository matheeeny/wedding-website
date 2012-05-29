require 'digest'

class AdminController < ApplicationController

  before_filter :authenticate

  def index
    @rsvps = Rsvp.all
  end

  protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == "lando" && Digest::MD5.hexdigest(password) == "f6a0df19c20f0a82988e559bed9b2cbb"
      end
    end
end