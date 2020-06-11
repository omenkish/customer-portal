class User < ApplicationRecord
  after_destroy :ensure_an_admin_remains

  enum role: {
    customer: 'customer',
    agent:    'agent',
    admin:    'admin'
  }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  has_many :comments, dependent: :destroy
  has_many :user_tickets, dependent: :destroy
  has_many :tickets, -> { order('created_at DESC') }, dependent: :destroy

  before_save :downcase_email

  validates :name,  presence: true, length: { maximum: 80 }

  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true, confirmation: true
  validates :role, inclusion: roles.keys

  class Error < StandardError; end

  def become_an_admin
    admin!
  end

  def become_an_agent
    agent!
  end

  def revoke_admin_or_agent_privilege
    customer!
  end

  def first_name
    name.split(' ').first
  end

  private
  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end
end
