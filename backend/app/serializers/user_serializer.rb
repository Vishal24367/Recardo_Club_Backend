# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :firstname, :lastname, :title, :state, :gender
  # , :authorized_routes
  # has_one :organization

  def authorized_routes
    Authorization.where(id: object.user_authorizations.where(is_active: true).pluck(:authorization_id)).pluck(:route_name) rescue nil
  end

end
