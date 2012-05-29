class RsvpMailer < ActionMailer::Base

  def rsvp_email(primary, guests, message)
    @primary = primary
    @guests  = guests
    @message = message

    subject_prefix = primary.attending? ? "Attending" : "Not Attending"

    mail(:from => '"andrewloveskristen.com" <noreply@andrewloveskristen.com>', :to => 'andrew.j.matheny@gmail.com', :cc => 'kristenshunk@gmail.com', :subject => "New RSVP - #{subject_prefix} : #{primary.first_name} #{primary.last_name} + #{@guests.size}")
  end

end
