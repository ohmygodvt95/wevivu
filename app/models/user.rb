class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :images
  has_many :rates
  has_many :follows
  has_many :bookmarks
end
