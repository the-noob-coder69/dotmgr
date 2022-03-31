-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        RC.libs.awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        RC.libs.awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    RC.libs.awful.titlebar(c).widget = {
        { -- Left
            RC.libs.awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = RC.libs.wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = RC.libs.awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = RC.libs.wibox.layout.flex.horizontal
        },
        { -- Right
            RC.libs.awful.titlebar.widget.floatingbutton (c),
            RC.libs.awful.titlebar.widget.maximizedbutton(c),
            RC.libs.awful.titlebar.widget.stickybutton   (c),
            RC.libs.awful.titlebar.widget.ontopbutton    (c),
            RC.libs.awful.titlebar.widget.closebutton    (c),
            layout = RC.libs.wibox.layout.fixed.horizontal()
        },
        layout = RC.libs.wibox.layout.align.horizontal
    }
end)

-- Titlebars only on floating windows
client.connect_signal("property::floating", function(c)
    if c.floating and not (c.requests_no_titlebar or c.fullscreen) then
        RC.libs.awful.titlebar.show(c)
    else
        RC.libs.awful.titlebar.hide(c)
    end
end)

RC.libs.awful.tag.attached_connect_signal(nil,"property::layout", function(t)
    local float = t.layout.name == "floating"
    for _,c in pairs(t:clients()) do
        c.floating = float
    end
end)

function toggle(c)
    if c.floating or c.first_tag.layout.name == "floating" then
        RC.libs.awful.titlebar.show(c)
    else
        RC.libs.awful.titlebar.hide(c)
    end
end

RC.custom.titlebar.toggle = toggle
