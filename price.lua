script_name('PriceHelper')
script_author('rertlop')
script_version('1.0')

require "lib.moonloader" -- ����������� ����������
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

local update_url = "https://raw.githubusercontent.com/rertlop/pricehelper/main/update.ini" -- ��� ���� ���� ������
local update_path = getWorkingDirectory() .. "/update.ini" -- � ��� ���� ������

local script_url = "https://github.com/shugaev2003/priceinfo/raw/main/price.luac" -- ��� ���� ������
local script_path = thisScript().path



function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if cfg.main.theme == 0 then themeSettings(0) color = '{ff4747}'
	elseif cfg.main.theme == 1 then themeSettings(1) color = '{26DDDD}'
	elseif cfg.main.theme == 2 then themeSettings(2) color = '{0000FF}}'
	else cfg.main.theme = 0 themeSettings(0) color = '{ff4747}' end

	sampRegisterChatCommand("price", cmd_imgui)
	sampAddChatMessage(''..color..'[PriceHelper]{ffffff} ������� ��������! ��������:'..color..' /price ', -1)

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick = sampGetPlayerNickname(id)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(''..color..'[PriceHelper] ���� ����������! ������: ' .. updateIni.info.vers_text, -1)
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
                    sampAddChatMessage(''..color..'[PriceHelper] ������ ������� ��������!', -1)
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
 style.WindowPadding = imgui.ImVec2(12, 12) -------- ������� ����
 style.WindowRounding = 20        ----------------���������� ����
 style.ChildWindowRounding = 20 -------------���������� ���������� ����
 style.FramePadding = imgui.ImVec2(7, 4) ---------������ ������
 style.FrameRounding = 20.0 ---------------���������� ������
 style.ItemSpacing = imgui.ImVec2(1, 2) -----------�������� ������
 style.ItemInnerSpacing = imgui.ImVec2(1, 1) --------- �� ��������
 style.IndentSpacing = 70 -------------- �� ��������
 style.ScrollbarSize = 15.0 ----------������ ��������
 style.ScrollbarRounding = 20 ------- �� ��������
 style.GrabMinSize = 30 ---------- �� ��������
 style.GrabRounding = 30 ----------- �� ��������
 style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5) ------����� �� ����
 style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5) ------ ����� �� ������ � �������
 if theme == 0 or nil then 
 	colors[clr.Text]                   = ImVec4(3.95, 3.96, 3.98, 3.00); -------------- ���� ����
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

	-- -- -- ��������� ���� (�� ���� ������): ronnyevans.lua -- -- --

function cmd_imgui()
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end

