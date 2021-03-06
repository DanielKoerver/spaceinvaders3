local projectiles = {}

projectiles.entities = {}

projectiles.types = {}
projectiles.types.abstract = require('game/entities/projectiles/abstract')

-- types
projectiles.types.playerShot = helper.mergeTables(setmetatable({}, {__index = projectiles.types.abstract}), require('game/entities/projectiles/playerShot'))
projectiles.types.hostileShot = helper.mergeTables(setmetatable({}, {__index = projectiles.types.abstract}), require('game/entities/projectiles/hostileShot'))

function projectiles:init()
    --load images
    for projectileTypeName, projectileType in pairs(self.types) do
        if projectileTypeName ~= 'abstract' then
            projectileType.image = love.graphics.newImage('assets/images/projectiles/'..projectileTypeName..'.png')
        end
    end
end

function projectiles:reset()
    self.entities = {}
end

function projectiles:shoot(type, x, y)
    local entity = setmetatable({}, {__index = self.types[type]})

    if entity.init then entity:init() end
    entity.type = type
    entity.position = {
        x = x,
        y = y
    }

    table.insert(self.entities, entity)

    return entity
end

function projectiles:update(dt)
    -- update positions
    for i, entity in ipairs(self.entities) do
        entity:move(dt)
    end

    -- additional update if applicable
    for i, entity in ipairs(self.entities) do
        if entity.update then entity:update(dt) end
    end

    --remove objects which are out of window
    for i = #self.entities, 1, -1 do
        if self.entities[i].position.y > love.graphics.getHeight() + self.entities[i].collisionRadius or
            self.entities[i].position.y < 0 - self.entities[i].collisionRadius or
            self.entities[i].remove then
            table.remove(self.entities, i)
        end
    end
end

function projectiles:draw()
    for _, entity in ipairs(self.entities) do
        entity:draw()
        if game.debugMode and entity.drawDebug then entity:drawDebug() end
    end
end

return projectiles
