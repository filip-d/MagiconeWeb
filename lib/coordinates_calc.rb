#source http://adamish.com/blog/archives/791
module Magicone

class CoordinatesCalc
  def CoordinatesCalc.offset_coordinate(lat_deg, lon_deg, distance_m, bearing_deg)
    r = 6371000.0;
    lat = lat_deg * Math::PI / 180
    lon = lon_deg * Math::PI / 180
    bearing = bearing_deg * Math::PI / 180
    distance_by_r = distance_m / r
    lat2 = Math.asin( Math.sin(lat) * Math.cos(distance_by_r) +
                          Math.cos(lat) * Math.sin(distance_by_r) *
                              Math.cos(bearing) )
    lon2 = lon + Math.atan2(Math.sin(bearing) * Math.sin(distance_by_r) * Math.cos(lat),
                            Math.cos(distance_by_r) - Math.sin(lat) * Math.sin(lat2))
    [180.0 * lat2 / Math::PI, 180.0 * lon2 / Math::PI]
  end
  def CoordinatesCalc.dms(d, m, s)
    d + m / 60.0 + s / 3600.0
  end
  def CoordinatesCalc.dms_to_s(dms)
    d = dms.floor
    m = (60 * (dms - d)).floor
    dm = d + (m / 60.0)
    s = (3600.0 * (dms - dm)).floor
    d.to_s + " " + m.to_s + " " + s.to_s
  end
end
end