class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :title
      t.string :src
      t.timestamps null: false
    end
  end
end
