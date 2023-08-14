script_name('PriceHelper')
script_author('rertlop')
script_version('1.0')

require "lib.moonloader" -- подключение библиотеки
local memory = require 'memory'
local dlstatus = require('moonloader').download_status
local inicfg = require("inicfg")
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

-- config:

local cfgName = "\\PriceHelper.ini"

local cfg = inicfg.load({
    main = {
		theme = 0
    },
}, "PriceHelper")


if not doesFileExist('moonloader/config/priceHelper.ini') then inicfg.save(cfg, cfgName) end

local menu = 14
local color = '{00b052}'
local result = imgui.ImInt(cfg.main.theme)


local main_window_state = imgui.ImBool(false)


update_state = false

local script_vers = 7
local script_vers_text = "1.1"

local update_url = "https://raw.githubusercontent.com/rertlop/pricehelper/main/update.ini" -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. "/update.ini" -- и тут свою ссылку

local script_url = "https://github.com/shugaev2003/priceinfo/raw/main/price.luac" -- тут свою ссылку
local script_path = thisScript().path



function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if cfg.main.theme == 0 then themeSettings(0) color = '{ff4747}'
	elseif cfg.main.theme == 1 then themeSettings(1) color = '{26DDDD}'
	elseif cfg.main.theme == 2 then themeSettings(2) color = '{0000FF}}'
	else cfg.main.theme = 0 themeSettings(0) color = '{ff4747}' end

	sampRegisterChatCommand("price", cmd_imgui)
	sampAddChatMessage(''..color..'[PriceHelper]{ffffff} успешно загружен! Активаия:'..color..' /price ', -1)

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick = sampGetPlayerNickname(id)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(''..color..'[PriceHelper] Есть обновление! Версия: ' .. updateIni.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end
    end)	


	imgui.Process = false

	-------------------------------------------------------------------

	while true do
	  wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage(''..color..'[PriceHelper] Скрипт успешно обновлен!', -1)
                    thisScript():reload()
                end
            end)
            break
        end	  

	  if main_window_state.v == false then
	  	imgui.Process = false
	  end	
	end
end 

-- -- -- All themes for ImGui by ronnyevans.lua -- -- --
function themeSettings(theme)
 imgui.SwitchContext()
 local style = imgui.GetStyle()
 local ImVec2 = imgui.ImVec2
 local style = imgui.GetStyle()
 local colors = style.Colors
 local clr = imgui.Col
 local ImVec4 = imgui.ImVec4
 style.WindowPadding = imgui.ImVec2(12, 12) -------- толщина окон
 style.WindowRounding = 20        ----------------округление окон
 style.ChildWindowRounding = 20 -------------округление внутренних окон
 style.FramePadding = imgui.ImVec2(7, 4) ---------размер кнопок
 style.FrameRounding = 20.0 ---------------округление кнопок
 style.ItemSpacing = imgui.ImVec2(1, 2) -----------интервал кнопок
 style.ItemInnerSpacing = imgui.ImVec2(1, 1) --------- не выявлено
 style.IndentSpacing = 70 -------------- не выявлено
 style.ScrollbarSize = 15.0 ----------размер ползунка
 style.ScrollbarRounding = 20 ------- не выявлено
 style.GrabMinSize = 30 ---------- не выявлено
 style.GrabRounding = 30 ----------- не выявлено
 style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5) ------текст на окне
 style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5) ------ текст на кнопах с ссылкой
 if theme == 0 or nil then 
 	colors[clr.Text]                   = ImVec4(3.95, 3.96, 3.98, 3.00); -------------- цвет темы
	colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00);
	colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00);
	colors[clr.ChildWindowBg]          = ImVec4(0.12, 0.12, 0.12, 1.00);
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
	colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00);
	colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10);
	 colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40);
    colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67);
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00);
    colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51);
	colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39);
	colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00);
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00);
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00);
	colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 1.00);
	 colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00);
    colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00);
    colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00);
    colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40);
    colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00);
    colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00);
    colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31);
    colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80);
    colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00);
	colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25);
    colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67);
    colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95);
	colors[clr.CloseButton]            = ImVec4(0.40, 0.39, 0.38, 0.16);
    colors[clr.CloseButtonHovered]     = ImVec4(0.40, 0.39, 0.38, 0.39);
    colors[clr.CloseButtonActive]      = ImVec4(0.40, 0.39, 0.38, 1.00);
	 colors[clr.PlotLines]             = ImVec4(0.40, 0.39, 0.38, 0.63);
    colors[clr.PlotLinesHovered]       = ImVec4(0.25, 1.00, 0.00, 1.00);
    colors[clr.PlotHistogram]          = ImVec4(0.40, 0.39, 0.38, 0.63);
    colors[clr.PlotHistogramHovered]   = ImVec4(0.25, 1.00, 0.00, 1.00);
    colors[clr.TextSelectedBg]         = ImVec4(0.25, 1.00, 0.00, 0.43);
	colors[clr.ModalWindowDarkening]   = ImVec4(0.26, 0.26, 0.26, 0.60);
  elseif theme == 1 then
    colors[clr.Text]                   = ImVec4(0.00, 1.00, 1.00, 1.00);
    colors[clr.TextDisabled]           = ImVec4(0.00, 0.40, 0.41, 1.00);
