-- Dynamis Buburimu Mob Information and Mechanics
-----------------------------------
xi = xi or {}
xi.dynamis = xi.dynamis or {}

-- -----------------
-- Apoc Beast Code
-- -----------------
local paths =
{
    {
        -- West Side
        -- It must start at the top
        -- Go to the end
        -- Reverse back to the start
        { x = -227, y = -21, z = 99  }, -- Starting point
        { x = -236, y = -21, z = 100 },
        { x = -254, y = -21, z = 99  },
        { x = -272, y = -21, z = 100 },
        { x = -285, y = -21, z = 98  },
        { x = -295, y = -21, z = 93  },
        { x = -299, y = -21, z = 80  },
        { x = -300, y = -20, z = 55  },
        { x = -300, y = -21, z = 35  },
        { x = -310, y = -21, z = 22  },
        { x = -336, y = -21, z = 21  },
        { x = -361, y = -22, z = 17  },
        { x = -378, y = -25, z = 18  },
        { x = -397, y = -29, z = 20  },
        { x = -433, y = -29, z = 20  },
        { x = -449, y = -29, z = 22  },
        { x = -458, y = -30, z = 31  },
        { x = -461, y = -30, z = 46  },
        { x = -470, y = -29, z = 57  },
        { x = -493, y = -29, z = 58  },
        { x = -513, y = -30, z = 61  },
        { x = -536, y = -31, z = 75  }, -- End point
    },
    {
        -- East to crossroads 1
        -- If it hits crossraods 1
        -- It can either go south or east to crossroads 2
        { x = -227, y = -21, z = 99  }, -- Starting point
        { x = -210, y = -21, z = 99  },
        { x = -188, y = -21, z = 100 },
        { x = -163, y = -21, z = 100 },
        { x = -149, y = -21, z = 96  },
        { x = -141, y = -22, z = 88  },
        { x = -138, y = -22, z = 72  },
        { x = -130, y = -21, z = 64  },
        { x = -115, y = -21, z = 60  },
        { x = -101, y = -18, z = 57  },
        { x =  -82, y = -13, z = 59  },
        { x =  -64, y = -12, z = 59  },
        { x =  -51, y = -13, z = 61  },
        { x =  -32, y = -13, z = 60  },
        { x =  -23, y = -13, z = 58  }, -- Crossroads 1
    },
    {
        -- South of crossroads 1
        -- It must hit the end and come back
        { x = -23, y = -13, z = 58  }, -- Crossroads 1
        { x = -20, y = -13, z = 43  },
        { x = -20, y = -14, z = 32  },
        { x = -18, y = -12, z = 16  },
        { x = -20, y = -13, z = -4  },
        { x = -23, y =  -9, z = -20  },
        { x = -19, y =  -6, z = -47  },
        { x = -11, y =  -5, z = -57  },
        { x =   1, y =  -6, z = -60  },
        { x =  12, y =  -5, z = -64  },
        { x =  19, y =  -6, z = -72  },
        { x =  21, y =  -6, z = -87  },
        { x =  27, y =  -5, z = -95  },
        { x =  39, y =  -6, z = -100  },
        { x =  51, y =  -4, z = -100  },
        { x =  64, y =  -1, z = -102  },
        { x =  77, y =   2, z = -101  },
        { x =  97, y =   3, z = -101  },
        { x = 123, y =   2, z = -100  }, -- End near entrance
    },
    {
        -- East of Crossroads 1 to Crossroads 2
        -- It can either go north or south from here
        { x = -23, y = -13, z = 58  }, -- Crossroads 1
        { x =  -3, y = -14, z = 60  },
        { x =  15, y = -13, z = 59  },
        { x =  24, y = -13, z = 62  },
        { x =  43, y = -14, z = 60  },
        { x =  58, y = -10, z = 58  },
        { x =  74, y =  -6, z = 59  },
        { x =  87, y =  -6, z = 59  },
        { x =  95, y =  -6, z = 52  },
        { x =  98, y =  -6, z = 43  },
        { x = 101, y =  -6, z = 32  },
        { x = 107, y =  -5, z = 25  },
        { x = 116, y =  -6, z = 21  },
        { x = 127, y =  -6, z = 20  },
        { x = 138, y =  -5, z = 19  },
        { x = 150, y =  -5, z = 21  },
        { x = 163, y =  -6, z = 19  },
        { x = 175, y =  -5, z = 19  },
        { x = 185, y =  -5, z = 21  },
        { x = 197, y =  -6, z = 20  },
        { x = 210, y =  -6, z = 21  },
        { x = 217, y =  -5, z = 20  },
        { x = 231, y =  -6, z = 19  },
        { x = 243, y =  -6, z = 20  },
        { x = 256, y =  -3, z = 22  },
        { x = 268, y =   1, z = 22  },
        { x = 281, y =   2, z = 20  },
        { x = 297, y =   3, z = 17  }, -- Crossroads 2
    },
    {
        -- Crossraods 2 -> North
        -- It must return back to crossroads 2
        -- It can either go back west or go south
        { x = 297, y = 3, z = 17 }, -- Crossroads 2
        { x = 299, y = 2, z = 29 },
        { x = 301, y = 2, z = 46 },
        { x = 302, y = 3, z = 54 },
        { x = 299, y = 3, z = 65 },
        { x = 300, y = 2, z = 80 },
        { x = 302, y = 2, z = 100 }, -- End
    },
    {
        -- Crossroads 2 -> South
        -- It must go to the end and reverse back to crossroads 2
        { x = 297, y = 3, z = 17 }, -- Crossroads 2
        { x = 301, y = 2, z = 10 },
        { x = 300, y = 2, z = 2 },
        { x = 298, y = 3, z = -12 },
        { x = 302, y = 3, z = -25 },
        { x = 300, y = 2, z = -38 },
        { x = 303, y = 2, z = -51 },
        { x = 310, y = 3, z = -57 },
        { x = 320, y = 2, z = -59 },
        { x = 336, y = 3, z = -59 },
        { x = 345, y = 3, z = -62 },
        { x = 357, y = 2, z = -60 },
        { x = 366, y = 2, z = -61 },
        { x = 374, y = 3, z = -67 },
        { x = 378, y = 2, z = -72 },
        { x = 380, y = 2, z = -79 },
        { x = 379, y = 3, z = -90 },
        { x = 380, y = 3, z = -98 },
        { x = 382, y = 3, z = -104 },
        { x = 380, y = 2, z = -114 },
        { x = 381, y = 2, z = -126 },
        { x = 381, y = 3, z = -134 },
        { x = 378, y = 3, z = -145 },
        { x = 380, y = 2, z = -157 },
        { x = 379, y = 2, z = -167 },
        { x = 380, y = 3, z = -177 },
        { x = 381, y = 2, z = -192 },
        { x = 380, y = 2, z = -200 },
        { x = 382, y = 2, z = -208 },
        { x = 386, y = 3, z = -214 },
        { x = 392, y = 2, z = -218 },
        { x = 397, y = 2, z = -219 },
        { x = 408, y = 2, z = -221 },
        { x = 423, y = 3, z = -219 },
        { x = 434, y = 2, z = -220 },
        { x = 445, y = 2, z = -221 },
        { x = 456, y = 3, z = -221 },
        { x = 466, y = 2, z = -219 },
        { x = 487, y = 2, z = -222 },
        { x = 497, y = 3, z = -228 },
        { x = 499, y = 2, z = -235 },
        { x = 501, y = 2, z = -246 },
        { x = 505, y = 3, z = -253 },
        { x = 511, y = 3, z = -258 },
        { x = 517, y = 2, z = -259 },
        { x = 528, y = 2, z = -260 },
        { x = 538, y = 2, z = -262 }, -- End
    }
}

