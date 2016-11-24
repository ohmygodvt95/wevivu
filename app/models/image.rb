class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  require 'carrierwave/orm/activerecord'
  mount_uploader :src, FileUploader
end
