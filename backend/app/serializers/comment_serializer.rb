class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment_text, :employee_id, :author_name, :is_editable, :configurations, :created_at, :updated_at
  # has_one :job
  

  def author_name
    fullname = object.employee.fullname
  end
end
