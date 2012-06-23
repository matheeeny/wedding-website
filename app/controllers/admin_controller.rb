require 'digest'

class AdminController < ApplicationController

  before_filter :authenticate

  def index
    @rsvps = Rsvp.all
  end

  protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        Digest::MD5.hexdigest(password) == "5cdd6c4f1ac4f34210fa9a1202870d4d"
      end
    end
end