colors[clr.WindowBg]                   = ImVec4(0.00, 0.00, 0.00, 1.00);
colors[clr.ChildWindowBg]              = ImVec4(0.00, 0.00, 0.00, 0.00);
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
    colors[clr.Border]                 = ImVec4(0.00, 1.00, 1.00, 0.65);
colors[clr.BorderShadow]               = ImVec4(0.00, 0.00, 0.00, 0.00);
colors[clr.FrameBg]                    = ImVec4(0.44, 0.80, 0.80, 0.18);
colors[clr.FrameBgHovered]             = ImVec4(0.44, 0.80, 0.80, 0.27);
colors[clr.FrameBgActive]              = ImVec4(0.44, 0.81, 0.86, 0.66);
colors[clr.TitleBg]                    = ImVec4(0.14, 0.18, 0.21, 0.73);
    colors[clr.TitleBgActive]          = ImVec4(0.00, 1.00, 1.00, 0.27);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.54);
    colors[clr.MenuBarBg]              = ImVec4(0.00, 0.00, 0.00, 0.20);
colors[clr.ScrollbarBg]                = ImVec4(0.22, 0.29, 0.30, 0.71);
colors[clr.ScrollbarGrab]              = ImVec4(0.00, 1.00, 1.00, 0.44);
colors[clr.ScrollbarGrabHovered]       = ImVec4(0.00, 1.00, 1.00, 0.74);
colors[clr.ScrollbarGrabActive]         = ImVec4(0.00, 1.00, 1.00, 1.00);
colors[clr.ComboBg]                    = ImVec4(0.16, 0.24, 0.22, 0.60);
colors[clr.CheckMark]                  = ImVec4(0.00, 1.00, 1.00, 0.68);
colors[clr.SliderGrab]                 = ImVec4(0.00, 1.00, 1.00, 0.36);
colors[clr.SliderGrabActive]           = ImVec4(0.00, 1.00, 1.00, 0.76);
colors[clr.Button]                     = ImVec4(0.00, 0.65, 0.65, 0.46);
colors[clr.ButtonHovered]              = ImVec4(0.01, 1.00, 1.00, 0.43);
colors[clr.ButtonActive]               = ImVec4(0.00, 1.00, 1.00, 0.62);
colors[clr.Header]                     = ImVec4(0.00, 1.00, 1.00, 0.33);
colors[clr.HeaderHovered]              = ImVec4(0.00, 1.00, 1.00, 0.42);
colors[clr.HeaderActive]               = ImVec4(0.00, 1.00, 1.00, 0.54);
    colors[clr.ResizeGrip]             = ImVec4(0.00, 1.00, 1.00, 0.54);
