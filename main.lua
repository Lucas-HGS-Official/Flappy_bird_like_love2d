Class = require "class"
local push = require "push"

require "Bird"
require "Pipe"
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

GAME_WIDTH = 512
GAME_HEIGHT = 288

local backgroundScroll = 0
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413


local pipePairs = {}
local spawnTimer = 0

local last_y = -PIPE_HEIGHT + math.random(80) + 20

local bird

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

    love.keyboard.keysPressed = {}

    bird = Bird()
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GAME_WIDTH

    spawnTimer = spawnTimer + dt
    if spawnTimer > 2 then
        local y = math.max(-PIPE_HEIGHT + 10, math.min(last_y + math.random(-20, 20), GAME_HEIGHT - 90 - PIPE_HEIGHT))
        last_y = y

        table.insert(pipePairs, PipePair(y))
        spawnTimer = 0
    end


    for k, pair in pairs(pipePairs) do
        pair:update(dt)
    end
    for k, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end

    bird:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.clear(40 / 255, 60 / 255, 60 / 255, 1)

    love.graphics.draw(background, -backgroundScroll, 0)

    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    love.graphics.draw(ground, -groundScroll, GAME_HEIGHT - 16)

    bird:render()

    push:finish()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

-- ################################################## --
function love.resize(w, h)
    push:resize(w, h)
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end