function imgui.OnDrawFrame()
	local colours = {u8'�������', u8'��������', u8'�����'}	
	if main_window_state then
	imgui.SetNextWindowSize(imgui.ImVec2(450, 500), imgui.Cond.FirstUseEver) ------- ������ ���� !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if not window_pos then
		ScreenX, ScreenY = getScreenResolution()ScreenX, ScreenY = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(0.5, 0.5))
	end		
	imgui.Begin(u8"PriceHelper  | ������: 1.0  | ��������� �����", main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar)
	imgui.CenterText(u8" ")
	imgui.SameLine()
	imgui.SetCursorPos(imgui.ImVec2(4, 25))
	imgui.BeginChild('left', imgui.ImVec2(123, -50), true)
	if imgui.Selectable(u8"���������", menu == 14) then menu = 14 
        elseif imgui.Selectable(u8"", menu == 99) then menu = 99
	elseif imgui.Selectable(u8"����������", menu == 1) then menu = 1 
	elseif imgui.Selectable(u8"�����", menu == 2) then menu = 2 
	elseif imgui.Selectable(u8"�������", menu == 9) then menu = 9 
	elseif imgui.Selectable(u8"������", menu == 10) then menu = 10 
	elseif imgui.Selectable(u8"�����/�����", menu == 230) then menu = 230
	elseif imgui.Selectable(u8"��� ������", menu == 226) then menu = 226
	elseif imgui.Selectable(u8"", menu == 124) then menu = 124
	elseif imgui.Selectable(u8"", menu == 125) then menu = 125
	elseif imgui.Selectable(u8"�������", menu == 22) then menu = 22
	elseif imgui.Selectable(u8"FPS Up", menu == 127) then menu = 127
	elseif imgui.Selectable(u8"", menu == 128) then menu = 128
	elseif imgui.Selectable(u8"", menu == 1223) then menu = 1223
	elseif imgui.Selectable(u8"����������!!!", menu == 228) then menu = 228 end
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild('right', imgui.ImVec2(0, -50), true) 	
	if menu == 1 then
	
	imgui.Button(u8'�������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'�������� �� �����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 2.000.000$\n������� - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 2.000.000$\n������� - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'�����������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 2.000.000$\n������� - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'�����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 18.500.000$\n������� - 22.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 18.500.000$\n������� - 22.500.000$')
		    imgui.EndTooltip()
		end		
    imgui.Text(u8'---------------------------------------------')		
	imgui.Button(u8'��������� �� �����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 45.500.000$\n������� - 50.500.000$')
		    imgui.EndTooltip()
		end	
-------------------------------------------------------------------------------------------------
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'���� GUCCI')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 8.000.000$\n������� - 16.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'���� LOUIS VUITTON')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 8.000.000$\n������� - 16.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'���� LOUIS VUITTON ������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 8.000.000$\n������� - 16.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'���� ADIDAS')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 8.000.000$\n������� - 16.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'���� NIKE')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 8.000.000$\n������� - 16.000.000$')
		    imgui.EndTooltip()
		end	
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'�������� (�������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 4.000.000$\n������� - 9.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'�������� (�����)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 4.000.000$\n������� - 9.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'�������� (����������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 4.000.000$\n������� - 9.000.000$')
		    imgui.EndTooltip()
		end	

---
	imgui.Button(u8'���������� ���� (�������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - �� ��������$\n������� - �� ��������$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'���������� ���� (��������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - �� ��������$\n������� - �� ��������$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'���������� ���� (�����)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - �� ��������$\n������� - �� ��������$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'���������� ���� (�����)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - �� ��������$\n������� - �� ��������$')
		    imgui.EndTooltip()
		end	
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'����� ���������� (�����)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'����� ���������� (������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'����� ���������� (����������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'����� ���������� (������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'����� ���������� (������������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'��������� ���������� ����� 1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ���������� ����� 2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ���������� ����� 3')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ���������� ����� 4')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ���������� ����� 5')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'������ ������� (�������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end		
	imgui.Button(u8'������ ������� (�������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end		
	imgui.Button(u8'������ ������� (�����)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end		
	imgui.Button(u8'������ ������� (����������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'������ ������� (������)')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end		
    imgui.Text(u8'---------------------------------------------')
    imgui.Button(u8'���������� ���������� 1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.450.000$\n������� - 3.500.000$')
		    imgui.EndTooltip()
		end		
	imgui.Button(u8'���������� ���������� 2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.450.000$\n������� - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���������� ���������� 3')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.450.000$\n������� - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���������� ���������� 4')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.450.000$\n������� - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���������� ���������� 5')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.450.000$\n������� - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���������� ���������� 1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.500.000$\n������� - 4.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���������� ���������� 2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.500.000$\n������� - 4.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���������� ���������� 3')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.500.000$\n������� - 4.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���������� ���������� 4')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.500.000$\n������� - 4.000.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'���������� ����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 2.000.000$\n������� - 3.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���� �������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 10.000.000$\n������� - 15.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 300.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'����-����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 300.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'����-����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 300.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.000.000$\n������� - 3.500.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'��� �� �����#1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 17.000.000$\n������� - 23.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��� �� �����#2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 17.000.000$\n������� - 23.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��� �� �����#3')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 17.000.000$\n������� - 23.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��� �� �����#4')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 10.000.000$\n������� - 14.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��� �� �����#5')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 10.000.000$\n������� - 14.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��� �� �����#6')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 10.000.000$\n������� - 14.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��� �� �����#7')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 10.000.000$\n������� - 14.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'��������� ������� �� ���������������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.000.000$\n������� - 3.000.000$')
		    imgui.EndTooltip()
		end
		
	imgui.Button(u8'��������� ������ �� ���������������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.000.000$\n������� - 3.000.000$')
		    imgui.EndTooltip()
		end
		
	imgui.Button(u8'��������� ������� �� ��������������� #1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.000.000$\n������� - 3.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ������� �� ��������������� #2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.000.000$\n������� - 3.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ���� �� ���������������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1.000.000$\n������� - 3.000.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'������ �����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'��������� ����� ��������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ����� ���������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ����� Marshmallow')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ����� ������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ����� ������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ����� ������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ����� �����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 700.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��������� ����� �����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 700.000$')
		    imgui.EndTooltip()
		end
		
	elseif menu == 230 then --------------------------�����
	imgui.Button(u8'����� ��������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 700.000$\n������� - 1.700.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'����� ����� � �������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 150.000$\n������� - 350.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'����� ����� �������������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 350.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'����� ����� �������� ��������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 350.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'����� ����� ��������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 350.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'���� MARVEL')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 175.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���� ����������� �����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 230.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���� ����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 600.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���� ����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 100.000$\n������� - 450.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���� ������������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 170.000$')
		    imgui.EndTooltip()
		end
		
	elseif menu == 226 then -------------------------��������� �������
	imgui.Button(u8'����� �� DEAGLE')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'������� �� DEAGLE')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end
		
	elseif menu == 2 then --------------------�����
	imgui.Button(u8'������ ����������� 1 � 432')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 400.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'������ ����������� 2 � 433')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 400.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'������ ����������� 3 � 434')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 400.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'������ ����������� 4 � 435')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 400.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'������ ����������� 5 � 436')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 400.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'������ ����������� 6 � 437')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 400.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'������ �������� ������� � 450')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 400.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'������ �������-���� � 451')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 400.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'������ ������ � 448')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 400.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'������ ������� ������� � 449')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 400.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'������ ����� � 452')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 400.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
