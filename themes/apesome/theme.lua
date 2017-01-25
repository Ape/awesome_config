-- Apesome theme for Awesome WM
-- Based on "Zenburn" by Adrian C. (anrxc)

-- {{{ Main
theme = {}
theme.font = "Bok MonteCarlo 8"
foldername = "apesome"
themefolder = "~/.config/awesome/themes/" .. foldername
-- }}}

--## Dimensions ##--
theme.border_width = "2"
theme.panel_height = 14

--## Colors ##--
theme.fg_normal = "#e2e6e2"
theme.fg_focus  = "#99bfe6"
theme.fg_urgent = "#ff0000"
theme.bg_normal = "#313031"
theme.bg_focus  = "#343030"
theme.bg_urgent = "#3f3f3f"

-- Widgets
theme.taglist_bg_focus = "#5e79b3"

-- Borders
theme.border_normal = "#070f28"
theme.border_focus  = "#5e78b3"
theme.border_marked = "#cc9393"

-- Titlebars
theme.titlebar_bg_normal = "#3f3f3f"
theme.titlebar_bg_focus  = theme.titlebar_bg_normal

--## Icons ##--
-- Taglist
theme.taglist_squares_sel   = themefolder .. "/taglist/squarefz.png"
theme.taglist_squares_unsel = themefolder .. "/taglist/squarez.png"

-- Misc
theme.awesome_icon           = themefolder .. "/awesome-icon.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"

-- Layout
theme.layout_tile       = themefolder .. "/layouts/tile.png"
theme.layout_tileleft   = themefolder .. "/layouts/tileleft.png"
theme.layout_tilebottom = themefolder .. "/layouts/tilebottom.png"
theme.layout_tiletop    = themefolder .. "/layouts/tiletop.png"
theme.layout_fairv      = themefolder .. "/layouts/fairv.png"
theme.layout_fairh      = themefolder .. "/layouts/fairh.png"
theme.layout_spiral     = themefolder .. "/layouts/spiral.png"
theme.layout_dwindle    = themefolder .. "/layouts/dwindle.png"
theme.layout_max        = themefolder .. "/layouts/max.png"
theme.layout_fullscreen = themefolder .. "/layouts/fullscreen.png"
theme.layout_magnifier  = themefolder .. "/layouts/magnifier.png"
theme.layout_floating   = themefolder .. "/layouts/floating.png"

-- Titlebar
theme.titlebar_close_button_focus  = themefolder .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal = themefolder .. "/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = themefolder .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themefolder .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themefolder .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themefolder .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = themefolder .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themefolder .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themefolder .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themefolder .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = themefolder .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themefolder .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themefolder .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themefolder .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = themefolder .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themefolder .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themefolder .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themefolder .. "/titlebar/maximized_normal_inactive.png"

theme.rodentbane_bg = "#ff0000"
theme.rodentbane_width = 1

return theme
