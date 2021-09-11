local player = require('game/entities/player')
local projectiles = require('game/projectiles')

function love.load()
    player:init()
    projectiles:init()
end

function love.keypressed(key)
    if key == 'space' then
        player:shoot(projectiles)
    end
end

function love.update(dt)
    player:update(dt)
    projectiles:update(dt)
end

function love.draw()
    player:draw()
    projectiles:draw()
end
