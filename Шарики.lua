local aims = {}
function ClassAim()
    local w = 90
    local aim = {
        x = love.math.random(0, WIDTH - w),
        y = 0,
        speed = 40,
        width = w,
        height = 50,
        shootDesroy = false
    }
    return aim

end

function Collides(rect, point)
    local lx = rect.x
    local rx = rect.x + rect.width
    local ty = rect.y
    local by = rect.y + rect.height
    return point.x >= lx and
        point.y <= rx and
        point.y >= ty and
        point.y <= by

end

local HEIGHT = 0
function love.load()
    HEIGHT = love.graphics.getHeight()
    WIDTH = love.graphics.getWidth()
end

local timer = 0
local cooldown = 1
timers = 0

--table.insert(aims, ClassAim())
--table.insert(aims, ClassAim())
function AimUpdate(self, dt)
    self.y = self.y + self.speed * dt

    if love.mouse.isDown(1) then

        local mx = love.mouse.getX()
        local my = love.mouse.getY()
        if timers > 1 then
            if Collides(self, { x = mx, y = my }) then
                self.shootDestroy = true
                timers = 0
            end
        end




    end


    if self.y > HEIGHT then
        self.shootDestroy = true
    end
end

function AimDraw(self)
    love.graphics.rectangle('fill', self.x, self.y, self.height, self.width)

end

function love.update(dt)
    timer = timer - dt
    timers = timers + dt
    if timer <= 0 then
        timer = cooldown
        table.insert(aims, ClassAim())
    end





    for i, a in ipairs(aims) do
        AimUpdate(a, dt)






        if a.shootDestroy then

            table.remove(aims, i)
        end
    end
end

function love.draw()
    love.graphics.print(timers, 20, 30)
    for _, a in ipairs(aims) do
        AimDraw(a)
    end

end
