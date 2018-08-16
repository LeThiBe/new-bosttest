class TestAction < ApplicationRecord
  belongs_to :action_type
  has_many :params, dependent: :destroy
end
