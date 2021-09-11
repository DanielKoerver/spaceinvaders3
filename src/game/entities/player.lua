local player = {}

player.image = nil

player.size = {x = 0, y = 0}
player.position = {x = 0, y = 0}

player.velocity = {x = 0, y = 0}
player.minimalVelocity = 10
player.acceleration = 1800
player.maxSpeed = 800
player.decellerationFactor = 6
player.frictionFactor = 3

function player:init()
    self.image = love.graphics.newImage('assets/images/player.png')
    self.size = {x = self.image:getWidth(), y = self.image:getHeight()}
    self.position = {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() - self.size.y / 2 - 30}
end

function player:update(dt)
    self:move(dt)
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

function player:draw()
    --love.graphics.draw(self.image, self.position.x + self.velocity.x / self.maxSpeed * 20, self.position.y,
    --    0, (1.0 - math.abs(self.velocity.x) / self.maxSpeed * 0.15), 1, self.size.x / 2, self.size.y / 2)
    love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1, 1, self.size.x / 2, self.size.y / 2)
end

return player
