class Ticket < ApplicationRecord
  enum status: { active: 0, closed: 1 }

  has_many :comments, -> { order('created_at DESC') }, dependent: :destroy
  belongs_to :user

  validates_presence_of :title, :description
  validates :status, inclusion: statuses.keys

  def self.recent
    order("created_at DESC")
  end

  def close
    update_columns(status: 1, closed_at: Time.zone.now)
  end

  def reopen
    active!
  end
end
