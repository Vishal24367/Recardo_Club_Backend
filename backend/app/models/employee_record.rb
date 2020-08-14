class EmployeeRecord < ApplicationRecord
    audited
    belongs_to :employee
  end
  