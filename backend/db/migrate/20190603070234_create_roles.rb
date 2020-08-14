class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string        :name
      t.references    :organization, index: true, foreign_key: true
      t.references    :department, index: true, foreign_key: true
      t.jsonb         :configurations
      t.timestamps
    end
  end
end
