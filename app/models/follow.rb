class Follow < ActiveRecord::Base
  belongs_to :user_follower, foreign_key: 'user_id', class_name: 'User'
  belongs_to :user_followed, foreign_key: 'user_has_follow',class_name: 'User'
end
