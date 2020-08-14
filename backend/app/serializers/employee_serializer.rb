# frozen_string_literal: true

class EmployeeSerializer < UserSerializer
  attributes :id, :email, :firstname, :lastname, :title, :state, :otp, :gender
  #
  # has_many :workcentre_workers

  
end
