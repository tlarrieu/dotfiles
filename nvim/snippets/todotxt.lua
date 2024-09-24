---@diagnostic disable: undefined-global

local day = function(d)
  local curday = os.date('%u')

  local offset = (d - curday) % 7
  if offset == 0 then offset = 7 end

  return os.date('%Y-%m-%d', os.time() + offset * 24 * 60 * 60)
end

local month = function(m)
  local month = tonumber(os.date('%m'))
  local year = tonumber(os.date('%Y'))

  if month >= m then year = year + 1 end

  return string.format('%04d-%02d-01', year, m)
end

return {
  s("today", fmta([[<>]], { f(function()
    return os.date('%Y-%m-%d')
  end) })),
  s("tomorrow", fmta([[<>]], { f(function()
    return os.date('%Y-%m-%d', os.time() + 24 * 60 * 60)
  end) })),
  s("nextweek", fmta([[<>]], { f(function()
    local offset = 7 - tonumber(os.date('%u')) + 1
    return os.date('%Y-%m-%d', os.time() + offset * 24 * 60 * 60)
  end) })),
  s("nextmonth", fmta([[<>]], { f(function()
    local template = string.format('%%Y-%d-01', tonumber(os.date('%m')) + 1)
    return os.date(template, os.time())
  end) })),

  s("january", fmta([[<>]], { f(function() return month(1) end) })),
  s("february", fmta([[<>]], { f(function() return month(2) end) })),
  s("march", fmta([[<>]], { f(function() return month(3) end) })),
  s("april", fmta([[<>]], { f(function() return month(4) end) })),
  s("may", fmta([[<>]], { f(function() return month(5) end) })),
  s("june", fmta([[<>]], { f(function() return month(6) end) })),
  s("july", fmta([[<>]], { f(function() return month(7) end) })),
  s("august", fmta([[<>]], { f(function() return month(8) end) })),
  s("september", fmta([[<>]], { f(function() return month(9) end) })),
  s("october", fmta([[<>]], { f(function() return month(10) end) })),
  s("november", fmta([[<>]], { f(function() return month(11) end) })),
  s("december", fmta([[<>]], { f(function() return month(12) end) })),

  s("monday", fmta([[<>]], { f(function() return day(1) end) })),
  s("tuesday", fmta([[<>]], { f(function() return day(2) end) })),
  s("wednesday", fmta([[<>]], { f(function() return day(3) end) })),
  s("thursday", fmta([[<>]], { f(function() return day(4) end) })),
  s("friday", fmta([[<>]], { f(function() return day(5) end) })),
  s("saturday", fmta([[<>]], { f(function() return day(6) end) })),
  s("sunday", fmta([[<>]], { f(function() return day(7) end) })),
}, {
}
