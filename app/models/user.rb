class User < ActiveRecord::Base
  has_many :microposts,
           dependent: :destroy # if a user is destroyed, the user’s microposts should be destroyed as well
  #sami
  #An id used in this manner to connect two database tables is known as a foreign key,
  # and when the foreign key for a User model object is user_id,
  # Rails infers the association automatically: by default,
  # Rails expects a foreign key of the form <class>_id, where <class> is the
  # lower-case version of the class name; So we should specify the name if it's not same
  has_many :active_relationships, class_name:  "Relationship",
           foreign_key: "follower_id",
           dependent:   :destroy
  #By default, in a has_many :through association Rails looks for a foreign key
  # corresponding to the singular version of the association. In other words,
  # with code like :has_many :followeds, through: :active_relationships
  # Rails would see “followeds” and use the singular “followed”,
  # assembling a collection using the followed_id in the relationships table
  #It's awkward to use followeds so we use following
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name:  "Relationship",
           foreign_key: "followed_id",
           dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token
=begin
  Expression	Meaning
  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i	full regex
  /	start of regex
  \A	match start of a string
  [\w+\-.]+	at least one word character, plus, hyphen, or dot
  @	literal “at sign”
  [a-z\d\-.]+	at least one letter, digit, hyphen, or dot
  \.	literal dot
  [a-z]+	at least one letter
  \z	match end of a string
  /	end of regex
  i	case-insensitive
=end
  VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true , length: { maximum: 50 }
  validates :email, presence: true ,
                    length: { maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, length: {minimum: 6}, allow_blank: true
  #validates_length_of(:name, maximum: 50)
  #validates_length_of(:email, maximum: 255)

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
    #update_attribute(:reset_digest,  User.digest(reset_token))
    #update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
=begin
  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    # BCrypt::Password.new(password_digest) == unencrypted_password
    # OR
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
=end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest") #return the value of the given attribute
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Defines a proto-feed.
  def feed
    #sami: the following_ids method is synthesized by Active Record based on the
    # has_many :following association; the result is that
    # we need only append _ids to the association name to get the ids
    # corresponding to the user.following collection
    #following_ids pulls all the followed users’ ids into memory, and creates an
    # array the full length of the followed users array. In the case we have too many
    # following it's not efficient to use:
    #Micropost.where("user_id IN (?) OR user_id = ?", following_ids,id)
    #which is equivalent to
    #Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #                  following_ids: following_ids, user_id: id)
    # So we use subselect:
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)

  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
