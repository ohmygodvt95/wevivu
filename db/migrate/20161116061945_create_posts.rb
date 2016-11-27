class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :location_id
      t.integer :category_id
      t.string :title
      t.text :body
      t.json :data, null: false, default: {comments: 0, rates: [0, 0, 0, 0, 0]}
      t.timestamps null: false
    end
  end
end
