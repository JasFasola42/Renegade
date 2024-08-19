local isReloading = false

function shootMissiles()
    local thePilot = getLocalPlayer()
    local theVehicle = getPedOccupiedVehicle(thePilot)
    if theVehicle then
        local theVehicleModel = getElementModel(theVehicle)
        if theVehicleModel == 476 then
            if isReloading then
                outputChatBox("Reloading missiles, please wait...", 255, 0, 0)
                return
            end

            isReloading = true
            local positions = {
                {-2.4, 3.5, -1}, {2.4, 3.5, -1},
                {-2.4, 2, -1}, {2.4, 2, -1},
                {-2.4, 1, -1}, {2.4, 1, -1},
                {-2.4, 0, -1}, {2.4, 0, -1},
            }

            local vx, vy, vz = getElementVelocity(theVehicle)
            local speed = math.sqrt(vx^2 + vy^2 + vz^2)
            local rocketSpeed = 0.5 * speed
           
            for i = 1, 4 do
                setTimer(function()
                    local x1, y1, z1 = getPositionFromElementOffset(theVehicle, unpack(positions[(i - 1) * 2 + 1]))
                    local x2, y2, z2 = getPositionFromElementOffset(theVehicle, unpack(positions[(i - 1) * 2 + 2]))
                    createProjectile(theVehicle, 19, x1, y1, z1, rocketSpeed)  
                    createProjectile(theVehicle, 19, x2, y2, z2, rocketSpeed)
                end, (i - 1) * 250, 1)
            end

            setTimer(function()
                isReloading = false
            end, 15000, 1)
        end
    end
end

bindKey("lctrl", "down", shootMissiles)

function getPositionFromElementOffset(element, offX, offY, offZ)
    local m = getElementMatrix(element)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end