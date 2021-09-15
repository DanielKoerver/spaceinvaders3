local player = {}

player.image = nil

player.size = {x = 0, y = 0}
player.position = {x = 0, y = 0}
player.collisionRadius = 0

player.velocity = {x = 0, y = 0}
player.minimalVelocity = 10
player.acceleration = 1800
player.maxSpeed = 800
player.decellerationFactor = 6
player.frictionFactor = 3

player.collisionInvicibilityTime = 0.8
player.maxHealth = 100
player.health = nil
player.lastHit = 0
player.hitFlashTime = 0.05
player.invincibilityEnd = 0
player.isInvincible = false

function player:init()
    self.image = love.graphics.newImage('assets/images/player.png')
    self.size = {x = self.image:getWidth(), y = self.image:getHeight()}
    self.position = {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() - self.size.y / 2 - 30}
    self.collisionRadius = helper.distance(0, 0, self.size.x, self.size.y) / 2 * 0.7
    self.health = self.maxHealth
end

function player:update(enemies, projectiles, dt)
    self:move(dt)
    self:collide(enemies, projectiles, dt)
end

function player:move(dt)
    local delta = 0

    -- delta
    delta = delta - (love.keyboard.isDown('left') and 1 or 0)
    delta = delta + (love.keyboard.isDown('right') and 1 or 0)
    delta = delta * self.acceleration

    -- decellerate if other direction
    if self.velocity.x * delta < 0 then delta = delta * self.decellerationFactor end

    if delta == 0 then
        -- use friction if no key pressed
        self.velocity.x = self.velocity.x - self.frictionFactor * self.velocity.x * dt
        if math.abs(self.velocity.x) < self.minimalVelocity then self.velocity.x = 0 end
    else
        -- integrate velocity
        self.velocity.x = self.velocity.x + delta * dt
    end

    -- set max speed
    if self.velocity.x > self.maxSpeed then self.velocity.x = self.maxSpeed end
    if self.velocity.x < -self.maxSpeed then self.velocity.x = -self.maxSpeed end

    -- integrate ship position
    self.position.x = self.position.x + self.velocity.x * dt

    -- stop ship at window border
    if self.position.x + self.size.x / 2 > love.graphics.getWidth() then
        self.velocity.x = 0
        self.position.x = love.graphics.getWidth() - self.size.x / 2
    end
    if self.position.x - self.size.x / 2 < 0 then
        self.velocity.x = 0
        self.position.x = self.size.x / 2
    end
end

function player:shoot(projectiles)
    projectiles:shoot('playerShot', self.position.x, self.position.y - self.size.y / 2)
end

function player:collide(enemies, projectiles, dt)
    -- collide with enemies
    for i, entity in ipairs(enemies.entities) do
        if (helper:circlesCollide(self.position.x, self.position.y, self.collisionRadius, entity.position.x, entity.position.y, entity.radius)) then
            self:hit(entity.collisionDamage, player.collisionInvicibilityTime)
            self.velocity.x = self.maxSpeed / 2 * (self.position.x >= entity.position.x and 1 or -1)
            enemies.entities[i]:collideWithPlayer(self)
        end
    end

    -- collide with projectiles
    for i = #projectiles.entities, 1, -1 do
        local entity = projectiles.entities[i]
        if (entity.team == 'hostile' and helper:circlesCollide(self.position.x, self.position.y, self.collisionRadius, entity.position.x, entity.position.y, entity.collisionRadius)) then
            self:hit(entity.damage)
            table.remove(projectiles.entities, i)
        end
    end
end

function player:hit(damage, invincibilityTime)
    if (not self.isInvincible) then
        self.health = self.health - damage
        self.lastHit = love.timer.getTime()

        if invincibilityTime ~= nil then
            self.invincibilityEnd = love.timer.getTime() + invincibilityTime
        end
    end
end

function player:draw()
    -- flash on hit
    if (self.lastHit + player.hitFlashTime > love.timer.getTime() and self.lastHit < love.timer.getTime()) then
        love.graphics.setColor({1, 0.5, 0.5})
    else
        love.graphics.setColor({1, 1, 1})
    end

    --love.graphics.draw(self.image, self.position.x + self.velocity.x / self.maxSpeed * 20, self.position.y,
    --    0, (1.0 - math.abs(self.velocity.x) / self.maxSpeed * 0.15), 1, self.size.x / 2, self.size.y / 2)
    love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1, 1, self.size.x / 2, self.size.y / 2)
end

return player
