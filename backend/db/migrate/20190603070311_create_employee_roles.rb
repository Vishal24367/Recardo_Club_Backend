class CreateEmployeeRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_roles do |t|
      t.references    :role, index: true, foreign_key: true
      t.references    :user, index: true, foreign_key: true
      t.references    :ar_class, index: true, foreign_key: true
      t.timestamps
    end
  end
end
