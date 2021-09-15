helper = require('game/helper')

local player = require('game/entities/player')
local enemies = require('game/enemies')
local projectiles = require('game/projectiles')

function love.load()
    player:init()
    enemies:init()
    projectiles:init()
end

function love.keypressed(key)
    if key == 'space' then
        player:shoot(projectiles)
    end
end

function love.update(dt)
    player:update(enemies, projectiles, dt)
    enemies:update(projectiles, dt)
    projectiles:update(dt)
end

function love.draw()
    player:draw()
    enemies:draw()
    projectiles:draw()
end
