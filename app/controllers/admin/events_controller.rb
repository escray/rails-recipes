#
class Admin::EventsController < AdminController
  before_action :set_event, only: %i[show update edit destroy]

  def index
    @events = Event.all
  end

  def show
    # @event = Event.find(params[:id])
    # @event = Event.find_by_friendly_id!(params[:id])
  end

  def new
    @event = Event.new
    @event.tickets.build
  end

  def create
    @event = Event.new(event_params)
    # @event = Event.find_by_friendly_id!(params[:id])

    if @event.save
      redirect_to admin_events_path
    else
      render 'new'
    end
  end

  def edit
    # @event = Event.find(params[:id])
    @event.tickets.build if @event.tickets.empty?
  end

  def update
    # @event = Event.find(params[:id])
    # @event = Event.find_by_friendly_id!(params[:id])

    if @event.update(event_params)
      redirect_to admin_events_path
    else
      render 'edit'
    end
  end

  def destroy
    # @event = Event.find(params[:id])
    # @event = Event.find_by_friendly_id!(params[:id])
    @event.destroy

    redirect_to admin_events_path
  end

  def bulk_update
    total = 0
    Array(params[:ids]).each do |event_id|
      event = Event.find(event_id)
      if params[:commit] == I18n.t(:bulk_update)
        event.status = params[:event_status]
        total += 1 if event.save
      elsif params[:commit] == I18n.t(:bulk_delete)
        event.destroy
        total += 1
      end
    end

    flash[:alert] = "成功完成#{total}笔"
    redirect_to admin_events_path
  end

  protected

  def event_params
    params.require(:event)
          .permit(:name,
                  :description,
                  :friendly_id,
                  :status,
                  :category_id,
                  tickets_attributes: %i[id name description price _destroy])
  end

  def set_event
    # @event = Event.find(params[:id])
    @event = Event.find_by_friendly_id!(params[:id])
  end
end
