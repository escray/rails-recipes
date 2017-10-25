#
class Event < ApplicationRecord
  validates_presence_of :name, :friendly_id
  validates_uniqueness_of :friendly_id
  validates_format_of :friendly_id, with: /\A[a-z0-9\-]+\z/

  before_validation :generate_friendly_id, on: :create

  def to_param
    # "#{id}-#{name}"
    friendly_id
  end

  protected

  def generate_friendly_id
    friendly_id || SecureRandom.uuid
  end
end
