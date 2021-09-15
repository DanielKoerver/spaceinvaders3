local enemies = {}

enemies.entities = {}

enemies.types = {}
enemies.types.abstract = require('game/entities/enemies/abstract')

-- types
enemies.types.asteroid = helper.mergeTables(setmetatable({}, {__index = enemies.types.abstract}), require('game/entities/enemies/asteroid'))
enemies.types.weakAsteroid = helper.mergeTables(setmetatable({}, {__index = enemies.types.asteroid}), require('game/entities/enemies/weakAsteroid'))

enemies.nextSpawn = love.timer.getTime() + 1

function enemies:init()
    for enemyTypeName, enemyType in pairs(self.types) do
        -- load images
        if enemyTypeName ~= 'abstract' then
            enemyType.images = {}
            for i = 1, enemyType.imageAmount do
                local image = ''
                if enemyType.imageAmount == 1 then
                    image = 'assets/images/enemies/'..enemyTypeName..'.png'
                else
                    image = 'assets/images/enemies/'..enemyTypeName..i..'.png'
                end
                enemyType.images[i] = love.graphics.newImage(image)
            end
        end
    end
end

function enemies:reset()
    self.entities = {}
    self.nextSpawn = love.timer.getTime() + 1
end

function enemies:spawn(type)
    local entity = setmetatable({}, {__index = self.types[type]})

    entity.type = type
    if entity.init then entity:init() end
    if entity.typeInit then entity:typeInit() end

    table.insert(self.entities, entity)
end

function enemies:update(player, projectiles, dt)
    -- spawn new enemies
    if love.timer.getTime() > self.nextSpawn then
        local spawnEnemyTypes = {'asteroid', 'weakAsteroid'}
        self:spawn(spawnEnemyTypes[love.math.random(1, #spawnEnemyTypes)])
        self.nextSpawn = love.timer.getTime() + 2 + love.math.random()
    end

    -- update positions
    for i, entity in ipairs(self.entities) do
        if entity.move then entity:move(dt) end
    end

    -- additional update if applicable
    for i, entity in ipairs(self.entities) do
        if entity.update then entity:update(player, projectiles, dt) end
    end

    -- remove objects which are out of window
    for i = #self.entities, 1, -1 do
        if self.entities[i].position.y > love.graphics.getHeight() + self.entities[i].radius or
        self.entities[i].remove then
            table.remove(self.entities, i)
        end
    end
end

function enemies:draw()
    for _, entity in ipairs(self.entities) do
        entity:draw()
        if game.debugMode and entity.drawDebug then entity:drawDebug() end
    end
end

return enemies