local reverseFlag = bit.bor(xi.path.flag.COORDS, xi.path.flag.REVERSE)
local forwardFlag = xi.path.flag.COORDS

local function checkPathDistance(mob, point)
    return mob:checkDistance(unpack(point))
end

local function isNearPoint(mob, point)
    return checkPathDistance(mob, point) < 5
end

local function pathThrough(mob, pathIndex, reverse)
    local flags = reverse and reverseFlag or forwardFlag
    mob:pathThrough(paths[pathIndex], flags)
end

local function setNextPath(mob)
    local path1First = xi.path.first(paths[1])
    local path1Last  = xi.path.last(paths[1])
    local path2Last  = xi.path.last(paths[2])
    local path3Last  = xi.path.last(paths[3])
    local path4Last  = xi.path.last(paths[4])
    local path5Last  = xi.path.last(paths[5])
    local path6Last  = xi.path.last(paths[6])

    -- If it hits the end of path 1, needs to path back
    if isNearPoint(mob, path1Last) then
        pathThrough(mob, 1, true)
    -- If it hits the end of path 2 or the end of path 1
    -- Pick 1 or 2
    elseif isNearPoint(mob, path1First) then
        local pathToUse = math.random(1, 2)
        pathThrough(mob, pathToUse, false)
    -- If it hits the end of path 2, pick path 2 or 3
    elseif isNearPoint(mob, path2Last) then
        local pathToUse = math.random(2, 4)
        pathThrough(mob, pathToUse, pathToUse == 2)
    -- If it hits the end of path 3, it must reverse back on path 3
    elseif isNearPoint(mob, path3Last) then
        pathThrough(mob, 3, true)
    -- If it hits the end of path 4, it can pick path 4, 5, or 6
    elseif isNearPoint(mob, path4Last) then
        local pathToUse = math.random(4, 6)
        pathThrough(mob, pathToUse, pathToUse == 4)
    -- If it hits the end of path 5, it must reverse back on path 5
    elseif isNearPoint(mob, path5Last) then
        pathThrough(mob, 5, true)
    -- If it hits the end of path 6, it must reverse back on path 6
    elseif isNearPoint(mob, path6Last) then
        pathThrough(mob, 6, true)
    end

    -- If it deaggros we need to find a path
    if not mob:isFollowingPath() then
        local mobPos = mob:getPos()
        if mobPos.x < -240 then
            pathThrough(mob, 1, false)
        elseif mobPos.x < -120 then
            pathThrough(mob, 2, false)
        elseif mobPos.x < 20 then
            pathThrough(mob, 2, true)
        elseif mobPos.x < 150 then
            pathThrough(mob, 4, false)
        else
            pathThrough(mob, 1, false)
        end
    end
end

xi.dynamis.apocBeastSpawn = function(mob)
    mob:addImmunity(xi.immunity.GRAVITY)
    local pickPath = math.random(1, 2)
    mob:pathThrough(paths[pickPath], xi.path.flag.COORDS)
    mob:setPos(-227, -21, 99) -- Just in case
    mob:setLocalVar('currentPath', 1) -- Skip regular roam code
end

xi.dynamis.apocBeastRoam = function(mob)
    if not mob:isFollowingPath() then
        setNextPath(mob)
    end
end
