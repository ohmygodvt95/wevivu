class ResetMail < ApplicationMailer
  default :from => 'service@wevivu.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_reset_pass(user)
    @user = user
    mail( :to => @user.email,
          :subject => 'Request reset password' )
  end
end
