local bullets = {}

function newBullet()
    local b = {}
    b.x = 0
    b.y = 0
    b.vX = 0
    b.vY = 0
    b.speed = 1000
    b.damage = 50
    b.radius = 5
    b.startX = 0
    b.startY = 0
    b.range = 800
    b.free = false

    b.fire = function(x, y, angle)
        b.x = x
        b.y = y
        b.vX = math.cos(angle) * b.speed
        b.vY = math.sin(angle) * b.speed
        b.startX = x
        b.startY = y
    end

    b.update = function(dt)
        b.x = b.x + b.vX * dt
        b.y = b.y + b.vY * dt

        local dist = distance(b.startX, b.startY, b.x, b.y)

        if dist > b.range then
            b.queueFree()
        end
    end

    b.draw = function()
        love.graphics.circle("fill", b.x, b.y, b.radius)
    end

    b.queueFree = function()
        print("Free bullet")
        b.free = true
    end

    table.insert(bullets, b)
    return b
end


function updateBullets(dt)
    for _, b in ipairs(bullets) do
        b.update(dt)
    end

    for i = #bullets, 1, -1 do
        if bullets[i].free then
            table.remove(bullets, i)
        end
    end
end

function drawBullets()
    for _, b in ipairs(bullets) do
        b.draw()
    end
end


function drawDebug()
    love.graphics.print("Bullets: " .. #bullets, 10, 10)
end


function checkCollisions(enemies)
    for _, b in ipairs(bullets) do
        for _, e in ipairs(enemies) do
            if isIntersecting(b.x, b.y, b.radius, e.x, e.y, e.radius) then
                e.takeDamage(b.damage)
                b.queueFree()
            end
        end
    end
end