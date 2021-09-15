local ui = {}

ui.font  = nil
ui.fontSize  = 20

function ui:init()
    ui.font = love.graphics.newFont('assets/fonts/silkscreen.ttf', ui.fontSize)
end

function ui:draw(player)
    love.graphics.setFont(ui.font)

    --draw health
    love.graphics.setColor({255, 255, 200})
    love.graphics.print('Health: '..player.health, 20, 20)

    --draw score
    love.graphics.setColor({255, 255, 200})
    love.graphics.print('Score: '..player.score, 20, 50)

    if game.hasEnded then
        love.graphics.print('Press space to restart', love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 20)
    end
end

return ui
