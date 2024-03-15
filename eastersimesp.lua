eggBlocks = {}

module_manager.register("EggESP", {
    on_enable = function()
        client.print("Loaded Easter Simulator ESP Made by nismo1337")
        eggBlocks = findeggBlocks()
    end,
    on_render_screen = function(e)
        for _,v in pairs(eggBlocks) do
            x = v["x"]
            y = v["y"]
            z = v["z"]
            if world.block(x,y,z) == "tile.skull" then
                minX, minY, minZ, maxX, maxY, maxZ = getBlockBoundingBox(x,y,z)
                renderOutline(minX, minY, minZ, maxX, maxY, maxZ, e)
            end
        end
    end
})

function renderOutline(minX, minY, minZ, maxX, maxY, maxZ, sc)
    px, py, pz = player.camera_position()
    dMinX = minX-px
    dMinY = minY-py
    dMinZ = minZ-pz
    dMaxX = maxX-px
    dMaxY = maxY-py
    dMaxZ = maxZ-pz
    
    x1, y1, z1 = render.world_to_screen(dMaxX,dMinY,dMinZ)
    x2, y2, z2 = render.world_to_screen(dMaxX,dMaxY,dMinZ)
    x3, y3, z3 = render.world_to_screen(dMinX,dMinY,dMaxZ)
    x4, y4, z4 = render.world_to_screen(dMinX,dMaxY,dMaxZ)
    x5, y5, z5 = render.world_to_screen(dMinX,dMinY,dMinZ)
    x6, y6, z6 = render.world_to_screen(dMinX,dMaxY,dMinZ)
    x7, y7, z7 = render.world_to_screen(dMaxX,dMinY,dMaxZ)
    x8, y8, z8 = render.world_to_screen(dMaxX,dMaxY,dMaxZ)
    
    render.scale(1/sc.scale_factor)
    
    distance = math.sqrt(dMinX ^ 2 + dMinY ^ 2 + dMinZ ^ 2)
    if distance <= 15 then
        red = 0
        green = 255
        blue = 0
    elseif distance > 15 and distance <= 20 then
        local proportion = (distance - 15) / (20 - 15) 
        red = 255 * (1 - proportion) + 255 * proportion
        green = 255 * (1 - proportion) + 165 * proportion
        blue = 0
    else
        red = 255
        green = 0
        blue = 0
    end
    
    lineWidth = 2
    if z1<1 and z2<1 and z3<1 and z4<1 and z5<1 and z6<1 and z7<1 and z8<1 then
        render.line(x1,y1,x2,y2,lineWidth,red,green,blue,255)
        render.line(x3,y3,x4,y4,lineWidth,red,green,blue,255)
        render.line(x5,y5,x6,y6,lineWidth,red,green,blue,255)
        render.line(x7,y7,x8,y8,lineWidth,red,green,blue,255)
        render.line(x1,y1,x5,y5,lineWidth,red,green,blue,255)
        render.line(x2,y2,x6,y6,lineWidth,red,green,blue,255)
        render.line(x3,y3,x7,y7,lineWidth,red,green,blue,255)
        render.line(x4,y4,x8,y8,lineWidth,red,green,blue,255)
        render.line(x5,y5,x3,y3,lineWidth,red,green,blue,255)
        render.line(x6,y6,x4,y4,lineWidth,red,green,blue,255)
        render.line(x7,y7,x1,y1,lineWidth,red,green,blue,255)
        render.line(x8,y8,x2,y2,lineWidth,red,green,blue,255)
    end
    
    render.scale(sc.scale_factor)
end

function findeggBlocks()
    local height = 10 
    local startX,startY,startZ = player.position()
    local radius = 150
    startX = 0
    startY = 80
    startZ = 0
    eggBlocks = {}
    for x = startX-radius, radius+startX, 1 do
        for y = startY-height, height+startY, 1 do
            for z = startZ-radius, radius+startZ, 1 do
                currentBlock = world.block(x, y, z)
                if currentBlock == "tile.skull" then
                    egg = {}
                    egg["x"] = math.floor(x)
                    egg["y"] = math.floor(y)
                    egg["z"] = math.floor(z)
                    table.insert(eggBlocks, egg)
                end
            end
        end
    end
    return eggBlocks
end

function getBlockBoundingBox(posX, posY, posZ)
    eggHeight = 1 
    maxY = posY + eggHeight
    minY = posY
    maxX = posX + 1
    maxZ = posZ + 1
    minX = posX
    minZ = posZ
    return minX, minY, minZ, maxX, maxY, maxZ
end
