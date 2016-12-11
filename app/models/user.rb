class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :images
  has_many :rates
  has_many :follows
  has_many :bookmarks
  has_many :reports
  require 'carrierwave/orm/activerecord'
  mount_uploader :cover, CoverUploader
  mount_uploader :avatar, AvatarUploader

  before_save{ self.email = email.downcase }

  validates :name,presence: true ,length: {maximum: 50}

  VALID_EMAIL_REGEX=/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,presence: true,length: {minimum:5,maximum: 50},format: {with: VALID_EMAIL_REGEX},uniqueness: {case_sensitive: false}

  has_secure_password

  validates :password,presence: true, length: {minimum: 6}, allow_blank: true
end
