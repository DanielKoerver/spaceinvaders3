local kamikaze = {}

kamikaze.direction = 1

kamikaze.collisionDamage = 50
kamikaze.health = 50

kamikaze.score = 40

function kamikaze:typeInit()
    self.speed = {x = 150, y = 250}
end

function kamikaze:move(player, dt)
    -- follow the player
    self.direction = (self.position.x > player.position.x and -1 or 1)
    if math.abs(self.position.x - player.position.x) >= 10 then
        self.position.x = self.position.x + self.speed.x * self.direction * dt
    end

    self.position.y = self.position.y + self.speed.y * dt
end

return kamikaze
