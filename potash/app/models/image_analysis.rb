class ImageAnalysis < ApplicationRecord
  belongs_to :image

  has_one_attached :analyzed_image

  validate :analyzed_image?

  private
  def analyzed_image?
    errors.add(:base, 'Please upload a valid image (PNG, JPG/JPEG).') unless analyzed_image.attached?
  end
end
