ScoreState = Class { __includes = BaseState }

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        game_state_machine:change("play")
    end
end

function ScoreState:render()
    love.graphics.setFont(flappy_font)
    love.graphics.printf('Oof! You lost!', 0, 64, GAME_WIDTH, 'center')

    love.graphics.setFont(medium_font)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, GAME_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, GAME_WIDTH, 'center')
end