--------------------------- ==9 �������		
	elseif menu == 9 then
	imgui.Button(u8'�������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 16.000$\n������� - 25.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8"�������")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 250$\n������� - 5.000$')
		    imgui.EndTooltip()
		end	
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8"�����")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 1000.$\n������� - 10.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8"���������")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 35.000$\n������� - 75.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8"������")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 4.000$\n������� - 13.000$')
		    imgui.EndTooltip()
		end			
	imgui.Button(u8"������")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 750.$\n������� - 3.500$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8"������")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 13.000$\n������� - 22.000$')
		    imgui.EndTooltip()
		end				
	imgui.Button(u8"�������")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 4.500$\n������� - 17.500$')
		    imgui.EndTooltip()
		end		
    imgui.Button(u8"������")
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 55.000$\n������� - 95.000$')
		    imgui.EndTooltip()
		end	
    imgui.Button(u8'��������� ������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 95.000$\n������� - 175.000$')
		    imgui.EndTooltip()
		end   		
	imgui.Button(u8'���������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 300$.\n������� - 1.500$.')
		    imgui.EndTooltip()
		end   
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500$\n������� - 1.500$')
		    imgui.EndTooltip()
		end   
	imgui.Button(u8'˸�')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500$\n������� - 1.500$')
		    imgui.EndTooltip()
		end   
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'��������� �������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 12.000$\n������� - 25.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���������� �������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 45.000$\n������� - 95.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'������� �������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 350.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end
    imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'������ ���������� ����� 24 ����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'����-����')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 500.000$')
		    imgui.EndTooltip()
		end
	imgui.Text(u8'---------------------------------------------')
	imgui.Button(u8'������ ������ ���')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 350.000$\n������� - 1.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'������ ���������� ���')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 250.000')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'���������� �������')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500$\n������� - 10.000')
		    imgui.EndTooltip()
		end
	elseif menu == 228 then
	----------imgui.Text(u8'�����:') imgui.SameLine() imgui.Link('https://vk.com/vharibo', u8' real vamp.')
	imgui.Text(u8'---------------------------------------------------------------------------')
	------------imgui.Text(u8'������� �����:') imgui.SameLine() imgui.Link('https://vk.com/vharibo', u8' �����.')
	imgui.Text(u8'--------------------------------------------------------------------------')
	imgui.Text(u8'��� �������� �� ���������� ������� ')
	imgui.Text(u8'����� � �������� ������')
	imgui.Text(u8'�� ������ ������ ������ �� � ������')
	imgui.Text(u8'������ ��� ���� �� ������� �����')
	imgui.Text(u8'!!!� ������� ������ ������� ������!!!')
	imgui.Text(u8'--------------------------------------------------------------------------')
        imgui.Text(u8'--------------------------------------------------------------------------')
	imgui.Text(u8'������ ������������� ��������� ����')
		imgui.Separator()
                imgui.SetCursorPos(imgui.ImVec2(70, 250))                      ---------dels
                imgui.Button(u8'���������� ����',imgui.ImVec2(155,85))             
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'29.07.2023\n10:30 ���')
		    imgui.EndTooltip()
		end	
		
	elseif menu == 127 then
	
	imgui.Text(u8'                     ����� �������� �����')
		imgui.Separator()
		
	imgui.SetCursorPos(imgui.ImVec2(40, 35))
    if imgui.Button(u8'��������',imgui.ImVec2(95,45)) then 
	    writeMemory(0x52C9EE, 1, 1, true)
        activation = true
		sampAddChatMessage(string.format("������ �����", thisScript().name, thisScript().version), -1)
	end
	
	imgui.SetCursorPos(imgui.ImVec2(175, 35))
	if imgui.Button(u8'���������',imgui.ImVec2(95,45)) then 
	    writeMemory(0x52C9EE, 1, 0, true)
        activation = false
		sampAddChatMessage(string.format("������ ����� ������ ���", thisScript().name, thisScript().version), -1)
	end

	
	elseif menu == 22 then 		
	if imgui.Button(u8'�������� ���') then 
	
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
	
	if imgui.Button(u8'������ gift �������������') then 
	    sampSendChat("/gift rodina300_3")
	end
	
	if imgui.Button(u8'������� ���������� � ��������') then
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
	
					
---------------------------------������
	elseif menu == 10 then	
	imgui.Button(u8'��� ������ SPORT')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 350.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end	
	imgui.Button(u8'��� ������ SPORT+')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 600.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'STAGE 1')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 75.000$\n������� - 1.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'STAGE 2')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 500.000$\n������� - 2.000.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'STAGE 3')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 2.500.000$\n������� - 5.500.000$')
		    imgui.EndTooltip()
		end
	imgui.Button(u8'��� ������ improv')
		if imgui.IsItemHovered() then
		    imgui.BeginTooltip()
		    imgui.Text(u8'���� - 50.000$\n������� - 275.000$')
		    imgui.EndTooltip()
		end
	

	-- ��������� -----
	elseif menu == 14 then
		-- ������ ��
		------------imgui.Text(u8'�� ������:') imgui.SameLine() imgui.Link('https://vk.com/vharibo', u8'real vamp.')
                ------------imgui.Text(u8'�������� �����:') imgui.SameLine() imgui.Link('https://vk.com/vharibo', u8'�����.')
		imgui.Separator()
	  	imgui.Text(u8' ����� ����:')
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
	imgui.SetCursorPos(imgui.ImVec2(13, 445)) ------------------ x y ������������ ������ ������
	if imgui.Button(u8'������ �����',imgui.ImVec2(135,45)) then --------
	    os.execute('start https://funpay.com/users/6332429/')
    end

        imgui.SetCursorPos(imgui.ImVec2(160, 445)) ------------------ x y ������������ ������ ������
	if imgui.Button(u8'�� ������',imgui.ImVec2(135,45)) then --------
	    os.execute('start https://vk.com/vharibo')
    end

    imgui.SetCursorPos(imgui.ImVec2(305, 445))
   	if imgui.Button(u8'�������',imgui.ImVec2(135,45)) then
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