class TestSuit < ApplicationRecord
  belongs_to :user
  has_many :test_cases, dependent: :destroy
end
