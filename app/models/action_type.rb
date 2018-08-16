class ActionType < ApplicationRecord
  has_many :test_actions, dependent: :destroy
end
