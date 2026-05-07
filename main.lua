local push = require "push"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

GAME_WIDTH = 512
GAME_HEIGHT = 288

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    background = love.graphics.newImage("background.png")
    ground = love.graphics.newImage("ground.png")

    love.window.setTitle("Flabby Avian")
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = -1,
        fullscreen = false,
        resizable = true
    })
end

function love.draw()
    push:start()

    love.graphics.clear(40 / 255, 60 / 255, 60 / 255, 1)

    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, GAME_HEIGHT - 16)

    push:finish()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- ################################################## --
function love.resize(w, h)
    push:resize(w, h)
end
