class TestMailer < ApplicationMailer
  default from: "from@test.com"


  def post_email(user, subject)
    @user = user
    @subject = subject
    mail(to: @user, subject: @subject)
  end

  def comment_email(user, subject)
    @user = user
    @subject = subject
    mail(to: @user, subject: @subject)
  end

end
