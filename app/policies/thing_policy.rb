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
      scope
    end
  end
end
