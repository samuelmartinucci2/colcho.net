class Room < ActiveRecord::Base
  extend FriendlyId

  belongs_to :user
  has_many :reviews, dependent: :destroy
  scope :most_recent, -> { order("created_at DESC") }

  validates_presence_of :title
  validates_presence_of :slug

  mount_uploader :picture, PictureUploader
  friendly_id :title, use: [:slugged, :history]

  def complete_name
    "#{title}, #{location}"
  end

  def self.search(query)
    if query.present?
      where(['location LIKE :query OR
              title LIKE :query OR
              description LIKE :query', query: "%#{query}%"])
    else
      all
    end
  end
end
