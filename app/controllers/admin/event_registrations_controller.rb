#
class Admin::EventRegistrationsController < ApplicationController
  before_action :find_event

  def index
    @registrations = @event.registrations.includes(:ticket)
                           .order('id DESC').page(params[:page]).per(7)

    @registrations = @registrations.by_status(params[:status]) if
     Registration::STATUS.include?(params[:status]) && params[:status]
     .present?

    @registrations = @registrations.by_ticket(params[:ticket_id]) if
      params[:ticket_id].present?

    @registrations = @registrations.by_status(params[:statuses]) if
      Array(params[:statuses]).any?

    @registrations = @registrations.by_ticket(params[:ticket_ids]) if
      Array(params[:ticket_ids]).any?
  end

  def destroy
    @registration = @event.registrations.find_by_uuid(params[:id])
    @registration.destroy

    redirect_to admin_event_registrations_path(@event)
  end

  protected

  def find_event
    @event = Event.find_by_friendly_id!(params[:event_id])
  end

  def registration_params
    params.require(:registration).permit(:status, :ticket_id, :name,
                                         :email, :cellphone, :website, :bio)
  end
end
