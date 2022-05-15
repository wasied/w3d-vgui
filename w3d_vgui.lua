-- This library has been created by Wasied on may2022
-- You are allowed to use it anywhere but you must credit the author (Wasied)
-- I do not provide any support to this library. You can still try opening an issue on GitHub to get help.
-- Have fun, Wasied.

w3d = {}
w3d.tCache = w3d.tCache or { tButtons = {} }

--[[-------------------------------------------------]]--
--[[                   LOCAL CACHE                   ]]--
--[[     As we need to optimize the best we can,     ]]--
--[[   I'm trying to CPU-optimize everything I can   ]]--
--[[-------------------------------------------------]]--

local tVGUIList = {}
local pLocal

--[[-----------------]]--
--[[ LOCAL FUNCTIONS ]]--
--[[-----------------]]--

-- Clear buttons from the cache when they are not existing anymore
local function ClearButtonsCache()

    for sId, tInfos in pairs(w3d.tCache.tButtons or {}) do
        if SysTime() - RealFrameTime() > tInfos.iLastTime then
            w3d.tCache.tButtons[sId] = nil
        end
    end

end

--[[------------------]]--
--[[ PUBLIC FUNCTIONS ]]--
--[[------------------]]--

-- Start 3D2D context
function w3d.Start3D2D(vecTarget, angTarget, iScale)

    if not IsValid(pLocal) then
        pLocal = LocalPlayer()
    end

    cam.Start3D2D(vecTarget, angTarget, iScale)

    local tTrace = pLocal:GetEyeTrace()
    local vecHitPos = util.IntersectRayWithPlane(tTrace.StartPos, tTrace.Normal, vecTarget, angTarget:Up())

    if vecHitPos then
        local vecDelta = vecTarget - vecHitPos

        w3d.tCache.iMouseX = vecDelta:Dot(-angTarget:Forward()) / iScale
        w3d.tCache.iMouseY = vecDelta:Dot(-angTarget:Right()) / iScale
    end

    return true

end

-- End 3D2D context
function w3d.End3D2D()

    cam.End3D2D()
    return true

end

-- Get the mouse position relative to the screen
function w3d.GetMousePos()
    return w3d.tCache.iMouseX or 0, w3d.tCache.iMouseY or 0
end

-- Check if the mouse is hovering something on the screen
function w3d.IsHovered(x, y, w, h)
    local iMouseX, iMouseY = w3d.GetMousePos()
    return iMouseX >= x and iMouseX <= x + w and iMouseY >= y and iMouseY <= y + h
end

-- Create a new vgui element
function w3d.Create(sType, sId, x, y, w, h, fcCallback, fcPaint)

    if not isfunction(tVGUIList[sType]) then return false, "Invalid vgui type (#1)" end
    if not isstring(sId) then return false, "Invalid unique identifier (#2)" end

    tVGUIList[sType](sId, x, y, w, h, fcCallback, fcPaint)

end


--[[-----------]]--
--[[ OUR HOOKS ]]--
--[[-----------]]--

-- Called when the player press the primary attack button
hook.Add("KeyPress", "w3d:KeyPress", function(pPlayer, iKey)

    if not IsFirstTimePredicted() then return end
    if not IsValid(pPlayer) or not pPlayer:IsPlayer() then return end
    if iKey ~= IN_ATTACK and iKey ~= IN_USE then return end

    ClearButtonsCache()

    for sId, tInfos in pairs(w3d.tCache.tButtons or {}) do

        if w3d.IsHovered(tInfos.x, tInfos.y, tInfos.w, tInfos.h) then
            tInfos.fcCallback(sId)
            hook.Run("w3d:ButtonPressed", sId)
            break
        end

    end

end)

--[[----------------------------------------------------]]--
--[[             CUSTOM 3D2D VGUI ELEMENTS              ]]--
--[[  In order to make the usage easy, I created some   ]]--
--[[  predefined elements that you can easily create.   ]]--
--[[----------------------------------------------------]]--

-- Button creation callback
local function CreateButton(sId, x, y, w, h, fcCallback, fcPaint)

    local bHovered = w3d.IsHovered(x, y, w, h)

    -- Paint the button (custom or by default)
    if isfunction(fcPaint) then
        fcPaint(x, y, w, h, bHovered)
    else
        
        surface.SetDrawColor(bHovered and Color(87, 75, 144, 220) or Color(48, 57, 82, 200))
        surface.DrawRect(x, y, w, h)

        draw.SimpleText("Wasied", "Trebuchet24", x + w / 2, y + h / 2, color_white, 1, 1)

    end

    -- Make a default callback just to show it works
    if not isfunction(fcCallback) then
        fcCallback = function()
            chat.AddText(Color(0, 110, 255), "Such a great developer! This is the default callback function")
        end
    end

    -- Register the button in order to make it clickable
    w3d.tCache.tButtons[sId] = { x = x, y = y, w = w, h = h, fcCallback = fcCallback, iLastTime = SysTime() }

end
tVGUIList["DButton"] = CreateButton