local scale = 2
love.graphics.setDefaultFilter('nearest', 'nearest')
local tiles = love.graphics.newImage('Utyug.png')

local cstl = love.graphics.newImage('Castle.png')
local bg = love.graphics.newImage('Background.png')

local ButtonIron = love.graphics.newImage('Button_Iron.png')
local ButtonTree = love.graphics.newImage('Button_Tree.png')
local ButtonTower = love.graphics.newImage('Button_Tower.png')
local ButtonStone = love.graphics.newImage('Button_Stone.png')
local ButtonDot = love.graphics.newImage('Button_Dot.png')

local BuildStone = love.graphics.newImage('Build_Stone.png')
local BuildTree = love.graphics.newImage('Build_Tree.png')
local BuildIron = love.graphics.newImage('Build_Iron.png')
local Dot = love.graphics.newImage('Dot.png')
local Towers = love.graphics.newImage('Tower.png')

local Viewport = {
    x = 0,
    y = 0,
    width = 800,
    height = 600
}

local playerAnimation = {}
local castle = {
    x = 400 - 32,
    y = 300 - 32,
    width = 64,
    height = 64,
}

local cooldown = 5
local timer = 5
mobs = {}
local n = 10

function mobCreate()
    mob = {
        x = love.math.random(0, 800),
        y = love.math.random(0, 600),
        speed = 100,
        width = 15,
        height = 20,
        shootDestroy = false,
    }
    local lx = castle.x - 40
    local rx = castle.x + castle.width + 20
    local ty = castle.y - 40
    local by = castle.y + castle.height + 20
    while mob.x > lx and mob.x < rx and mob.y > ty and mob.y < by do
        mob.x = love.math.random(0, 800)
        mob.y = love.math.random(0, 600)
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

---ООП
function MouseDirection(self, castle)
    local mx, my = castle.x, castle.y
    local dir = {
        x = mx - self.x,
        y = my - self.y
    }
    return Normalize(dir)
end

function Collides(mob, castle)
    local lx = castle.x - 40
    local rx = castle.x + castle.width + 20
    local ty = castle.y - 40
    local by = castle.y + castle.height + 20
    return mob.x > lx and
        mob.x < rx and
        mob.y > ty and
        mob.y < by
end

