# frozen_string_literal: true

class WorkcentreWorkerSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :is_accountable, :configurations
end
