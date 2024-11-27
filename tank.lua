local tankImage = love.graphics.newImage("images/Tank/Chassis.png")
local turretImage = love.graphics.newImage("images/Tank/Turret.png")
local imageWidth = tankImage:getWidth()
local imageHeight = tankImage:getHeight()

local offsetX = imageWidth / 2
local offsetY = imageHeight / 2
local oldMouseButtonState = false
local barrrelLength = 55
local fireRate = 0.2

local tank = {}

tank.x = SCREEN_WIDTH * 0.5
tank.y = SCREEN_HEIGHT * 0.5

tank.angle = 0
tank.turretAngle = 0
tank.rotationSpeed = 2
tank.speed = 200

tank.shootTimer = 0

tank.update = function(dt)

    tank.aim(love.mouse.getPosition())
    tank.move(dt)
    tank.turn(dt)

    if love.mouse.isDown(1) and oldMouseButtonState == false then
        tank.shoot()
    end
    
    
    if tank.shootTimer > 0 then
        tank.shootTimer = tank.shootTimer - dt
    end
    

    oldMouseButtonState = love.mouse.isDown(1)
end

tank.turn = function(dt)
    if love.keyboard.isDown("w") then
        tank.x = tank.x + math.cos(tank.angle) * tank.speed * dt
        tank.y = tank.y + math.sin(tank.angle) * tank.speed * dt   
    elseif love.keyboard.isDown("s") then
        tank.x = tank.x - math.cos(tank.angle) * tank.speed * dt
        tank.y = tank.y - math.sin(tank.angle) * tank.speed * dt
    end
end

tank.move = function(dt)
    if love.keyboard.isDown("a") then
        tank.angle = tank.angle - tank.rotationSpeed * dt
    elseif love.keyboard.isDown("d") then
        tank.angle = tank.angle + tank.rotationSpeed * dt
    end
end

tank.aim = function(x, y)
    local angle = math.atan2(y - tank.y, x - tank.x)
    tank.turretAngle = angle
end

tank.shoot = function()
    if tank.shootTimer <= 0 then
        local b = newBullet()
        
        local x =  math.cos(tank.turretAngle) * barrrelLength + tank.x
        local y =  math.sin(tank.turretAngle) * barrrelLength + tank.y

        b.fire(x,y, tank.turretAngle)
        tank.shootTimer = fireRate
    end    
end

tank.draw = function()
    love.graphics.draw(tankImage, tank.x, tank.y, tank.angle, 1, 1, offsetX, offsetY)
    love.graphics.draw(turretImage, tank.x, tank.y, tank.turretAngle, 1, 1, offsetX, offsetY)
end


tank.setFireRate = function(rate)
    if rate < 0 then
        rate = 0
    elseif rate > 10 then
        rate = 10
    end
    fireRate = rate
end

return tank