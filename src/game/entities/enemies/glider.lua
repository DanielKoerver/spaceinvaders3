local glider = {}

glider.direction = 1
glider.health = 30
glider.score = 20

glider.shootfrequency = 1
glider.projectileType = 'hostileShot'

function glider:typeInit()
    self.speed = {x = 200, y = 100}
    self.lastShot = love.timer.getTime()
end

function glider:move(player, dt)
    -- fly down at the beginning
    if self.position.y >= self.size.y / 2 + 40 then
        self.speed.y = 0
    end

    -- toggle left and right
    if self.position.x + self.size.x / 2 + 10 >= love.graphics.getWidth() then
        self.direction = -1
    end
    if self.position.x - self.size.x / 2 - 10 <= 0 then
        self.direction = 1
    end

    self.position.x = self.position.x + self.speed.x * self.direction * dt
    self.position.y = self.position.y + self.speed.y * dt
end

return glider
