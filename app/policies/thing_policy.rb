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

  class Scope < Scope
    def resolve
      user_roles
    end

    def user_roles member_only = true
      join_type = member_only ? 'join' : 'left join'
      join_claus = ["#{join_type} roles on roles.mname='Thing'",
                    "roles.mid=things.id",
                    "roles.user_id #{user_criteria}"].join(" and ")
      scope.select("things.*, roles.role_name")
           .joins(join_claus)
           .tap do |scp|
             scp.where("roles.role_name": [Role::MEMBER, Role::ORGANIZER]) if member_only
           end
    end
  end
end
