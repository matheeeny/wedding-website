class RsvpController < ApplicationController

  def index

  end

  def create
    if validate_primary params
      primary = Rsvp.create! :title => params["primary_title"],
                             :first_name => params["primary_first_name"],
                             :last_name => params["primary_last_name"],
                             :primary => true,
                             :phone => params["primary_phone"],
                             :email => params["primary_email"],
                             :attending => params["attending"]
      guests = create_guests params, primary.id

      RsvpMailer.rsvp_email(primary, guests, params["message"]).deliver
      success_message = if primary.attending?
                          "We've created an RSVP for #{params["primary_title"]} #{params["primary_first_name"]} #{params["primary_last_name"]} and #{guests_message guests}. <br/> If you need to make any changes please <a href='/contact'>contact us</a> or call us at 304-745-7582."
                        else
                          "We are sorry you can't make it.  <br/> If you change your mind please <a href='/contact'>contact us</a> or call us at 304-745-7582."
                        end
      flash[:notice] = success_message

    else
      flash[:error] = 'There was an error submitting your RSVP.  Please try again.  All fields are required except phone, email, and message.'
      #TODO - Airbrake
    end

    respond_to do |format|
      format.html { redirect_to("/rsvp") }
    end
  end

  def guests_message guests
    if guests && guests.size == 1
      "#{guests.count} guest"
    else
      "#{guests.count} guests"
    end

  end

  def validate_primary params
    if "yes" == params["attending"]
      result = validate("primary", params)
    end

    result
  end

  def validate prefix="primary", params
    logger.info "validating #{prefix}"
    !params["#{prefix}_first_name"].empty? &&
        !params["#{prefix}_last_name"].empty?
  end

  def create_guests params, primary_id
    guests = []
    1.upto(10) do |guest_num|
      if validate "#{guest_num}_guest", params
        guest = Rsvp.create! :title => params["#{guest_num}_guest_title"],
                             :first_name => params["#{guest_num}_guest_first_name"],
                             :last_name => params["#{guest_num}_guest_last_name"],
                             :primary => false,
                             :guest_of_id => primary_id,
                             :attending => params["attending"]
        guests << guest
      end
    end
    guests
  end

end
