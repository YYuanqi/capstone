class ThingPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    originator?
  end

  def update?
    organizer?
  end

  def delete?
    organizer_or_admin?
  end

  class Scope < Scope
    def resolve
      user_roles
    end

    def user_roles
      join_claus = ["join roles on roles.mname='Thing'",
                    "roles.mid=things.id",
                    "roles.user_id #{user_criteria}"].join(" and ")
      scope.select("images, roles.user_roles").joins(join_claus)
        .where("roles.role_name": [Role::MEMBER, Role::ORGANIZER])
    end
  end
end
