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

  def destroy?
    organizer_or_admin?
  end

  def get_linkables?
    true
  end

  def get_images?
    true
  end

  def add_image?
    member_or_organizer?
  end

  def update_image?
    organizer?
  end

  def remove_image?
    organizer_or_admin?
  end

  class Scope < Scope
    def resolve
      user_roles
    end

    def user_roles(members_only = true, allow_admin=true)
      include_admin = allow_admin && @user && @user.is_admin?
      member_join = members_only && !include_admin ? 'join' : 'left join'
      join_clause = ["#{member_join} roles on roles.mname='Thing'",
                    "roles.mid=things.id",
                    "roles.user_id #{user_criteria}"].join(" and ")
      scope.select("things.*, roles.role_name")
        .joins(join_clause)
        .tap do |scp|
        scp.where("roles.role_name": [Role::MEMBER, Role::ORGANIZER]) if member_only
      end
    end
  end
end
