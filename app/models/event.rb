#
class Event < ApplicationRecord
  STATUS = %w[draft public private].freeze
  validates_presence_of :name, :friendly_id
  validates_uniqueness_of :friendly_id
  validates_format_of :friendly_id, with: /\A[a-z0-9\-]+\z/
  validates_inclusion_of :status, in: STATUS

  belongs_to :category, optional: true
  has_many :tickets, dependent: :destroy, inverse_of: :event
  has_many :registrations, dependent: :destroy

  accepts_nested_attributes_for :tickets,
                                allow_destroy: true,
                                reject_if: :all_blank

  before_validation :generate_friendly_id, on: :create

  scope :only_public, -> { where(status: 'public') }
  scope :only_available, -> { where(status: %w[public private]) }

  include RankedModel
  ranks :row_order

  def to_param
    # "#{id}-#{name}"
    friendly_id
  end

  protected

  def generate_friendly_id
    friendly_id || SecureRandom.uuid
  end
end
