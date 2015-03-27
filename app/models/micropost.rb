class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  #sami
  #The way to tell CarrierWave to associate the image with a model is to use
  # the mount_uploader method, which takes as arguments a symbol representing
  # the attribute and the class name of the generated uploader
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
           length: { maximum: 140 }
  #costum validation
  validate  :picture_size

  private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
