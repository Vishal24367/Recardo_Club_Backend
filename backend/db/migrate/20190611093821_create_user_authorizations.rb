class CreateUserAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_authorizations do |t|
      t.boolean       :is_active, default: true
      t.references    :user,  index: true, foreign_key: true
      t.references    :authorization,  index: true, foreign_key: true
      t.references    :organization,  index: true, foreign_key: true
      t.timestamps
    end
  end
end
