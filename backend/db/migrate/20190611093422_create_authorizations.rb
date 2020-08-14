class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.string        :name
      t.string        :authorization_type
      t.string        :route_name
      t.timestamps
    end
  end
end
