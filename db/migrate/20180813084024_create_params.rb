class CreateParams < ActiveRecord::Migration[5.2]
  def change
    create_table :params do |t|
      t.string :name
      t.integer :text_action_id

      t.timestamps
    end
  end
end
