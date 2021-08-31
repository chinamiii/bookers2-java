class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


        has_many :books, dependent: :destroy
        has_many :book_comments, dependent: :destroy
        has_many :favorites, dependent: :destroy

        has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
        #フォローされる側からのrelationships
        has_many :followers, through: :reverse_of_relationships, source: :follower
        #自分をフォローしている人をとってくる
        has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
        #フォローする側からのrelationships
        has_many :followings, through: :relationships, source: :followed
        #自分がフォローしている人をとってくる



        attachment :profile_image

        validates :name, presence: true, uniqueness: true,
                         length: { minimum: 2, maximum: 20 }

        validates :introduction, length: { maximum: 50 }



        def follow(user_id)
          relationships.create(followed_id: user_id)
        end
        def unfollow(user_id)
          relationships.find_by(followed_id: user_id).destroy
        end
        def following?(user)
          followings.include?(user)
        end

end
