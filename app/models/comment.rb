class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates :content, presence: true, length: { minimum: 3, maximum: 1000 }

  # Queue job that creates and renders comments
  after_commit { CommentBroadcastJob.perform_later(self) }
end
