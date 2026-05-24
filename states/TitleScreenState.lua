TitleScreenState = Class { __includes = BaseState }

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        game_state_machine:change("countdown")
    end
end

function TitleScreenState:render()
    love.graphics.setFont(flappy_font)
    love.graphics.printf("Flabby Avian", 0, 64, GAME_WIDTH, "center")

    love.graphics.setFont(medium_font)
    love.graphics.printf("Press Enter", 0, 100, GAME_WIDTH, "center")
end
