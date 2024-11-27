
require("enemy")
require("bullet")

local sceneGame = newScene("game")

local tank = require("tank")
local enemies = {}
local scrore = 0

sceneGame.load = function(data)
    print(data)
    table.insert(enemies, newEnemy(200,200))
    table.insert(enemies, newEnemy(SCREEN_WIDTH - 100,100))
    table.insert(enemies, newEnemy(SCREEN_WIDTH - 100,SCREEN_HEIGHT - 100))
    table.insert(enemies, newEnemy(100, SCREEN_HEIGHT - 100))
end

sceneGame.update = function(dt)
    tank.update(dt)
    
    for _ , enemy in ipairs(enemies) do
        enemy.update(dt)
    end

    checkCollisions(enemies)

    if #enemies <= 0 then
        changeScene("menu", scrore)
    end

    updateBullets(dt)

    for i = #enemies, 1, -1 do
        if enemies[i].free then
            table.remove(enemies, i)
        end
    end
    
end

sceneGame.draw = function()
    tank.draw()
    for _ , enemy in ipairs(enemies) do
        enemy.draw()
    end

    drawBullets()
    drawDebug()
end