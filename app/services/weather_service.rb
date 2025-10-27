# app/services/weather_service.rb
require 'httparty'

class WeatherService
  # Include HTTParty to make HTTP requests
  include HTTParty

  # Set the base URI for the API
  base_uri 'https://api.openweathermap.org/data/2.5'

  # Initialize the service with the latitude, longitude and API key
  def initialize(lat:, lon:)
    # Store the latitude and longitude for later use
    @lat = lat
    @lon = lon
    # Get the API key from the environment
    @key = ENV.fetch("OPENWEATHER_API_KEY")
  end

  # Fetch the weather forecast from the API
  def fetch_forecast
    # Make a GET request to the API
    resp = self.class.get("/onecall", query: {
      # Set the latitude and longitude
      lat: @lat, lon: @lon,
      # Exclude minutely, alerts
      exclude: "minutely,alerts",
      # Use metric units
      units: "metric",
      # Set the API key
      appid: @key
    })
    # Raise an error if the response is not successful
    raise "Weather API error #{resp.code}" unless resp.success?
    # Parse the response
    parse(resp.parsed_response)
  end

  # Parse the response from the API
  private

  def parse(data)
    # Return a hash with the current weather, today's weather and a list of the next days
    {
      current: {
        # Get the current temperature
        temp: data.dig("current","temp"),
        # Get the current feels like temperature
        feels_like: data.dig("current","feels_like"),
        # Get the current weather description
        desc: data.dig("current","weather",0,"description")
      },
      today: {
        # Get the minimum temperature for today
        min: data.dig("daily",0,"temp","min"),
        # Get the maximum temperature for today
        max: data.dig("daily",0,"temp","max")
      },
      daily: data["daily"]&.map do |d|
        # Return a hash with the minimum and maximum temperatures and the weather description for each day
        { min: d["temp"]["min"], max: d["temp"]["max"], desc: d["weather"][0]["description"] }
      end
    }
  end
end
