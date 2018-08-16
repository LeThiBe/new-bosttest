class TestCase < ApplicationRecord
  belongs_to :test_suit
  belongs_to :user
end
