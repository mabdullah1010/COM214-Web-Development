class Document < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  has_one_attached :file

  validates :title, :category, presence: true
  validate :acceptable_file, if: -> { file.attached? }

  private

  def acceptable_file
    acceptable_types = %w[
      application/pdf
      image/jpeg
      image/png
      image/gif
      application/msword
      application/vnd.openxmlformats-officedocument.wordprocessingml.document
    ]
    unless file.content_type.in?(acceptable_types)
      errors.add(:file, "must be a PDF, image, or Word document")
    end
    if file.byte_size > 10.megabytes
      errors.add(:file, "must be less than 10MB")
    end
  end
end