colors[clr.ResizeGripHovered]           = ImVec4(0.00, 1.00, 1.00, 0.74);
colors[clr.ResizeGripActive]           = ImVec4(0.00, 1.00, 1.00, 1.00);
colors[clr.CloseButton]                = ImVec4(0.00, 0.78, 0.78, 0.35);
colors[clr.CloseButtonHovered]         = ImVec4(0.00, 0.78, 0.78, 0.47);
colors[clr.CloseButtonActive]          = ImVec4(0.00, 0.78, 0.78, 1.00);
colors[clr.PlotLines]                  = ImVec4(0.00, 1.00, 1.00, 1.00);
colors[clr.PlotLinesHovered]           = ImVec4(0.00, 1.00, 1.00, 1.00);
colors[clr.PlotHistogram]              = ImVec4(0.00, 1.00, 1.00, 1.00);
colors[clr.PlotHistogramHovered]       = ImVec4(0.00, 1.00, 1.00, 1.00);
colors[clr.TextSelectedBg]             = ImVec4(0.00, 1.00, 1.00, 0.22);
colors[clr.ModalWindowDarkening]       = ImVec4(0.04, 0.10, 0.09, 0.51);
	
	 elseif theme == 2 then 
	    colors[clr.Text]                         = ImVec4(0.860, 0.930, 0.890, 0.78);
            colors[clr.TextDisabled]             = ImVec4(0.860, 0.930, 0.890, 0.28);
                colors[clr.Text]                 = ImVec4(0.86, 0.93, 0.89, 0.78);
                colors[clr.TextDisabled]         = ImVec4(0.36, 0.42, 0.47, 1.00);
                colors[clr.WindowBg]             = ImVec4(0.11, 0.15, 0.17, 1.00);
                colors[clr.ChildWindowBg]        = ImVec4(0.15, 0.18, 0.22, 1.00);
                colors[clr.PopupBg]              = ImVec4(0.08, 0.08, 0.08, 0.94);
                colors[clr.Border]               = ImVec4(0.43, 0.43, 0.50, 0.50);
                colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00);
                colors[clr.FrameBg]              = ImVec4(0.20, 0.25, 0.29, 1.00);
                colors[clr.FrameBgHovered]       = ImVec4(0.12, 0.20, 0.28, 1.00);
                colors[clr.FrameBgActive]        = ImVec4(0.09, 0.12, 0.14, 1.00);
                colors[clr.TitleBg]              = ImVec4(0.09, 0.12, 0.14, 0.65);
                colors[clr.TitleBgActive]        = ImVec4(0.11, 0.30, 0.59, 1.00);
                colors[clr.TitleBgCollapsed]     = ImVec4(0.00, 0.00, 0.00, 0.51);
                colors[clr.MenuBarBg]            = ImVec4(0.15, 0.18, 0.22, 1.00);
                colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.39);
                colors[clr.ScrollbarGrab]        = ImVec4(0.20, 0.25, 0.29, 1.00);
                colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00);
                colors[clr.ScrollbarGrabActive]  = ImVec4(0.09, 0.21, 0.31, 1.00);
                colors[clr.ComboBg]              = ImVec4(0.20, 0.25, 0.29, 1.00);
                colors[clr.CheckMark]            = ImVec4(0.28, 0.56, 1.00, 1.00);
                colors[clr.SliderGrab]           = ImVec4(0.28, 0.56, 1.00, 1.00);
                colors[clr.SliderGrabActive]     = ImVec4(0.37, 0.61, 1.00, 1.00);
                colors[clr.Button]               = ImVec4(0.08, 0.33, 0.55, 1.00);
                colors[clr.ButtonHovered]        = ImVec4(0.28, 0.56, 1.00, 1.00);
                colors[clr.ButtonActive]         = ImVec4(0.06, 0.53, 0.98, 1.00);
                colors[clr.Header]               = ImVec4(0.20, 0.25, 0.29, 0.55);
                colors[clr.HeaderHovered]        = ImVec4(0.26, 0.59, 0.98, 0.80);
                colors[clr.HeaderActive]         = ImVec4(0.26, 0.59, 0.98, 1.00);
                colors[clr.Separator]            = ImVec4(0.50, 0.50, 0.50, 1.00);
                colors[clr.SeparatorHovered]     = ImVec4(0.60, 0.60, 0.70, 1.00);
                colors[clr.SeparatorActive]      = ImVec4(0.70, 0.70, 0.90, 1.00);
                colors[clr.ResizeGrip]           = ImVec4(0.26, 0.59, 0.98, 0.25);
                colors[clr.ResizeGripHovered]    = ImVec4(0.26, 0.59, 0.98, 0.67);
                colors[clr.ResizeGripActive]     = ImVec4(0.06, 0.05, 0.07, 1.00);
                colors[clr.CloseButton]          = ImVec4(0.40, 0.39, 0.38, 0.16);
                colors[clr.CloseButtonHovered]   = ImVec4(0.40, 0.39, 0.38, 0.39);
                colors[clr.CloseButtonActive]    = ImVec4(0.40, 0.39, 0.38, 1.00);
                colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00);
                colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00);
                colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00);
                colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00);
                colors[clr.TextSelectedBg]       = ImVec4(0.25, 1.00, 0.00, 0.43);
                colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73);
	end
