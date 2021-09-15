local helper = {}

function helper:dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. self:dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

function helper.distance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

function helper:circlesCollide(x1, y1, r1, x2, y2, r2)
    return self.distance(x1, y1, x2, y2) <= r1 + r2
end

return helper
