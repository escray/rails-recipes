#
class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_timezone
  protect_from_forgery prepend: true, with: :exception

  def set_locale
    if params[:locale] &&
       I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
  end

  def set_timezone
    Time.zone = current_user.time_zone if current_user && current_user.time_zone
  end
end
