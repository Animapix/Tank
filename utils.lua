function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function isIntersecting(x1, y1, r1, x2, y2, r2)
    local dist = distance(x1, y1, x2, y2)
    local rSum = r1 + r2
    return  dist < rSum
end