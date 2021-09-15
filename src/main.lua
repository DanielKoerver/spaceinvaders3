helper = require('game/helper')
game = require('game/game')

local player = require('game/entities/player')
local enemies = require('game/enemies')
local projectiles = require('game/projectiles')
local input = require('game/input')
local ui = require('game/ui')

function love.load()
    player:init()
    enemies:init()
    projectiles:init()
    ui:init()
end

function love.restart()
    player:reset()
    enemies:reset()
    projectiles:reset()
    game.hasEnded = false
end

function love.keypressed(key)
    input.handleKeypress(key, player, projectiles)
end

function love.update(dt)
    if not game.hasEnded then
        player:update(enemies, projectiles, dt)
        enemies:update(player, projectiles, dt)
        projectiles:update(dt)
    end
end

function love.draw()
    player:draw()
    enemies:draw()
    projectiles:draw()
    ui:draw(player)
end
