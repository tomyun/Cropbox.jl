using TimeZones
import Dates

@system Calendar begin
    init: t0 => ZonedDateTime(2017, 7, 16, tz"America/Los_Angeles") ~ preserve::ZonedDateTime(extern, parameter)
    time(t0, tick=context.clock.tick): t => t0 + (Cropbox.deunitfy(tick, u"s") |> Dates.Second) ~ track::ZonedDateTime
end

export Calendar
