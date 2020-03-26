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

  def reverse_geocode(point)
    cache = CachedLocation.by_position(point).first
    if !cache
      geoloc = @geocoder.reverse_geocode(point)
      cache = CachedLocation.create(address: geoloc.address.to_s,
                                    lng: point.lng,
                                    lat: point.lat,
                                    location: geoloc.to_hash)
    end
    cache&.valid? ? [cache.location, cache] : nil
  end
end
