require "lib.moonloader"
local sampev = require 'samp.events'
local inicfg = require 'inicfg'
local dlstatus = require("moonloader").download_status
local vkeys = require 'lib.vkeys'
local mainIni = inicfg.load({ Settings = { Button = "" } })
if inicfg.load(nil, "koords") == nil then inicfg.save(mainIni, "koords") end
local ini = inicfg.load(nil, "koords")
local updateIni = inicfg.load(nil, update_path)

update_state = false

local script_vers = 2
local script_vers_text = "1.01"

local update_url = "https://raw.githubusercontent.com/KirillCraft/script/main/update.ini"
local update_path = getWorkingDirectory() .. "/config/koords/update.ini"

local script_url = "https://github.com/KirillCraft/script/raw/main/koords.lua"
local script_path = thisScript().path

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
    sampRegisterChatCommand("but", button)
	
	downloadUrlToFile(update_url, update_path, function(id, status)

		 if status == dlstatus.STATUS_ENDDOWNLOADDATA then	
			updateIni = inicfg.load(nil, update_path)
			if tonumber(updateIni.update.vers) > script_vers then
				sampAddChatMessage("ОБНОВА", -1)
				update_state = true
			end
		 end
	end) 
    


    while true do
    wait(0)


	 if update_state then
		downloadUrlToFile(script_url, script_path_path, function(id, status)

			if status == dlstatus.STATUS_ENDDOWNLOADDATA then	
			   sampAddChatMessage("Скрипт успешно обновлен!", -1)
			   thisScript():reload()
			end
	   end) 
	   break
	 end

    if isKeyJustPressed(vkeys[ini.Settings.Button]) and not sampIsDialogActive() then
		pX, pY, pZ = getCharCoordinates(PLAYER_PED)
        sampSendChat("/fs Координаты LOX " .. math.floor(pX) .. " " .. math.floor(pY) .. " ".. math.floor(pZ))
   end


    end
end


function button()
    sampShowDialog(5834, "Настройка клавиши", "{FFFFFF}Нажмите на нужную клавишу", "ОК", "ОТМЕНА", 0)
							lua_thread.create(function()
								
								wait(100)
								local key = ""
								repeat
									wait(0)
									for k, v in pairs(vkeys) do
										if isKeyJustPressed(v) and k ~= "VK_ESCAPE" and k ~= "VK_RETURN" and k ~= "VK_LBUTTON" and k ~= "VK_RBUTTON" then 
											key = k 
										end
									end
								until key ~= "" 
								ini.Settings.Button = key
								inicfg.save(ini, "koords")
								wait(100)
								sampCloseCurrentDialogWithButton(0)
							end)	
end


function sampev.onServerMessage(color, text)
	if string.find(text, " %[Рация%] (.*) Координаты (.*) (.*) (.*)") then
		lua_thread.create(function()
			wait(100)
			local res, qqX, qqY, qqZ = text:match(" %[Рация%] (.*) Координаты (.*) (.*) (.*)")
			
	         --placeWaypoint(qX, qY, qZ)
             local blmet = addBlipForCoord(qqX, qqY, qqZ)
			 changeBlipColour(blmet, 0xFF4500FF)
			 wait(5000)
			 removeBlip(blmet)
			
							
		end)
	   
	end
end