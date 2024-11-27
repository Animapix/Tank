local bodyImage = love.graphics.newImage("images/Enemy/body.png")
local propellerLImage = love.graphics.newImage("images/Enemy/PropellerL.png")
local PropellerRImage = love.graphics.newImage("images/Enemy/PropellerR.png")

local offsetX = bodyImage:getWidth() / 2
local offsetY = bodyImage:getHeight() / 2

local tank = require("tank")

function newEnemy(x, y)
    local enemy = {}

    enemy.x = x or 0
    enemy.y = y or 0
    enemy.radius = 50
    enemy.free = false
    enemy.life = 100
    enemy.speed = 100
    enemy.seekRange = 200

    enemy.idleMaxDuration = 5
    enemy.idleMinDuration = 2
    enemy.idleTimer = math.random(enemy.idleMinDuration, enemy.idleMaxDuration)

    enemy.direction = math.random(0, 2 * math.pi)
    enemy.patrolMaxDuration = 1
    enemy.patrolMinDuration = 0.5
    enemy.patrolTimmer = math.random(enemy.patrolMinDuration, enemy.patrolMaxDuration)

    enemy.update = function(dt)
        enemy.state(dt)
    end

    enemy.idleState = function(dt)
        if enemy.idleTimer <= 0 then
            enemy.idleTimer = math.random(enemy.idleMinDuration, enemy.idleMaxDuration)
            if math.random(1, 7) ~= 1 then
                enemy.state = enemy.patrolState
            end
        else
            enemy.idleTimer = enemy.idleTimer - dt
        end

        enemy.checkTankDistance()
    end

    enemy.patrolState = function(dt)
        enemy.x = enemy.x + math.cos(enemy.direction) * enemy.speed * dt
        enemy.y = enemy.y + math.sin(enemy.direction) * enemy.speed * dt

        if enemy.patrolTimmer <= 0 then
            enemy.patrolTimmer = math.random(enemy.patrolMinDuration, enemy.patrolMaxDuration)
            enemy.direction = math.random(enemy.direction - math.pi / 4, enemy.direction + math.pi / 4)
            if math.random(1, 7) == 1 then
                enemy.state = enemy.idleState
            end
        else
            enemy.patrolTimmer = enemy.patrolTimmer - dt
        end
        enemy.checkTankDistance()
    end

    enemy.attackState = function(dt)
        local angle = math.atan2(tank.y - enemy.y, tank.x - enemy.x)
        enemy.x = enemy.x + math.cos(angle) * enemy.speed * dt
        enemy.y = enemy.y + math.sin(angle) * enemy.speed * dt
        enemy.checkTankDistance()
    end

    enemy.checkTankDistance = function()
        local dist = distance(enemy.x, enemy.y, tank.x, tank.y)
        if dist < enemy.seekRange then
            enemy.state = enemy.attackState
        end
    end

    enemy.state = enemy.idleState

    enemy.draw = function()
        love.graphics.draw(bodyImage, enemy.x, enemy.y, 0, 1, 1, offsetX, offsetY)
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle("line", enemy.x, enemy.y, enemy.radius)
        love.graphics.setColor(1, 1, 1)
    end

    enemy.takeDamage = function(damages)

        enemy.life = enemy.life - damages
        if enemy.life <= 0 then
            enemy.queueFree()
        end
    end

    enemy.queueFree = function()
        enemy.free = true
    end

    return enemy
end
