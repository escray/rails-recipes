#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w[admin editor].freeze

  has_many :memberships
  has_many :groups, through: :memberships
  has_many :registrations

  has_one :profile

  accepts_nested_attributes_for :profile

  def display_name
    email.split('@').first
  end

  def admin?
    role == 'admin'
  end

  def editor?
    %w[admin editor].include?(role)
  end
end
