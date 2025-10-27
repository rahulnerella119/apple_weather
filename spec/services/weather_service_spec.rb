require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherService do
  before do
    allow(ENV).to receive(:fetch).with("OPENWEATHER_API_KEY").and_return("fake")
  end

  it "parses api response" do
    body = {
      current: { temp: 20, feels_like: 19, weather: [{ description: "clear" }] },
      daily: [{ temp: { min: 10, max: 25 }, weather: [{ description: "sunny" }] }]
    }.to_json

    stub_request(:get, /api.openweathermap.org/).to_return(status: 200, body: body)
    svc = WeatherService.new(lat: 0, lon: 0)
    res = svc.fetch_forecast
    expect(res[:current][:temp]).to eq(20)
    expect(res[:today][:max]).to eq(25)
  end
end
