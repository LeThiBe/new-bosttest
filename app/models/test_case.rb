class TestCase < ApplicationRecord
  belongs_to :testsuit
  belongs_to :user
end
