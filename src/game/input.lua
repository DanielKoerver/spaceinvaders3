local input = {}

function input.handleKeypress(key, player, projectiles)
    if key == 'space' then
        if game.hasEnded then
            love.restart()
        else
            player:shoot(projectiles)
        end
    end

    if key == 'f11' then
        game.debugMode = not game.debugMode
    end
end

return input
