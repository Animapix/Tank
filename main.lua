SCREEN_WIDTH, SCREEN_HEIGHT = 1280, 720


require("utils")

require("sceneManager")

require("sceneGame")
require("sceneMenu")

function love.load()
    love.window.setMode(SCREEN_WIDTH,SCREEN_HEIGHT, { resizable = true, vsync = false, centered = true })
    love.window.setTitle("Mon super jeu qui tue")
    changeScene("game")
end

function love.update(dt)
    updateCurrentScene(dt)
end

function love.draw()
    drawCurrentScene()
end

function love.keypressed(key)
    keypressed(key)
end

function love.mousepressed(x, y, button)
    mousepressed(x, y, button)  
end
