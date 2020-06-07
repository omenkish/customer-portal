class User < ApplicationRecord
  enum role: {
    customer: 'customer',
    agent:    'agent',
    admin:    'admin'
  }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  has_many :tickets, dependent: :destroy

  before_save :downcase_email

  validates :name,  presence: true, length: { maximum: 50 }

  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :role, inclusion: roles.keys

  def become_an_admin
    admin!
  end

  def become_an_agent
    agent!
  end

  def return_to_customer_role
    customer!
  end


  private
  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end
end
