class Comment < ApplicationRecord
  audited
  
  alias_attribute :employee_id, :user_id

  validates :comment_text, presence: true, allow_blank: false
  validates :employee, presence: true
  validates :job, presence: true

  belongs_to :job
  belongs_to :job_log
  belongs_to :employee, class_name: "Employee", foreign_key: "user_id"
  belongs_to :organization

  # before_create :set_editable

  def set_editable
    self.is_editable = true
  end

  def set_uneditable
    self.update!(is_editable: false)
  end
end
