Wall = {}

function Wall:new(x, y) -- creates a new wall class and places it in an intial position
  local o = {}
  setmetatable(o, {__index = self})

  o.position = vector.new(x, y) -- places the position vector
  o.size = vector.new(32, 32) -- the actual size of the wall

	o.collider = HC.rectangle(o.position.x - o.size.x / 2, o.position.y - o.size.x / 2, o.size.x, o.size.y)
	o.collider.parent = o -- used so that colliders can find their parent object
	o.tag = "Wall"

  o.sprite = love.graphics.newImage("Spy Game Sprites/Block 1x1.png")
  o.sprite:setFilter("nearest", "nearest") -- really important line here; sets the filter used for scalaing to nearest instead of linear, which prevents blur

  return o
end

function Wall:draw()
	love.graphics.setColor(255, 255, 255)
  love.graphics.push()
  love.graphics.scale(2, 2)
  love.graphics.draw(self.sprite , (self.position.x - self.size.x / 2) / 2, (self.position.y - self.size.y / 2) / 2) -- Places the sprite.
  love.graphics.pop()
  love.graphics.setColor(255, 0, 0)
	self.collider:draw()
end
