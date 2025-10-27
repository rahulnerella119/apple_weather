# ForecastsController handles requests related to displaying weather forecasts
class ForecastsController < ApplicationController
  # GET /forecasts/new
  def new
    # render the new template, which has a form to enter an address
  end

  # GET /forecasts/show
  def show
    address = params[:address] || params.dig(:forecast, :address)
    # if the address is blank, render the new template with an alert
    if address.blank?
      flash[:alert] = "Enter an address"
      return render :new
    end

    # call the GeocodingService to look up the address
    geo = GeocodingService.lookup(address)
    # if the address is not found, render the new template with an alert
    unless geo
      flash[:alert] = "Address not found"
      return render :new
    end

    # construct the key for caching the forecast
    key = "forecast:#{geo[:postal_code] || "#{geo[:lat]},#{geo[:lon]}"}:metric"
    # check if the forecast is already cached
    @cached = Rails.cache.exist?(key)

    # fetch the forecast from cache or from the WeatherService
    @forecast = Rails.cache.fetch(key, expires_in: 30.minutes) do
      WeatherService.new(lat: geo[:lat], lon: geo[:lon]).fetch_forecast
    end

    # construct the label for the location
    @location_label = "#{address} (#{geo[:postal_code] || "#{geo[:lat]},#{geo[:lon]}"})"
    # render the show template
    render :show
  rescue => e
    # log an error if something goes wrong
    Rails.logger.error("Forecast error: #{e.message}")
    # render the new template with an alert
    flash[:alert] = "Unable to retrieve forecast right now"
    render :new
  end
end

