class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :user_id
      t.integer :post_id
      t.timestamps null: false
    end
    add_foreign_key :reports, :posts, on_delete: :cascade
    add_foreign_key :reports, :users, on_delete: :cascade
  end
end
