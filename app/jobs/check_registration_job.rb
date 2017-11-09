#
class CheckRegistrationJob < ApplicationJob
  queue_as :default

  def perform(registration_id)
    registration = Registration.find(registration_id)

    return if registration.status == 'confirmed'
    registration.status = 'cancelled'
    registration.save!
  end
end
