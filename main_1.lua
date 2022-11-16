local player = {
    x = 300,
    y = 300,
    speed = 1000,
}

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')
    titles = love.graphics.newImage('titles.png')
end

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

function HandleKeyboard()
    local dir = { x = 0, y = 0 }
    if love.keyboard.isDown('w') then
        dir.y = -1
    end
    if love.keyboard.isDown('s') then
        dir.y = 1
    end
    if love.keyboard.isDown('a') then
        dir.x = -1
    end
    if love.keyboard.isDown('d') then
        dir.x = 1
    end

    return Normalize(dir)
end

function MouseDirection()
    local mx, my = love.mouse.getPosition()
    local dir = {
        x =mx - player.x,
        y=my - player.y
    }
end

function love.update(dt)
    local dir = HandleKeyboard()
    local vel = Scale(dir, player.speed)
    player.x = player.x + vel.x * dt
    player.y = player.y + vel.y * dt
    if player.x < -50 then
        player.x= 850
    end
    if player.x> 850 then
        player.x = -50
    end
    if player.y< -50 then
        player.y= 650
    end 
    if player.y>650 then
        player.y=-50
    end
end

function love.draw()
    local quad = love.graphics.newQuad(16 * 8,2 * 8,16,16,512,512)
    love.graphics.draw(titles,quad, player.x,player.y ,0,4 )
end
