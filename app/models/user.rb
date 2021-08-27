class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  before_create :set_default_role
  after_create :send_email, if: :approved?
  enum status: { pending: 0, approved: 1 }

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    admin_role_id = Role.find_by(name: 'admin').id
    roles.exists?(admin_role_id)
  end

  private

  def set_default_role
    roles << Role.find_by(name: 'buyer') if roles.empty?
  end

  def send_email
    UserMailer.welcome_email(self).deliver_later
  end
end
