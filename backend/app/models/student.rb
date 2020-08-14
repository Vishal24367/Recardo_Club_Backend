class Student < ApplicationRecord
    audited
    validates :name, presence: true, uniqueness: true 
end
