class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    if is_store_role? or is_commercial_role? or is_admin?
      true
    else
      false
    end
  end

  def show?
    if is_store_role? or is_commercial_role? or is_admin?
      true
    else
      false
    end
  end

  def create?
    if is_commercial_role? or is_admin?
      true
    else
      false
    end
  end

  def new?
    if is_commercial_role? or is_admin?
      true
    else
      false
    end    
  end

  def update?
    if is_commercial_role? or is_admin?
      true
    else
      false
    end    
  end

  def edit?
    if is_commercial_role? or is_admin?
      true
    else
      false
    end
  end

  def destroy?
    if is_admin?
      true
    else
      false
    end
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  private
  def is_admin?
    byebug
    employee = Employee.find_by(email:user.email,firstname:user.firstname,lastname:user.lastname)
    employee.roles.find_by(name:['admin']).present?
  end

  def is_commercial_role?
    employee = Employee.find_by(email:user.email,firstname:user.firstname,lastname:user.lastname)
    employee.roles.find_by(name:['commercial_role']).present?
  end

  def is_store_role?
    employee = Employee.find_by(email:user.email,firstname:user.firstname,lastname:user.lastname)
    employee.roles.find_by(name:['store_role']).present?
  end

end
