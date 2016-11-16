class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :point
      t.timestamps null: false
    end
  end
end
