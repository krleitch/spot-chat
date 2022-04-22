defmodule SpotChatWeb.GeoHelpers do
  @earth_radius 6_371_000

  def distance_between(lng1, lat1, lng2, lat2, radius \\ @earth_radius) do
    fo_1 = degrees_to_radians(lat1)
    fo_2 = degrees_to_radians(lat2)
    diff_fo = degrees_to_radians(lat2 - lat1)
    diff_la = degrees_to_radians(lng2 - lng1)

    a =
      :math.sin(diff_fo / 2) * :math.sin(diff_fo / 2) +
        :math.cos(fo_1) * :math.cos(fo_2) * :math.sin(diff_la / 2) * :math.sin(diff_la / 2)

    c = 2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))
    max(radius * c, 160) / 1609
  end

  defp degrees_to_radians(degrees) do
    normalize_degrees(degrees) * :math.pi() / 180
  end

  defp normalize_degrees(degrees) when degrees < -180 do
    normalize_degrees(degrees + 2 * 180)
  end

  defp normalize_degrees(degrees) when degrees > 180 do
    normalize_degrees(degrees - 2 * 180)
  end

  defp normalize_degrees(degrees) do
    degrees
  end
end
