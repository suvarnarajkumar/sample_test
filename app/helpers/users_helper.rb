module UsersHelper
  def role_name(role)
    if role == 0
      'No Access'
    elsif role == 1
     'View Access'
    elsif @user.role == 2
     'Add Access'
    end
  end
end
