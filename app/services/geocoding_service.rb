# app/services/geocoding_service.rb
# app/services/geocoding_service.rb
class GeocodingService
  # This function takes a string address and returns a hash with the latitude,
  # longitude and postal code if the address can be geocoded.
  #
  # @param [String] address
  # @return [Hash] a hash with latitude, longitude and postal code if the
  #         address can be geocoded. Otherwise nil.
  def self.lookup(address)
    # If the address is blank, return nil
    return nil if address.blank?

    # Search for the address using Geocoder
    results = Geocoder.search(address)
    # If there are no results, return nil
    return nil if results.blank?

    # Get the first result
    first = results.first
    # Return a hash with the latitude, longitude and postal code
    {
      lat: first.latitude,
      lon: first.longitude,
      postal_code: first.postal_code || first.data.dig("address","postcode")
    }
  rescue => e
    # Log the error
    Rails.logger.error("Geocoding error: #{e.message}")
    # Return nil
    nil
  end
end

