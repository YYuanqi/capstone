class GeocoderCache
  attr_accessor :geocoder

  def initialize(geocoder)
    @geocoder = geocoder
  end

  def geocode(address)
    cache = CachedLocation.by_address(address).first
    if !cache
      geoloc = @geocoder.geocode(address)
      cache = CachedLocation.create(address: address,
                                     lng: geoloc.position.lng,
                                     lat: geoloc.position.lat,
                                     location: geoloc.to_hash)
    end
    cache&.valid? ? [cache.location, cache] : nil
  end
end
