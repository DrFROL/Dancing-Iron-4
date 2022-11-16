local x = 0
local speed = 42
local y = 0
local flug = 0
function love.update(dt)
    x = x + speed * dt
    if (y < 500 and flug == 0) or (y == 10 and flug == 1)then 
        y = y + 10
        flug = 0
    else
        y = y - 10
        flug = 1
    end

end


function love.draw()

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill",x,20,50,y)
    love.graphics.print("sdf")
end