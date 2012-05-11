class ContactMailer < ActionMailer::Base
  default from: "no-replay@andrewloveskristen.com"

  def inbound_email(email, subject, message)
    @subject = subject
    @message  = message
    mail(:from => email, :to => 'ewryan@gmail.com', :cc => 'aegeorge4@gmail.com', :subject => "Message from andrewloveskristen.com: #{subject}")
  end

end
