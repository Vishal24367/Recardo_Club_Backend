class Role < ApplicationRecord
  audited
  has_many :employee_roles
  has_many :employees, through: :employee_roles
  has_many :roles, through: :employee_roles

  validates :name, presence: true, uniqueness: true 
end
