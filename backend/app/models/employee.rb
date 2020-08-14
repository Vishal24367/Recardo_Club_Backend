class Employee < User
  has_many :employee_roles, foreign_key: 'user_id', dependent: :destroy
  has_many :roles, through: :employee_roles, dependent: :destroy
  has_one  :employee_record, dependent: :destroy

  accepts_nested_attributes_for :employee_roles, :allow_destroy => true 

  def role?(role)  
    byebug
    roles.any? { |r| r.name.underscore.to_sym == role }  
  end 

end