end

	-- -- -- Создатель темы (не всех цветов): ronnyevans.lua -- -- --

function cmd_imgui()
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end

function imgui.OnDrawFrame()
	local colours = {u8'Красный', u8'Монохром', u8'Синий'}	
	if main_window_state then
	imgui.SetNextWindowSize(imgui.ImVec2(450, 500), imgui.Cond.FirstUseEver) ------- размер окна !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if not window_pos then
		ScreenX, ScreenY = getScreenResolution()ScreenX, ScreenY = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(0.5, 0.5))
	end		
	imgui.Begin(u8"PriceHelper  | Версия: 1.0  | Восточный округ", main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar)
	imgui.CenterText(u8" ")
	imgui.SameLine()
	imgui.SetCursorPos(imgui.ImVec2(4, 25))
	imgui.BeginChild('left', imgui.ImVec2(123, -50), true)
	if imgui.Selectable(u8"Настройки", menu == 14) then menu = 14 
        elseif imgui.Selectable(u8"", menu == 99) then menu = 99
	elseif imgui.Selectable(u8"Аксессуары", menu == 1) then menu = 1 
	elseif imgui.Selectable(u8"Скины", menu == 2) then menu = 2 
	elseif imgui.Selectable(u8"Ресурсы", menu == 9) then menu = 9 
	elseif imgui.Selectable(u8"Тюнинг", menu == 10) then menu = 10 
	elseif imgui.Selectable(u8"Ларцы/Ящики", menu == 230) then menu = 230
	elseif imgui.Selectable(u8"Для Оружия", menu == 226) then menu = 226
	elseif imgui.Selectable(u8"", menu == 124) then menu = 124
	elseif imgui.Selectable(u8"", menu == 125) then menu = 125
	elseif imgui.Selectable(u8"Функции", menu == 22) then menu = 22
	elseif imgui.Selectable(u8"FPS Up", menu == 127) then menu = 127
	elseif imgui.Selectable(u8"", menu == 128) then menu = 128
	elseif imgui.Selectable(u8"", menu == 1223) then menu = 1223
	elseif imgui.Selectable(u8"Информация!!!", menu == 228) then menu = 228 end
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild('right', imgui.ImVec2(0, -50), true) 	
	if menu == 1 then
	
	imgui.Button(u8'Молоток')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Канистра на бедро')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 2.000.000$\nПРОДАЖА - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Рога')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 2.000.000$\nПРОДАЖА - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Фотоаппарат')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 2.000.000$\nПРОДАЖА - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Кирка')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 18.500.000$\nПРОДАЖА - 22.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Грабли')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 18.500.000$\nПРОДАЖА - 22.500.000$')
		    imgui.EndTooltip()
		end		
    imgui.Text(u8'---------------------------------------------')		
	imgui.Button(u8'Велосипед на спину')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 45.500.000$\nПРОДАЖА - 50.500.000$')
		    imgui.EndTooltip()
		end	
-------------------------------------------------------------------------------------------------
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Кейс GUCCI')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 8.000.000$\nПРОДАЖА - 16.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Кейс LOUIS VUITTON')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 8.000.000$\nПРОДАЖА - 16.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Кейс LOUIS VUITTON Черная')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 8.000.000$\nПРОДАЖА - 16.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Кейс ADIDAS')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 8.000.000$\nПРОДАЖА - 16.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Кейс NIKE')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 8.000.000$\nПРОДАЖА - 16.000.000$')
		    imgui.EndTooltip()
		end	
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Мотошлем (Красный)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 4.000.000$\nПРОДАЖА - 9.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Мотошлем (Белый)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 4.000.000$\nПРОДАЖА - 9.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Мотошлем (Фиолетовый)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 4.000.000$\nПРОДАЖА - 9.000.000$')
		    imgui.EndTooltip()
		end	

