local abstract = {}

abstract = {}

abstract.image = nil
abstract.team = nil
abstract.damage = 0
abstract.position = {x = 0, y = 0}
abstract.speed = {x = 0, y = 0}
abstract.size = {x = 0, y = 0}
abstract.collisionRadius = nil
abstract.collisionRadiusFactor = 1

function abstract.init(self)
    -- size
    self.size = {x = self.image:getWidth(), y = self.image:getHeight()}
    self.radius = (self.size.x > self.size.y) and self.size.x or self.size.y

    self.collisionCenter = {x = self.position.x + self.size.x / 2, y = self.position.y + self.size.y / 2}

    self.collisionRadius = self.radius * self.collisionRadiusFactor
end

function abstract.move(self, dt)
    self.position.x = self.position.x + self.speed.x * dt
    self.position.y = self.position.y + self.speed.y * dt * (self.team == 'friendly' and -1 or 1)
end

function abstract.draw(self)
    love.graphics.setColor({255, 255, 255})
    love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1, 1, self.size.x / 2, self.size.y / 2)
end

return abstract
