class UpdateEmployeeRolesRole < ActiveRecord::Migration[5.2]
  def change
    change_column :employee_roles, :role_id, :integer, :null => false
  end
end