---
	imgui.Button(u8'Спортивный Шлем (Красный)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - НЕ ИЗВЕСТНО$\nПРОДАЖА - НЕ ИЗВЕСТНО$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Спортивный Шлем (Огненный)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - НЕ ИЗВЕСТНО$\nПРОДАЖА - НЕ ИЗВЕСТНО$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Спортивный Шлем (Серый)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - НЕ ИЗВЕСТНО$\nПРОДАЖА - НЕ ИЗВЕСТНО$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Спортивный Шлем (Белый)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - НЕ ИЗВЕСТНО$\nПРОДАЖА - НЕ ИЗВЕСТНО$')
		    imgui.EndTooltip()
		end	
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Сумка Бизнесмена (Серая)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Сумка Бизнесмена (Желтая)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Сумка Бизнесмена (Коричневая)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Сумка Бизнесмена (Черная)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Сумка Бизнесмена (Разноцветная)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Аксессуар Бандитская сумка 1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Бандитская сумка 2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Бандитская сумка 3')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Бандитская сумка 4')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Бандитская сумка 5')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Крылья Ангелов (Зеленые)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end		
	imgui.Button(u8'Крылья Ангелов (Голубые)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end		
	imgui.Button(u8'Крылья Ангелов (Синие)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end		
	imgui.Button(u8'Крылья Ангелов (Фиолетовые)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Крылья Ангелов (Черные)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end		
    imgui.Text(u8'---------------------------------------------')
    imgui.Button(u8'Бандитский Бронежилет 1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.450.000$\nПРОДАЖА - 3.500.000$')
		    imgui.EndTooltip()
		end		
	imgui.Button(u8'Бандитский Бронежилет 2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.450.000$\nПРОДАЖА - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Бандитский Бронежилет 3')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.450.000$\nПРОДАЖА - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Бандитский Бронежилет 4')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.450.000$\nПРОДАЖА - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Бандитский Бронежилет 5')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.450.000$\nПРОДАЖА - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Пасхальный Бронежилет 1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.500.000$\nПРОДАЖА - 4.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Пасхальный Бронежилет 2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.500.000$\nПРОДАЖА - 4.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Пасхальный Бронежилет 3')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.500.000$\nПРОДАЖА - 4.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Пасхальный Бронежилет 4')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.500.000$\nПРОДАЖА - 4.000.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Пасхальный Нимб')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 2.000.000$\nПРОДАЖА - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Нимб обычный')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 10.000.000$\nПРОДАЖА - 15.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Стич')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 300.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Хаги-Ваги')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 300.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Киси-Миси')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 300.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Кагуне')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Скейтборд')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.000.000$\nПРОДАЖА - 3.500.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Шар на плечо#1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 17.000.000$\nПРОДАЖА - 23.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Шар на плечо#2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 17.000.000$\nПРОДАЖА - 23.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Шар на плечо#3')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 17.000.000$\nПРОДАЖА - 23.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Шар на плечо#4')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 10.000.000$\nПРОДАЖА - 14.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Шар на плечо#5')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 10.000.000$\nПРОДАЖА - 14.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Шар на плечо#6')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 10.000.000$\nПРОДАЖА - 14.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Шар на плечо#7')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 10.000.000$\nПРОДАЖА - 14.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Аксессуар Машинка на радиоуправлении')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.000.000$\nПРОДАЖА - 3.000.000$')
		    imgui.EndTooltip()
		end
		
	imgui.Button(u8'Аксессуар Самолёт на радиоуправлении')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.000.000$\nПРОДАЖА - 3.000.000$')
		    imgui.EndTooltip()
		end
		
	imgui.Button(u8'Аксессуар Вертолёт на радиоуправлении #1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.000.000$\nПРОДАЖА - 3.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Вертолёт на радиоуправлении #2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.000.000$\nПРОДАЖА - 3.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Танк на радиоуправлении')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1.000.000$\nПРОДАЖА - 3.000.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Гитара Тыква')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Аксессуар Маска Анонимус')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Маска Грабитель')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Маска Marshmallow')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Маска Жучара')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Маска Пугало')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Маска Дъявол')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Маска Череп')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Аксессуар Маска Клоун')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 700.000$')
		    imgui.EndTooltip()
		end
		
	elseif menu == 230 then --------------------------ЛАРЦЫ
	imgui.Button(u8'Ларец Олигарха')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 700.000$\nПРОДАЖА - 1.700.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Ларец Ларец с премией')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 150.000$\nПРОДАЖА - 350.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Ларец Ларец дальнобойщика')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 350.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Ларец Ларец водителя автобуса')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 350.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Ларец Ларец рыболова')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 350.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Ящик MARVEL')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 175.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Ящик Американсих звезд')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 230.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Авто ящик')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 600.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Мото ящик')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 100.000$\nПРОДАЖА - 450.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Ящик Джентельмены')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 170.000$')
		    imgui.EndTooltip()
		end
		
	elseif menu == 226 then -------------------------УЛУЧШЕНИЯ ОРУУЖИЯ
	imgui.Button(u8'Цивье на DEAGLE')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'ПРИКЛАД на DEAGLE')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end
		
	elseif menu == 2 then --------------------Скины
	imgui.Button(u8'Одежда Джентельмен 1 № 432')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 400.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Одежда Джентельмен 2 № 433')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 400.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Одежда Джентельмен 3 № 434')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 400.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Одежда Джентельмен 4 № 435')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 400.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Одежда Джентельмен 5 № 436')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 400.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Одежда Джентельмен 6 № 437')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 400.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Одежда Железный человек № 450')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 400.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Одежда человек-паук № 451')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 400.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Одежда Бэтмен № 448')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 400.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Одежда Капитан Америка № 449')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 400.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Одежда Веном № 452')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 400.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
