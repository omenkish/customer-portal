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
    update_columns(status: 0, closed_at: nil)
  end

  def self.closed_since_last_month
    where('status =? AND updated_at >= NOW() - INTERVAL 30 DAY', 1)
        .pluck(:id, :title, :description, :status, :closed_at, :user_id, :created_at)
  end

end
