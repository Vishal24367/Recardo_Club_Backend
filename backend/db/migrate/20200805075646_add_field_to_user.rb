class AddFieldToUser < ActiveRecord::Migration[5.2]
  def up
    unless column_exists? :users, :employee_code
      add_column :users, :employee_code, :string
    end
    unless column_exists? :employee_records, :employee_id
      add_column :employee_records, :employee_id, :integer
    end
  end

  def down
    if column_exists? :users, :employee_code
      remove_column :users, :employee_code
    end
    if column_exists? :employee_records, :employee_id
      remove_column :employee_records, :employee_id
    end
  end
end
