class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def organizer?
    @user.has_role([Role::ORGANIZER], @record.model_name.name, @record.id)
  end

  def organizer_or_admin?
    @user.has_role([Role::ADMIN, Role::ORGANIZER], @record.model_name.name, @record.id)
  end

  def member_or_orgnizer?
    @user.has_role([Role::MEMBER, Role::ORGANIZER], @record.model_name.name, @record.id)
  end

  def member?
    @user.has_role([Role::MEMBER], @record.model_name.name, @record.id)
  end

  def originator?
    @user.has_role([Role::ORIGINATOR], @record.model_name.name)
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end


  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end

    def user_criteria
      if @user
        "=#{@user.id.to_i}"
      else
        'is null'
      end
    end
  end

  def self.merge scope
    prev = nil
    scope.select do |r|
      if prev && prev.id == r.id
        prev.user_roles << r.role_name if r.role_name
        false #toss this
      else
        r.user_roles << r.role_name if r.role_name
        prev = r
      end
    end
  end
end
