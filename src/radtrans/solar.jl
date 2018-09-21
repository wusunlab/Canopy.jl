"""
Solar position and radiation functions.

- [`eccentricity`](@ref)
- [`atmospheric_refraction`](@ref)
- [`solar_angle`](@ref)
"""
module Solar

include("../docstring_style.jl")

import Dates

export eccentricity,
    atmospheric_refraction,
    solar_angle

"""
Convert `Dates.Millisecond` to number of days (`Float64`).

# Examples

```jldoctest
julia> ms2day(Dates.Millisecond(86400_000))
1.0
```
"""
ms2day(ms::Dates.Millisecond) = ms.value * 1e-3 / 86400.0

"""
Compute the earth's orbital eccentricity. `t` can be either a number or a
`Dates.DateTime` type. If `t` is a number, it is treated as in thousands of
Julian years from J2000.

# References

- [SBC94] Simon, J. L., Bretagnon, P., Chapront, J., Chapront-Touzé, M.,
  Francou, G., and Laskar, J. (1994). *Astron. Astrophys.*, 282, 663--683.
  Retrieved from <http://adsabs.harvard.edu/abs/1994A%26A...282..663S> on
  2018-06-12.

# Examples

```jldoctest
julia> println("eccentricity in 2018: ", eccentricity((2018 - 2000) * 1e-3))
eccentricity in 2018: 0.01670106351746052

julia> println("eccentricity in 2018: ", eccentricity(Dates.DateTime(2018)))
eccentricity in 2018: 0.016701062941387256
```

# Known issues

!!! note

    `eccentricity(dt::Dates.DateTime)` gives more accurate result for a known
    date because the number of days in a leap year differs from that in a
    normal year.
"""
eccentricity(t) = abs(t) <= 1 ?
    0.016_708_634_2 - 4.203_654e-4 * t - 1.267_34e-5 * t * t +
    1.444e-7 * t^3 - 2e-10 * t^4 + 3e-10 * t^5 :
    error("Applicable range: year 1000 -- 3000 AD.")

eccentricity(dt::Dates.DateTime) =
    eccentricity(ms2day(dt - Dates.DateTime(2000)) / 365250.)

"""
Convert the time part of `Dates.DateTime` to the fraction of a day (`Float64`).

# Examples

```jldoctest
julia> partial_day(Dates.DateTime(2017, 6, 5, 11, 15))
0.46875
```
"""
partial_day(dt::Dates.DateTime) = Dates.hour(dt) / 24. +
    Dates.minute(dt) / 1440. +
    (Dates.second(dt) + Dates.millisecond(dt) * 1e-3) / 86400.

"""
Calculate the atmospheric refraction effect from solar elevation angle
(`angle`). Both the argument and the return are in degrees.

# Examples

```jldoctest
julia> atmospheric_refraction(40.)
0.019200724191321145

julia> atmospheric_refraction(-1.0)
0.3305949063659434
```
"""
function atmospheric_refraction(angle)
    if angle > 85.
        return 0.
    elseif 5. < angle <= 85.
        return @evalpoly(
            1. / tand(angle), 0., 58.1, 0., -0.07, 0., 8.6e-5) / 3600.
    elseif -0.575 < angle <= 5.
        return @evalpoly(
            angle, 1735., -518.2, 103.4, -12.79, 0.711) / 3600.
    else
        return -20.774 / (3600. * tand(angle))
    end
end

