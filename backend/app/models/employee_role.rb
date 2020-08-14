class EmployeeRole < ApplicationRecord
  audited
  belongs_to :employee, class_name: "Employee", foreign_key: "user_id"
  belongs_to :role
  validates_presence_of :role
  validates_uniqueness_of :employee, scope: :role
end
