class AddFk < ActiveRecord::Migration
  def change
    # posts table
    add_foreign_key :posts, :users, on_delete: :cascade
    add_foreign_key :posts, :locations, on_delete: :cascade
    add_foreign_key :posts, :categories, on_delete: :cascade
  #   images table
    add_foreign_key :images, :users, on_delete: :cascade
    add_foreign_key :images, :posts, on_delete: :cascade
  #   comments table
    add_foreign_key :comments, :users, on_delete: :cascade
    add_foreign_key :comments, :posts, on_delete: :cascade
  #   follows table
    add_foreign_key :follows, :users, on_delete: :cascade
    add_foreign_key :follows, :users, column: :user_has_follow, on_delete: :cascade
  #   bookmarks
    add_foreign_key :bookmarks, :users, on_delete: :cascade
    add_foreign_key :bookmarks, :posts, on_delete: :cascade
  #   rates
    add_foreign_key :rates, :users, on_delete: :cascade
    add_foreign_key :rates, :posts, on_delete: :cascade
  end
end