function Collides_kills(mob, point)
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

    local dir = MouseDirection(self, castle)
    local vel = Scale(dir, self.speed)
    self.x = self.x + vel.x * dt
    self.y = self.y + vel.y * dt
    if Collides(self, castle) then
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
    for i = 0, 1 do
        local quad = love.graphics.newQuad(
            32 + i * 16, 32,
            32,
            32,
            tiles:getWidth(), tiles:getHeight()
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

local Tower_build = false
local timer_tower = 0
local towers = {}

local dots = {}
local dot_build = false
local timer_dot = 0

local miners = {}
local miner_build = false
local timer_miner = 0

local rock_axers = {}
local rock_axer_build = false
local timer_rock_axer = 0

local trees = {}
local tree_build = false
local timer_tree = 0
--------------------------
function Class_Tower()
    local tower = {
        x = ms_x,
        y = ms_y
    }
    return tower
end

function Tower_checker()
    if Tower_check then
        if timer_tower < 10 then
            timer_tower = timer_tower + 1
        else
            timer_tower = 0
        end
        if love.mouse.isDown(1) and timer_tower == 10 then
            ms_x, ms_y = love.mouse.getPosition()
            if (748 < ms_x and ms_x < 780) and (30 < ms_y and ms_y < 62) then
                Tower_check = false
                timer_tower = 0
            else
                table.insert(towers, Class_Tower())
                Tower_check = false
                timer_tower = 0
            end
        end
    end
end

function Tower_Builder()
    if love.mouse.isDown(1) then
        local mouse_x, mouse_y = love.mouse.getPosition()
        if (748 < mouse_x and mouse_x < 780) and (30 < mouse_y and mouse_y < 62) then
            Tower_check = true
        end
    end

    Tower_checker()
end

function TowerDraw(self)
    love.graphics.draw(Towers, self.x, self.y)
end

--------------------------
function Class_Dot()
    local dot = {
        x = ms_x,
        y = ms_y
    }
    return dot
end

function Dot_checker()
    if dot_check then
        if timer_dot < 10 then
            timer_dot = timer_dot + 1
        else
            timer_dot = 0
        end
        if love.mouse.isDown(1) and timer_dot == 10 then
            ms_x, ms_y = love.mouse.getPosition()
            if (711 < ms_x and ms_x < 743) and (30 < ms_y and ms_y < 62) then
                dot_check = false
                timer_dot = 0
            else
                table.insert(dots, Class_Dot())
                dot_check = false
                timer_dot = 0
            end
        end
    end
end

function Dot_Builder()
    if love.mouse.isDown(1) then
        local mouse_x, mouse_y = love.mouse.getPosition()
        if (711 < mouse_x and mouse_x < 743) and (30 < mouse_y and mouse_y < 62) then
            dot_check = true
        end
    end

    Dot_checker()
end

function DotDraw(self)
    love.graphics.draw(Dot, self.x, self.y)
end

--------------------------
function Class_Miner()
    local miner = {
        x = ms_x,
        y = ms_y
    }
    return miner
end

function Miner_checker()
    if Miner_check then
        if timer_miner < 10 then
            timer_miner = timer_miner + 1
        else
            timer_miner = 0
        end
        if love.mouse.isDown(1) and timer_miner == 10 then
            ms_x, ms_y = love.mouse.getPosition()
            if (674 < ms_x and ms_x < 706) and (30 < ms_y and ms_y < 62) then
                Miner_check = false
                Miner_tower = 0
            else
                table.insert(miners, Class_Miner())
                Miner_check = false
                timer_miner = 0
            end
        end
    end
end

function Miner_Builder()
    if love.mouse.isDown(1) then
        local mouse_x, mouse_y = love.mouse.getPosition()
        if (674 < mouse_x and mouse_x < 706) and (30 < mouse_y and mouse_y < 62) then
            Miner_check = true
        end
    end

    Miner_checker()
end

function MinerDraw(self)
    love.graphics.draw(BuildIron, self.x, self.y)
end

--------------------------
function Class_Rock_Axer()
    local rock_axer = {
        x = ms_x,
        y = ms_y
    }
    return rock_axer
end

function Rock_Axer_checker()
    if rock_axer_check then
        if timer_rock_axer < 10 then
            timer_rock_axer = timer_rock_axer + 1
        else
            timer_rock_axer = 0
        end
        if love.mouse.isDown(1) and timer_rock_axer == 10 then
            ms_x, ms_y = love.mouse.getPosition()
            if (637 < ms_x and ms_x < 669) and (30 < ms_y and ms_y < 62) then
                rock_axer_check = false
                timer_rock_axer = 0
            else
                table.insert(rock_axers, Class_Rock_Axer())
                rock_axer_check = false
                timer_rock_axer = 0
            end
        end
    end
end

function Rock_Axer_Builder()
    if love.mouse.isDown(1) then
        local mouse_x, mouse_y = love.mouse.getPosition()
        if (637 < mouse_x and mouse_x < 669) and (30 < mouse_y and mouse_y < 62) then
            rock_axer_check = true
        end
    end

    Rock_Axer_checker()
end

function RockAxerDraw(self)
    love.graphics.draw(BuildStone, self.x, self.y)
end

--------------------------
function Class_Tree()
    local tree = {
        x = ms_x,
        y = ms_y
    }
    return tree
end

function Tree_checker()
    if tree_check then
        if timer_tree < 10 then
            timer_tree = timer_tree + 1
        else
            timer_tree = 0
        end
        if love.mouse.isDown(1) and timer_tree == 10 then
            ms_x, ms_y = love.mouse.getPosition()
            if (600 < ms_x and ms_x < 632) and (30 < ms_y and ms_y < 62) then
                tree_check = false
                timer_tree = 0
            else
                table.insert(trees, Class_Tree())
                tree_check = false
                timer_tree = 0
            end
        end
    end
end

function Tree_Builder()
    if love.mouse.isDown(1) then
        local mouse_x, mouse_y = love.mouse.getPosition()
        if (600 < mouse_x and mouse_x < 632) and (30 < mouse_y and mouse_y < 62) then
            tree_check = true
        end
    end

    Tree_checker()
end

function TreeDraw(self)
    love.graphics.draw(BuildTree, self.x, self.y)
end

--------------------------
function love.update(dt)
    AnimationUpdate(playerAnimation.idle, dt)
    timer = timer - dt
    if timer <= 0 then
        timer = cooldown
        if #mobs == 0 then
            for i = 1, n do
                table.insert(mobs, mobCreate())
            end
            n = n + 10
        end
    end

    for i, a in ipairs(mobs) do
        AimUpdate(a, dt)
        if a.shootDestroy then
            table.remove(mobs, i)
        end
    end
    Tower_Builder()
    Dot_Builder()
    Miner_Builder()
    Rock_Axer_Builder()
    Tree_Builder()
end

function love.draw()

    love.graphics.draw(ButtonTower, 748, 30)
    love.graphics.draw(ButtonDot, 711, 30)
    love.graphics.draw(ButtonIron, 674, 30)
    love.graphics.draw(ButtonStone, 637, 30)
    love.graphics.draw(ButtonTree, 600, 30)
    for _, a in ipairs(towers) do
        TowerDraw(a)
    end

    for _, b in ipairs(dots) do
        DotDraw(b)
    end

    for _, c in ipairs(miners) do
        MinerDraw(c)
    end

    for _, d in ipairs(rock_axers) do
        RockAxerDraw(d)
    end

    for _, e in ipairs(trees) do
        TreeDraw(e)
    end

    local frame = AnimationFrame(playerAnimation.idle)
    --love.graphics.setBackgroundColor(255,255,255)
    love.graphics.draw(cstl, castle.x, castle.y)
    --love.graphics.rectangle('fill',castle.x,castle.y,castle.width,castle.height)
    for _, f in ipairs(mobs) do
        love.graphics.draw(tiles, frame, f.x - 8, f.y - 10, 0, scale, scale)
    end

    for _, g in ipairs(Viewport) do
        love.graphics.draw(bg, Viewport.x, Viewport.y)
    end

end
