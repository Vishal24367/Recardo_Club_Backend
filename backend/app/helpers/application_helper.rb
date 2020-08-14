module ApplicationHelper

  def parse_error_message(errors)
    if errors.is_a?(ActiveModel::Errors)
      message = errors.full_messages.join(", ")
    else
      message = "Some error occured"
    end
  end
end
