Class = require "class"
local push = require "push"

require "Bird"
require "Pipe"
require "PipePair"

require "StateMachine"
require "states.BaseState"
require "states.PlayState"
require "states.TitleScreenState"
require "states.ScoreState"
require "states.CountdownState"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

GAME_WIDTH = 512
GAME_HEIGHT = 288

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514

local backgroundScroll = 0
local groundScroll = 0
scrolling = true


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    background = love.graphics.newImage("background.png")
    ground = love.graphics.newImage("ground.png")


    small_font = love.graphics.newFont("font.ttf", 8)
    medium_font = love.graphics.newFont("flappy.ttf", 14)
    flappy_font = love.graphics.newFont("flappy.ttf", 28)
    huge_font = love.graphics.newFont("flappy.ttf", 56)
    love.graphics.setFont(flappy_font)

    game_sounds = {
        ["jump"] = love.audio.newSource("jump.wav", "static"),
        ["explosion"] = love.audio.newSource("explosion.wav", "static"),
        ["hurt"] = love.audio.newSource("hurt.wav", "static"),
        ["score"] = love.audio.newSource("score.wav", "static"),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ["music"] = love.audio.newSource("marios_way.mp3", "static")
    }

    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = -1,
        fullscreen = false,
        resizable = true
    })
    love.window.setTitle("Flabby Avian")


    game_state_machine = StateMachine {
        ["title"] = function() return TitleScreenState() end,
        ["countdown"] = function() return CountdownState() end,
        ["play"] = function() return PlayState() end,
        ["score"] = function() return ScoreState() end
    }
    game_state_machine:change("title")

    game_sounds["music"]:setLooping(true)
    game_sounds["music"]:play()

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

        game_state_machine:update(dt)
    end

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    love.graphics.clear(40 / 255, 60 / 255, 60 / 255, 1)

    game_state_machine:render()

    love.graphics.draw(ground, -groundScroll, GAME_HEIGHT - 16)

    push:finish()
end

-- ################################################## --
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == "escape" then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.resize(w, h)
    push:resize(w, h)
end
