class EmployeePolicy < ApplicationPolicy
    def create?  
      if is_admin? or is_store_role?
        true
      else
        false
      end
    end 
end