--------------------------- ==9 ресурсы		
	elseif menu == 9 then
	imgui.Button(u8'Подарок')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 16.000$\nПРОДАЖА - 25.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8"Аптечка")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 250$\nПРОДАЖА - 5.000$')
		    imgui.EndTooltip()
		end	
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8"Дрова")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 1000.$\nПРОДАЖА - 10.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8"Аллюминий")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 35.000$\nПРОДАЖА - 75.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8"Бронза")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 4.000$\nПРОДАЖА - 13.000$')
		    imgui.EndTooltip()
		end			
	imgui.Button(u8"Камень")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 750.$\nПРОДАЖА - 3.500$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8"Металл")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 13.000$\nПРОДАЖА - 22.000$')
		    imgui.EndTooltip()
		end				
	imgui.Button(u8"Серебро")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 4.500$\nПРОДАЖА - 17.500$')
		    imgui.EndTooltip()
		end		
    imgui.Button(u8"Золото")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 55.000$\nПРОДАЖА - 95.000$')
		    imgui.EndTooltip()
		end	
    imgui.Button(u8'Точильный камень')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 95.000$\nПРОДАЖА - 175.000$')
		    imgui.EndTooltip()
		end   		
	imgui.Button(u8'Наркотики')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 300$.\nПРОДАЖА - 1.500$.')
		    imgui.EndTooltip()
		end   
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Хлопок')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500$\nПРОДАЖА - 1.500$')
		    imgui.EndTooltip()
		end   
	imgui.Button(u8'Лён')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500$\nПРОДАЖА - 1.500$')
		    imgui.EndTooltip()
		end   
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Бронзовая Рулетка')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 12.000$\nПРОДАЖА - 25.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Серебряная Рулетка')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 45.000$\nПРОДАЖА - 95.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Золотая Рулетка')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 350.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Эффект пополнения счета 24 часа')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Анти-Варн')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 500.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'Чистый рудный чай')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 350.000$\nПРОДАЖА - 1.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Чистый фермерский чай')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 250.000')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Бандитский респект')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500$\nПРОДАЖА - 10.000')
		    imgui.EndTooltip()
		end
	elseif menu == 228 then
	----------imgui.Text(u8'Автор:') imgui.SameLine() imgui.Link('https://vk.com/vharibo', u8' real vamp.')
	imgui.Text(u8'---------------------------------------------------------------------------')
	------------imgui.Text(u8'Телерам Канал:') imgui.SameLine() imgui.Link('https://vk.com/vharibo', u8' СКОРО.')
	imgui.Text(u8'--------------------------------------------------------------------------')
	imgui.Text(u8'Все спойлеры по обновлению скрипта ')
	imgui.Text(u8'будут в Телеграм Канале')
	imgui.Text(u8'За ценами следят барыги ЦР с опытом')
	imgui.Text(u8'Значит что цены от знающих людей')
	imgui.Text(u8'!!!В СКРИПТЕ ТОЛЬКО ХОДОВЫЕ ТОВАРЫ!!!')
	imgui.Text(u8'--------------------------------------------------------------------------')
        imgui.Text(u8'--------------------------------------------------------------------------')
	imgui.Text(u8'Скрипт автоматически обновляет цены')
		imgui.Separator()
                imgui.SetCursorPos(imgui.ImVec2(70, 250))                      ---------dels
                imgui.Button(u8'Обновление было',imgui.ImVec2(155,85))             
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'29.07.2023\n10:30 МСК')
		    imgui.EndTooltip()
		end	
		
	elseif menu == 127 then
	
	imgui.Text(u8'                     Сжать текстуры машин')
		imgui.Separator()
		
	imgui.SetCursorPos(imgui.ImVec2(40, 35))
    if imgui.Button(u8'Включить',imgui.ImVec2(95,45)) then 
	    writeMemory(0x52C9EE, 1, 1, true)
        activation = true
		sampAddChatMessage(string.format("Машины сжаты", thisScript().name, thisScript().version), -1)
	end
	
	imgui.SetCursorPos(imgui.ImVec2(175, 35))
	if imgui.Button(u8'Выключить',imgui.ImVec2(95,45)) then 
	    writeMemory(0x52C9EE, 1, 0, true)
        activation = false
		sampAddChatMessage(string.format("Машины имеют пежний вид", thisScript().name, thisScript().version), -1)
	end

	
	elseif menu == 22 then 		
	if imgui.Button(u8'Очистить чат') then 
	
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
		sampAddChatMessage(string.format("             ", thisScript().name, thisScript().version), -1)
    end
	
	if imgui.Button(u8'Ввести gift автоматически') then 
	    sampSendChat("/gift rodina300_3")
	end
	
	if imgui.Button(u8'Закрыть соединение с сервером') then
	        sampSendChat("/id Danil_Limanskiy")
		sampSendChat("/id Farid_Mingazov")  
		sampSendChat("/id Bob_Ross") 
		sampSendChat("/id Maxim_Nelson") 
	        sampSendChat("/id Alexey_Homer") 
		sampSendChat("/id Yan_Helfinger") 
		sampSendChat("/id Vladizio_Kotov") 
		sampSendChat("/id Silvestr_Stalone") 
		sampSendChat("/id Evander_Holyfield") 
		sampSendChat("/id Yanke_Green")
		sampSendChat("/id Shoma_Nedelay")
	        sampSendChat("/id Ethan_Collins")
		sampSendChat("/id Rapuntsel_Ramirez")
		sampSendChat("/id Aqua_Cimadevilla")
		sampSendChat("/id Nikimok_Suvorow")
		sampSendChat("/id Matvei_Krasnoyarskiy")
		sampSendChat("/id Pasha_Yangov")
		sampSendChat("/id Terror_Blade")
		sampSendChat("/id Charles_Lee")
	        sampSendChat("/id Artur_Tapkin ")
		sampSendChat("/id Luka_Desmod")
		sampSendChat("/id Aleksey_Korovich")
		sampSendChat("/id Morfis_Vercetti")
		sampSendChat("/id Iven_Wrestler")
		sampSendChat("/id Neo_Moonside")
		sampSendChat("/id Ilya_Godis")
		sampSendChat("/id Johnny_Darkness")
		sampSendChat("/id Vladislav_Kutepov")
		sampSendChat("/id Mishko_Limanskiy")
		sampSendChat("/id Vladislav_Skizer")
		sampSendChat("/id Tommy_Yablochko")
		sampSendChat("/id Sasha_Puhov")
		sampSendChat("/id Nazarbek_Gromov")
		sampSendChat("/id Ivan_Lekhochov")
		sampSendChat("/id Egor_Grigorevich")
		sampSendChat("/id Sasha_Latyshevich")
		sampSendChat("/id Sergey_Golovin")
		sampSendChat("/id Jon_Suvorov")
		sampSendChat("/id Antonio_Strano")
		sampSendChat("/id Maloy_Bushidik")
		sampSendChat("/id Jon_Kaster")
		sampSendChat("/id Egor_Mentol")
		sampSendChat("/id White_Mirniy")
		sampSendChat("/id Rocket_Twinki")
		sampSendChat("/id Akeshi_Thugger")
		sampSendChat("/id Vi_Svon")
		sampSendChat("/id Alexandr_Melnik")
		sampSendChat("/id Lev_Slens")
		sampSendChat("/id Svyata_Zayats")
		sampSendChat("/id Daniel_Daiki")
		sampSendChat("/id Danya_Taami")
		sampSendChat("/id Haruma_Huracan")
		sampSendChat("/id Timur_Ptichkinov")
	end
	
					
