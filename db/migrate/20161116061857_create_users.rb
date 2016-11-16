class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.datetime :date_of_birth
      t.integer :sex
      t.string :reset_token
      t.string :remember_token
      t.string :avatar
      t.string :cover
      t.string :status
      t.timestamps null: false
    end
  end
end
