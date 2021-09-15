local abstract = {}

abstract = {}

abstract.type = nil

abstract.remove = false

abstract.imageIndex  = 0
abstract.imageAmount = 1
abstract.images = {}

abstract.size = {x = 0, y = 0}
abstract.radius  = 0
abstract.collisionRadius = 0
abstract.collisionRadiusFactor = 1

abstract.collisionDamage = 0
abstract.health = nil

abstract.lastHit = 0
abstract.hitFlashTime = 0.05

abstract.shootfrequency  = 0
abstract.projectileType = nil

abstract.score = nil

function abstract:init()
    -- set random image
    self.imageIndex = love.math.random(1, #self.images)

    -- size
    self.size = {x = self.images[self.imageIndex]:getWidth(), y = self.images[self.imageIndex]:getHeight()}
    self.radius = (self.size.x > self.size.y) and self.size.x / 2 or self.size.y / 2

    -- random start
    self.position = { x = love.math.random(0, love.graphics.getWidth()), y = 0 - self.radius / 2}

    -- speed
    self.speed = {x = 0, y = 0}

    -- lastshot
    self.lastShot = love.timer.getTime()

    self.collisionRadius = self.radius * self.collisionRadiusFactor
end

function abstract:update(player, projectiles, dt)
    -- collision
    for i = #projectiles.entities, 1, -1 do
        local entity = projectiles.entities[i]
        if (helper:circlesCollide(self.position.x, self.position.y, self.collisionRadius, entity.position.x, entity.position.y, entity.collisionRadius)) then
            if entity.team == 'friendly' then
                self:hit(entity.damage)
            end
            table.remove(projectiles.entities, i)
        end
    end

    -- shoot
    if self.shootfrequency > 0 and self.lastShot + self.shootfrequency < love.timer.getTime() then
        self.lastShot = love.timer.getTime()
        self:shoot(projectiles)
    end

    -- die
    if self.health ~= nil and self.health <= 0 then
        self:die(player)
    end
end

function abstract:hit(damage)
    if self.health ~= nil then
        self.health = self.health - damage
        self.lastHit = love.timer.getTime()
    end
end

function abstract:collideWithPlayer(player)
    self:die(player)
end

function abstract:die(player)
    self.remove = true
    if self.score then player:addScore(self.score) end
end

function abstract:shoot(projectiles)
    if self.projectileType ~= nil then
        local projectile = projectiles.shoot(self.projectileType, self.position.x, self.position.y + self.collisionRadius)
        projectile.position.y = projectile.position.y + projectile.collisionRadius
    end
end

function abstract:move(dt)
    self.position.x = self.position.x + self.speed.x * dt
    self.position.y = self.position.y + self.speed.y * dt
end

function abstract:draw()
    local image = self.images[self.imageIndex]

    -- flash on hit
    if (self.health ~= nil and self.lastHit + self.hitFlashTime > love.timer.getTime() and self.lastHit < love.timer.getTime()) then
        love.graphics.setColor({1, 0.75, 0.75})
    else
        love.graphics.setColor({1, 1, 1})
    end

    love.graphics.draw(image, self.position.x, self.position.y, 0, 1, 1, self.size.x / 2, self.size.y / 2)
end

function abstract:drawDebug()
    love.graphics.setColor({255, 0, 0})
    love.graphics.circle('line', self.position.x, self.position.y, self.radius, 20)
    love.graphics.print(self.type, self.position.x - 50, self.position.y - 10)
    love.graphics.print((self.health and self.health or 'nil'), self.position.x - 10, self.position.y + 10)
end

return abstract
