class User < ApplicationRecord
  has_many :microposts,             dependent:  :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                    dependent:  :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                    dependent:   :destroy
                                   
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  has_one_attached :image
  attr_accessor :remember_token
  
  before_save { self.email=email.downcase }
  validates :name,          presence: true,  length: {maximum: 50}
  validates :user_name,     presence: true,  length: {maximum: 50},  uniqueness: true
  validates :email,         presence: true,  length: {maximum: 255}, uniqueness: { case_sensitive: false }
  validates :introduction,  presence: false, length: {maximum: 50}
  validates :image,   content_type: { in: %w[image/jpeg image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message: "should be less than 5MB" }
  
  has_secure_password
  validates :password,  presence: true, length: {minimum: 6}, allow_nil: true
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember_db
    self.remember_token=User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget_db
    update_attribute(:remember_digest, nil)
  end
  
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
   # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_fill: [120, 120])
  end                                    
end