"""
Calculate solar angles and sunrise/sunset times.

The original program was created by NOAA Global Radiation Group
<http://www.esrl.noaa.gov/gmd/grad/solcalc/calcdetails.html>. Ported to Julia
by Wu Sun on 2017-09-24.

# Parameters

- `dt`: `Dates.DateTime`.
- `lat`: Latitude (-90 -- +90°).
- `lon`: Longitude (-180 -- +180°).
- `timezone` (*optional*): Time zone (-12 -- +12). Default is 0.

# Returns

`solar_angle_results::Dict` --- Unpack the keys to get the results.

- "solar noon": Local solar noon, in fraction of a day.
- "sunrise": Sunrise time, in fraction of a day.
- "sunset": Sunset time, in fraction of a day.
- "sunlight duration": Sunlight duration in fraction of a day.
- "hour angle": Hour angle [deg].
- "solar zenith angle": Solar zenith angle [deg].
- "solar elevation angle": Solar elevation angle [deg].
- "solar azimuth angle": Solar azimuth angle [deg].
- "atmospheric refraction": Atmospheric refraction [deg].
- "corrected solar zenith angle": Solar zenith angle corrected for
  atmospheric refraction [deg].
- "corrected solar elevation angle": solar elevation angle corrected
  for atmospheric refraction [deg].

# Examples

```jldoctest
julia> solar_angle(Dates.DateTime(2017, 9, 24), 34, -118, -7)
Dict{String,Float64} with 11 entries:
  "sunset"                          => 0.782313
  "atmospheric refraction"          => 0.00403875
  "corrected solar elevation angle" => -55.0082
  "solar zenith angle"              => 145.012
  "solar elevation angle"           => -55.0122
  "solar azimuth angle"             => 340.545
  "hour angle"                      => 168.99
  "solar noon"                      => 0.530585
  "sunrise"                         => 0.278857
  "sunlight duration"               => 0.503456
  "corrected solar zenith angle"    => 145.008
```
"""
function solar_angle(dt::Dates.DateTime, lat, lon, timezone=0.)
    # NASA truncated Julian date method: JD = 2440000.5 at 1968-05-24T00:00:00
    timedelta = dt - Dates.DateTime(1968, 5, 24)  # Dates.Millisecond
    julian_day = 2440000.5 + ms2day(timedelta) - timezone / 24.
    julian_century = (julian_day - 2451545.) / 36525.

    # geometric mean longitude of the sun [deg]
    geom_mean_lon_sun = (280.46646 + julian_century *
                         (36000.76983 + julian_century * 0.0003032)) % 360.0
    # geometric mean anomaly of the sun [deg]
    geom_mean_anom_sun = 357.52911 + julian_century *
        (35999.05029 - 0.0001537 * julian_century)
    # eccentricity of the earth orbit
    eccent_earth_orbit = eccentricity(dt - Dates.Millisecond(timezone * 3.6e6))
    # solar equator of center
    sun_eq_ctr = sind(geom_mean_anom_sun) *
        (1.914602 - julian_century * (0.004817 + 1.4e-5 * julian_century)) +
        sind(geom_mean_anom_sun * 2) *
        (0.019993 - 0.000101 * julian_century) +
        sind(geom_mean_anom_sun * 3) * 0.000289  # sind := sin o deg2rad
    # solar true longitude [deg]
    sun_true_lon = geom_mean_lon_sun + sun_eq_ctr
    # solar true anomaly [deg]
    sun_true_anom = geom_mean_anom_sun + sun_eq_ctr
    # solar apparent longitude [deg]
    sun_app_lon = sun_true_lon - 0.00569 - 0.00478 *
        sind(125.04 - 1934.136 * julian_century)
    # mean obliquity of the ecliptic [deg]
    mean_obliq_ecliptic = 23. +
        (26. + (21.448 - julian_century *
                (46.815 + julian_century *
                 (0.00059 - julian_century * 0.001813))) / 60.) / 60.
    # corrected obliquity [deg]
    obliq_corr = mean_obliq_ecliptic + 0.00256 *
        cosd(125.04 - 1934.136 * julian_century)
    # solar declination angle [deg]
    sun_declin = asind(sind(obliq_corr) * sind(sun_app_lon))

    #= DEPRECATED
    # solar rad vector [AU]
    sun_rad_vector = 1.000001018 *
        (1. - eccent_earth_orbit * eccent_earth_orbit) /
        (1. + eccent_earth_orbit * cosd(sun_true_anom))
    # cosd := cos o deg2rad
    sun_rt_ascen = atand(cosd(obliq_corr) * sind(sun_app_lon) /
                         cosd(sun_app_lon))   # atand := rad2deg o atan
    =#

    var_y = let
        y = tand(obliq_corr * 0.5)
        y * y
    end
    # equation of time [minute]
    eq_time = 4. * rad2deg(
        var_y * sind(2. * geom_mean_lon_sun) -
        2. * eccent_earth_orbit * sind(geom_mean_anom_sun) +
        4. * eccent_earth_orbit * var_y * sind(geom_mean_anom_sun) *
        cosd(2. * geom_mean_lon_sun) -
        0.5 * var_y * var_y * sind(4. * geom_mean_lon_sun) -
        1.25 * eccent_earth_orbit * eccent_earth_orbit *
        sind(2. * geom_mean_anom_sun))
    HA_sunrise = acosd(cosd(90.833) / (cosd(lat) * cosd(sun_declin)) -
                       tand(lat) * tand(sun_declin))
    # local solar noon [day]
    solar_noon_local = (720. - 4. * lon - eq_time + timezone * 60.) / 1440.
    # local sunrise [day]
    sunrise_local = solar_noon_local - HA_sunrise * 4. / 1440.
    # local sunset [day]
    sunset_local = solar_noon_local + HA_sunrise * 4. / 1440.
    # sunlight duration [day]
    sunlight_duration = 8. * HA_sunrise / 1440.
    # true solar time [minute]
    true_solar_time_minute = mod(
        partial_day(dt) * 1440. + eq_time + 4. * lon - 60. * timezone, 1440.)
    # hour angle [deg]
    hour_angle = true_solar_time_minute / 4. +
        (true_solar_time_minute < 0. ? 180. : -180.)
    # solar zenith angle [deg]
    solar_zenith_angle = acosd(sind(lat) * sind(sun_declin) +
                               cosd(lat) * cosd(sun_declin) * cosd(hour_angle))
    # solar elevation angle [deg]
    solar_elev_angle = 90. - solar_zenith_angle
    # solar azimuth angle [deg]
    solar_azimuth_angle = let
        x = acosd((sind(lat) * cosd(solar_zenith_angle) - sind(sun_declin)) /
                  (cosd(lat) * sind(solar_zenith_angle)))
        hour_angle > 0 ? mod(x + 180., 360.) : mod(540 - x, 360.)
    end
    # approximate atmospheric refraction effect [deg]
    approx_atmos_refrac = atmospheric_refraction(solar_elev_angle)
    # corrected zenith angle and elevation angles [deg]
    solar_zenith_angle_corr = solar_zenith_angle - approx_atmos_refrac
    solar_elev_angle_corr = solar_elev_angle + approx_atmos_refrac

    solar_angle_results = Dict(
        "solar noon" => solar_noon_local,
        "sunrise" => sunrise_local,
        "sunset" => sunset_local,
        "sunlight duration" => sunlight_duration,
        "hour angle" => hour_angle,
        "solar zenith angle" => solar_zenith_angle,
        "solar elevation angle" => solar_elev_angle,
        "solar azimuth angle" => solar_azimuth_angle,
        "atmospheric refraction" => approx_atmos_refrac,
        "corrected solar zenith angle" => solar_zenith_angle_corr,
        "corrected solar elevation angle" => solar_elev_angle_corr)
    return solar_angle_results
end

end  # module
