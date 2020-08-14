class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.integer :year, index: true, foreign_key: true, default: 0
      t.string :roll_no
      t.string :section
      t.string :language
      t.string :skills
      t.string :contact_no
      t.string :codingPlatform
      t.string :handleNames
      t.string :dataStructureKnowledge
      t.references :department, index: true, foreign_key: true, default: 0
      t.timestamps
    end
  end
end
