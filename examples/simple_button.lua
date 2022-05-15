-- This is a simple example with a defined position and angle.
-- Don't forget to load the actual file before doing this.
-- Feel free to PR some suggestions :)

local vecOrigin = Vector(428, 482, -12223)
local angOrigin = Angle(0, 90, 90)

hook.Add("PostDrawTranslucentRenderables", "test", function(bDepth, bSkybox)

    w3d.Start3D2D(vecOrigin, angOrigin, 0.1)

        w3d.Create("DButton", "SomeUniqueID", 0, 0, 300, 80, 
            function()
                chat.AddText(Color(255, 40, 40), "Hey! It's working!")
            end,
            function(w, h, bHovered)
                surface.SetDrawColor(bHovered and Color(107, 107, 107, 200) or Color(0, 0, 0, 230))
                surface.DrawRect(0, 0, w, h)

                draw.SimpleText("Use me", "Trebuchet24", w / 2, h / 2, color_white, 1, 1)
            end
        )

    w3d.End3D2D()

end)