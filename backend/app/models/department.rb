class Department < ApplicationRecord
  audited
  belongs_to :organization
  validates_presence_of :name
  validates_uniqueness_of :name
end
