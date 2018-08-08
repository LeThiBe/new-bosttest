class CreateTestCases < ActiveRecord::Migration[5.2]
  def change
    create_table :test_cases do |t|
      t.string :name
      t.integer :testsuite_id
      t.integer :user_id

      t.timestamps
    end
  end
end