---------------------------------ТЮНИНГ
	elseif menu == 10 then	
	imgui.Button(u8'Все Детали SPORT')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 350.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'Все Детали SPORT+')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 600.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'STAGE 1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 75.000$\nПРОДАЖА - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'STAGE 2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 500.000$\nПРОДАЖА - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'STAGE 3')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 2.500.000$\nПРОДАЖА - 5.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'Все Детали improv')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'СКУП - 50.000$\nПРОДАЖА - 275.000$')
		    imgui.EndTooltip()
		end
	

	-- Настройки -----
	elseif menu == 14 then
		-- группа вк
		------------imgui.Text(u8'ВК Автора:') imgui.SameLine() imgui.Link('https://vk.com/vharibo', u8'real vamp.')
                ------------imgui.Text(u8'Телеграм Канал:') imgui.SameLine() imgui.Link('https://vk.com/vharibo', u8'СКОРО.')
		imgui.Separator()
	  	imgui.Text(u8' Выбор темы:')
		if imgui.Combo('##1', result, colours, -1) then cfg.main.theme = result.v save()
			if cfg.main.theme == 0 then themeSettings(0) color = '{ff4747}'
			elseif cfg.main.theme == 1 then themeSettings(1) color = '{9370DB}'
			elseif cfg.main.theme == 2 then themeSettings(2) color = '{F3F3F3}'
			else cfg.main.theme = 0 themeSettings(0) color = '{ff4747}' end
		end
		imgui.Separator()
																																																																																																																																																																																												
	end
	imgui.EndChild()

	----------------------------------------------------------------
	imgui.SetCursorPos(imgui.ImVec2(13, 445)) ------------------ x y расположение данной кнопки
	if imgui.Button(u8'Купить вирты',imgui.ImVec2(135,45)) then --------
	    os.execute('start https://funpay.com/users/6332429/')
    end

        imgui.SetCursorPos(imgui.ImVec2(160, 445)) ------------------ x y расположение данной кнопки
	if imgui.Button(u8'ВК Автора',imgui.ImVec2(135,45)) then --------
	    os.execute('start https://vk.com/vharibo')
    end

    imgui.SetCursorPos(imgui.ImVec2(305, 445))
   	if imgui.Button(u8'Закрыть',imgui.ImVec2(135,45)) then
	    main_window_state.v = not main_window_state.v
    end
imgui.End()
end
end   


function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 10 - calc.x / 10 )
    imgui.Text(text)
end

function save()
	inicfg.save(cfg, 'priceHelper.ini')
end


function imgui.Link(link,name,myfunc)
	myfunc = type(name) == 'boolean' and name or myfunc or false
	name = type(name) == 'string' and name or type(name) == 'boolean' and link or link
	local size = imgui.CalcTextSize(name)
	local p = imgui.GetCursorScreenPos()
	local p2 = imgui.GetCursorPos()
	local resultBtn = imgui.InvisibleButton('##'..link..name, size)
	if resultBtn then
		if not myfunc then
		    os.execute('explorer '..link)
		end
	end
	imgui.SetCursorPos(p2)
	if imgui.IsItemHovered() then
		imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ButtonHovered], name)
		imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]))
	else
		imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.Button], name)
	end
	return resultBtn
end

function imgui.offset(text)
    local offset = 130
    imgui.Text(text)
    imgui.SameLine()
    imgui.SetCursorPosX(offset)
    imgui.PushItemWidth(500)
end
function imgui.prmoffset(text)
    local offset = 87
    imgui.Text(text)
    imgui.SameLine()
    imgui.SetCursorPosX(offset)
    imgui.PushItemWidth(500)
end