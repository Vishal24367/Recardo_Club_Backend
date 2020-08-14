class UserAuthorization < ApplicationRecord
  audited
  belongs_to :authorization
  belongs_to :user
end
