class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :title
      t.string :src
      t.integer :active, default: 0
      #0 - post image, 1 - avatar, 2 - cover
      t.integer :use_for, default: 0
      t.timestamps null: false
    end
  end
end
