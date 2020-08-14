class CreateEmployeeRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_records do |t|

      t.string        :employee_code,                       index: true
      t.datetime      :timestamp_update,                    index: true
      t.datetime      :timestamp_hiring,                    index: true
      t.string        :hiring_code
      t.string        :mobile
      t.text          :address
      t.string        :location
      t.string        :resume_id
      t.datetime      :joining_date
      t.datetime      :releaving_date
      t.integer       :trigger_status
      t.timestamps
    end
  end
end
