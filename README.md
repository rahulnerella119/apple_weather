Apple Weather
==============

Overview
--------

Apple Weather is a Ruby on Rails application that provides real-time and seven-day weather forecasts for any location worldwide.
The application integrates with the OpenWeather API for accurate weather data and uses the Geocoder gem to convert user-entered city names or addresses into geographic coordinates (latitude and longitude).
To enhance performance and reduce external API usage, the application uses Redis caching to store responses temporarily, ensuring fast subsequent requests and minimal API calls.

Features
--------

* Search weather by city name or complete address.
* Retrieve live weather details such as temperature, humidity, and description.
* View a seven-day weather forecast with min and max temperatures.
* Redis-based caching to store API responses for 30 minutes.
* Clear distinction between live and cached data.
* Modular service-based structure for easy testing and extension.
* Scalable, maintainable architecture adhering to Rails best practices.
* Ready for deployment on Heroku, Render, or any cloud provider.

System Architecture
-------------------

The project follows a service-oriented architecture (SOA) pattern.
Service classes handle external API calls separately from the controller, ensuring clear separation of concerns.

app/
controllers/
forecasts_controller.rb        # Handles user requests and responses
services/
weather_service.rb             # Fetches and parses data from OpenWeather API
geocoding_service.rb           # Converts city names into coordinates
views/
forecasts/
index.html.erb            # Displays weather results and search form
jobs/
cache_cleanup_job.rb           # Optional background job to clean cache

Technology Stack
-------------------

Layer	Technology
Framework	Ruby on Rails 7.x
Language	Ruby 3.2.2
API Integration	OpenWeather API
Geocoding	Geocoder (Nominatim)
Caching	Redis
Environment Management	Dotenv
Testing	RSpec / Minitest
Deployment	Heroku / Render / Localhost

Installation and Setup
------------------------

Prerequisites
------------

Ensure the following tools are installed on your system:

Ruby 3.2.2
Rails 7.x
Bundler
Redis server
Git

Usage Instructions
-----------------

Open the homepage at http://localhost:3000.
Enter a city name (e.g., "Hyderabad, India") into the search bar.
The app will:

Convert the city name into coordinates using Geocoder.
Request weather data from the OpenWeather API.
Cache the result in Redis for 30 minutes.
Display real-time weather and forecast.
If the same city is searched again within the cache duration, the cached result is used to reduce API calls.

Example Response Format
-------------------

{
  "current": {
    "temp": 27.5,
    "feels_like": 28.1,
    "desc": "haze"
  },
  "today": {
    "min": 25.0,
    "max": 31.2
  },
  "daily": [
    { "min": 25.0, "max": 31.2, "desc": "haze" },
    { "min": 24.7, "max": 30.9, "desc": "clear sky" },
    { "min": 23.9, "max": 32.0, "desc": "light rain" }
  ]
}

Caching Mechanism
-------------------

How It Works
--------------

Each city's forecast data is cached in Redis for 30 minutes.
The cache key format:
weather:<city_name>
When a user requests the same city within the cache validity, the app retrieves it from Redis.
Once expired, a new API call is made and cached again.

Benefits
-------

Reduced API call costs.
Faster response times.
Lower external dependency load.

Error Handling
--------------

Error	Description	Resolution
401 Unauthorized	Invalid API key	Update OPENWEATHER_API_KEY in .env
404 Not Found	City not found	Verify the city name input
Timeout / 500	API or network issue	Try again or check network
Geocoding Error	Unable to locate coordinates	Verify city spelling or use full address

Author
------

Developed by: Rahul Nerella
Email: rahulnerella1911@gmail.com
GitHub: https://github.com/rahulnerella119

