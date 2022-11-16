local scale = 2
love.graphics.setDefaultFilter('nearest', 'nearest')
local tiles = love.graphics.newImage('tiles.png')
local playerAnimation = {}
local castle = {
  x = 366,
  y = 266,
  width = 64,
  height = 64,
}

local cooldown = 5
local timer = 5
mobs = {}
local n = 10
---local lines = {}
--function myprint(text)
 -- table.insert(lines, text)
--end
--function drawConsole()
  --nLines = 3
  --for i = #lines, #lines - nLines, -1 do
    --j = #lines - i
    --if lines[i] then
      --love.graphics.print(lines[i], 10, 10 + j * 12 )
    --end
  --end
--end


function mobCreate()
  mob = {
    x = love.math.random(0,800),
    y = love.math.random(0,600),
    speed = 100,
    width = 15,
    height = 20,
    shootDestroy = false,
  }
  local lx = castle.x -40
  local rx = castle.x + castle.width + 20
  local ty = castle.y - 40
  local by = castle.y + castle.height +20
  while mob.x > lx and mob.x < rx and mob.y > ty and mob.y < by do
    mob.x = love.math.random(0,800)
    mob.y = love.math.random(0,600)
  end
  return mob

end

---Доп функции
function Length(vec)
  local v = vec.x * vec.x + vec.y * vec.y
  return math.sqrt(v)
end

function Normalize(vec)
  local l = Length(vec)
  if l == 0 then
      return vec
  end
  return {
      x = vec.x / l,
      y = vec.y / l,
  }
end

function Scale(vec, s)
  return {
      x = vec.x * s,
      y = vec.y * s
  }
end
----

---ООП
function MouseDirection(self,castle)
  local mx, my = castle.x,castle.y
  local dir = {
      x = mx - self.x,
      y = my - self.y
  }
  return Normalize(dir)
end

function Collides(mob,castle)
  local lx = castle.x -40
  local rx = castle.x + castle.width + 20
  local ty = castle.y - 40
  local by = castle.y + castle.height +20
  return mob.x > lx and
      mob.x < rx and
      mob.y > ty and
      mob.y < by
end

function Collides_kills(mob,point)
  local lx = mob.x
    local rx = mob.x + mob.width
    local ty = mob.y
    local by = mob.y + mob.height
    return point.x >= lx and
        point.y <= rx and
        point.y >= ty and
        point.y <= by
end



function AimUpdate(self, dt)
  local dir = MouseDirection(self,castle)
  local vel = Scale(dir, self.speed)
  self.x = self.x + vel.x * dt
  self.y = self.y + vel.y * dt
  if Collides(self,castle) then
    self.speed = 0
    ---myprint(""..self.x.." "..self.y)
  end
  if love.mouse.isDown(1) then
    local mx = love.mouse.getX()
    local my = love.mouse.getY()
    if Collides_kills(self, { x = mx, y = my }) then
          self.shootDestroy = true
    end
  end
end

function love.update(dt)
  AnimationUpdate(playerAnimation.idle, dt)
  timer = timer - dt
  if timer <= 0 then
    timer =  cooldown
    if #mobs == 0 then
      for i=1,n do
        table.insert(mobs, mobCreate())
      end
      n = n +10
    end
  end

  for i, a in ipairs(mobs) do
    AimUpdate(a, dt)
    if a.shootDestroy then
      table.remove(mobs, i)
    end
  end
end
----

---АНИМАЦИЯ
function AnimationFrame(self)
  return self.frames[self.frameIdx]
end
function NewPlayerIdleQuads()
  local animation = {
    animSpeed = 0.2,
    timer = 0,
    frameIdx = 1,
    frames = {},
  }
  for i = 0, 3 do
    local quad = love.graphics.newQuad(
      432 + i * 16, 110,
      15,
      20,
      tiles:getWidth(), tiles:getWidth()
    )
    table.insert(animation.frames, quad)
  end
  return animation
end

function love.load()
  playerAnimation.idle = NewPlayerIdleQuads()
end

function AnimationUpdate(self, dt) 
  local n = #self.frames
  self.timer = self.timer + dt
  if self.timer >= self.animSpeed then
    self.timer = self.timer - self.animSpeed
    self.frameIdx = self.frameIdx % n + 1
  end
end
----
function love.draw()
  local frame = AnimationFrame(playerAnimation.idle)
  love.graphics.rectangle('fill',castle.x,castle.y,castle.width,castle.height)
   for _, a in ipairs(mobs) do
    love.graphics.draw(tiles, frame, a.x - 8, a.y-10, 0, scale, scale)
   end

   --drawConsole()
end



