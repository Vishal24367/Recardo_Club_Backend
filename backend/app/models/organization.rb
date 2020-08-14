class Organization < ApplicationRecord
    audited
    has_many :departments
    validates_presence_of :name
    validates_uniqueness_of :name
end
