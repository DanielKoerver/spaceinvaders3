local asteroid = {}

asteroid.imageAmount = 4

asteroid.speedRange = {y = {min = 150, max = 220}}
asteroid.rotationSpeed = 0
asteroid.rotationSpeedRange = {min = -0.4, max = 0.4}

asteroid.radiusRange = {min = 50, max = 80}
asteroid.collisionRadiusFactor = 0.8

asteroid.collisionDamage = 30
asteroid.health = nil

function asteroid.typeInit(self)
    -- random radius
    self.radius = love.math.random(self.radiusRange.min, self.radiusRange.max)
    self.collisionRadius = self.radius * self.collisionRadiusFactor

    -- random speed and rotation
    self.speed = {x = 0, y = love.math.random(self.speedRange.y.min, self.speedRange.y.max)}
    self.rotationSpeed = self.rotationSpeedRange.min + love.math.random() * (self.rotationSpeedRange.max - self.rotationSpeedRange.min)
end

function asteroid:collideWithPlayer(player)
    self.speed.x = 80 * (player.position.x >= self.position.x and -1 or 1)
    self:die(player)
end

function asteroid:draw()
    local image = self.images[self.imageIndex]
    local rotation = (self.rotationSpeed ~= nil and self.rotationSpeed * love.timer.getTime() or 0)

    -- flash on hit
    if (self.lastHit + self.hitFlashTime > love.timer.getTime() and self.lastHit < love.timer.getTime()) then
        love.graphics.setColor({1, 0.5, 0.5})
    else
        love.graphics.setColor({1, 1, 1})
    end

    love.graphics.draw(image, self.position.x, self.position.y, rotation, self.radius * 2 / self.size.x, self.radius * 2 / self.size.y, self.size.x / 2, self.size.y / 2)
end

return asteroid
