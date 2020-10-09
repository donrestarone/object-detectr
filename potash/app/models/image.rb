class Image < ApplicationRecord
  has_one_attached :captured_image
  has_one :image_analysis, dependent: :destroy


  validate :captured_image?

  private
  def captured_image?
    errors.add(:base, 'Please upload a valid image (PNG, JPG/JPEG).') unless captured_image.attached?
  end
end
