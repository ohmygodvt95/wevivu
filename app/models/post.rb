class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :category
  has_many :comments
  has_many :images
  has_many :rates
end
