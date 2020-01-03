class ImagePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    @user
  end

  def update?
    organizer?
  end

  def destroy?
    organizer_or_admin?
  end

  def get_things?
    true
  end

  class Scope < Scope
    def resolve
      user_roles
    end

    def user_roles
      joins_clause = ["left join roles on roles.mname='Image'",
                      "roles.mid=images.id",
                      "roles.user_id #{user_criteria}"].join(' and ')
      scope.select("images.*, roles.role_name").joins(joins_clause)
    end
  end
end
