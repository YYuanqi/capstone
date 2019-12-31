module ThingsHelper
  def restrict_notes? user_roles
    user_roles.empty? && !is_admin?
  end

  def is_admin?
    @current_user.try(:is_admin?)
  end
end
