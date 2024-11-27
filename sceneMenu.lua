local sceneMenu = newScene("menu")

sceneMenu.load = function(data)
end

sceneMenu.update = function(dt)

end

sceneMenu.draw = function()
    love.graphics.print("Menu", 100, 100)
end

sceneMenu.keypressed = function(key)
    if key == "space" then
        changeScene("game", "Hello World")
    end
end