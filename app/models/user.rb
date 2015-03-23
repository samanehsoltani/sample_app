class User < ActiveRecord::Base

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

  before_save {self.email = email.downcase}

  validates :name, presence: true , length: { maximum: 50 }
  validates :email, presence: true ,
                    length: { maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, length: {minimum: 6}
  #validates_length_of(:name, maximum: 50)
  #validates_length_of(:email, maximum: 255)
end
