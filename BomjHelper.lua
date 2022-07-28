require "lib.moonloader"

-- libs
local imgui = require 'imgui'
local ev = require "moonloader".audiostream_state
local keys = require "vkeys"
local sampev = require 'lib.samp.events'
local encoding = require 'encoding'

-- info
local maincolor = 0xFFCC66
local error_color = 0xFF0000
local tag = "{FFFFFF}[{FFCC66}I'm that homeless...{FFFFFF}] "

-- stats
local onspawned = false
local offspawnchecker = true

local currentmoney = 0
local nowmymoney = 0

-- imgui
encoding.default = 'CP1251'
u8 = encoding.UTF8

-- sounds


local main_window_state = imgui.ImBool(false)

-- help text
local help_text_in_menu = [[ Lavloria Team, - � ����, �� ������� �������!
{FFFFFF}
������ ��� ������������ � ��������� �������, ���������� ��������� ���������� �� ���������.
/readlive

�������� ������� �������:

-- ��� ��������� �����.
/pricelist - ������ ����� �����.
/moneyguys - ��������� �����.
/cleartap (��������� �����) - ��������� �����.
/clearsortir (��������� �����) - ��������� �������. 
/clearwindow (��������� �����) - ��������� ������ ������.

-- ����������� ������� (������ ����� ����� �������� �����)
/smnbomj (���������)
/slikeu (���������)


(������ ������ � ����� �������.)

-- ������
/getmystonks - ���������� ���� ����� �� �������� ������.


{FF0000} ~! �� ������� ��������� � ���� �� ������.
]]

local help_for_survival_in_menu = [[ Lavloria Team, - � ����, �� ������� �������!
{FF0000}������� ��� �����{FFFFFF}

�������� 01

���� ����� ����� �� ������, � ����� ������, �� ����� ��� ������� ������ ������ ����.
������ ������� ������ �����, ��� �������� ������� ������. 
������ "���" ������ �� �������, ��� �� � ����, ��� ������� ����� ���� ����� ������ �������.
��������� ����� ����� �������� /moneyguys, ��� ��� ������� �� ����, ������ �������� � ���� �������.
�� ��� �� ��� ��� ������, ���� ����� �������� ���� �������, ����� ��� ������ � �������, � ���������� ������.
������ ����� �������� ��������� ����� ��������� �����. ���� ����������� � ��������� �����. 
��������� - ������ ������� ����� �� ������, � ����������� ������� ����� �� ��, ���� � ���������
�� �� ��� ������� �����, � ����� ������� �����, ���� �� ����, �� ��� ���� ������ ������ ���� �������� ��� ������.
�� � ������ ������ �� ������� ����� ������, �� ����� ��������� ���������.
������� ��� ������ �����: /cleartap
��� �� �� ������ ���������� ������ ������� ������ ���� �����, ����� ������?
�������� � ������ ������, ��� ���� ����� �����.

�� ���� ���� ���, � ������ �������� ������ ��������� ��� ������.

]]

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
	print(tag .. "Status: OK.")

	sampRegisterChatCommand('homeless', cmd_homeless)
	sampRegisterChatCommand('readlive', cmd_readlive)
	
	sampRegisterChatCommand('pricelist', cmd_pricelist)
	sampRegisterChatCommand('moneyguys', cmd_moneyguys)
	sampRegisterChatCommand('cleartap', cmd_cleartap)
	sampRegisterChatCommand('clearsortir', cmd_clearsortir)
	sampRegisterChatCommand('clearwindow', cmd_clearwindow)
	
	sampRegisterChatCommand('getmystonks', cmd_getmystonks)
	sampRegisterChatCommand('whomycar', cmd_whomycar)
	sampRegisterChatCommand('whomyskin', cmd_whomyskin)
	
	--sampRegisterChatCommand('stopplay', cmd_stopplay)
	sampRegisterChatCommand('smnbomj', cmd_smnbomj)
	sampRegisterChatCommand('slikeu', cmd_slikeu)
	--sampRegisterChatCommand('mysoundplay', cmd_mysoundplay)
	
	
	
	while true do
		wait(500)
		
		local _, myid = sampGetPlayerIdByCharHandle(playerPed)
		mynick = sampGetPlayerNickname(myid)
		
		onspawned = sampIsLocalPlayerSpawned()
	
		if onspawned then
			if offspawnchecker == true then			
				sayhello()
				offspawnchecker = false
			end
			
			return
		end
		
		
    end
end

function sayhello()
	local _, myid = sampGetPlayerIdByCharHandle(playerPed)
	mynick = sampGetPlayerNickname(myid)

	sampAddChatMessage(tag .. "������� �����������, ����� ���������� �����, {FFCC66}" .. mynick, -1)
	sampAddChatMessage(tag .. "/homeless", -1)
	
	currentmoney = getPlayerMoney(mynick)
	print("Start Money: " .. currentmoney)
end

function cmd_homeless()
	main_window_state.v = not main_window_state.v 
	sampShowDialog(21982193812, "I'm that homeless...", help_text_in_menu, "��", "������", DIALOG_STYLE_MSGBOX)
end

function cmd_readlive()
	sampShowDialog(27812386182, "������� �� ��������� ��� ����������.", help_for_survival_in_menu, "OK", "������", DIALOG_STYLE_MSGBOX) 
end

-- command function 

function cmd_pricelist()
	lua_thread.create(function()
	
		sampSendChat("� ���� - ��������� �����, ������ ���� � ������, ��������� ������.")
		wait(1500)
		sampSendChat("� ���-�� ������� ���, �� ����� ��� �����. ")
		wait(1500)
		sampSendChat("������� ��� ������������ ������ ������.")
	
	end)
end

function cmd_moneyguys(arg1)
	lua_thread.create(function()
		sampSendChat("������������, ���.")
		wait(3000)
		sampSendChat("� �������� � ����� ������� ��������, �� ����� �� �� ������ ��� ��������? ")
		wait(5000)
		sampSendChat("����, ��, �� ����� ������� ���������� ������, ��� � ���� ������� ��� �����-�� ������. ")
		wait(3000)
		sampSendChat("� ���� ������� �����, ��������� ������ - " .. arg1 .. " ��������.")
	end)
end

function cmd_cleartap(arg1)
	lua_thread.create(function()
		sampSendChat("/me ������ �� ������� ������ � ������������")
		wait(1500)
		sampSendChat("/me ������� ������������ �� �����")
		wait(1500)
		sampSendChat("/me ����� ����� �������")
		wait(1500)
		sampSendChat("/todo ��� ������! � ��� " .. arg .. "*����� ����� � ����������")	
	end)
end

function cmd_clearsortir(arg1)
	lua_thread.create(function()
		sampSendChat("������ �������� �����.")
		wait(1500)
		sampSendChat("/me ���� ����� � �������� ��� ��������")
		wait(1500)
		sampSendChat("/me ����� �������� ����� ����� �������")
		wait(1500)
		sampSendChat("/me ����� �������, ����� ���� ����� �� ������")
		wait(1500)
		sampSendChat("/todo ������, � ��� " .. arg1 .. "*����� �����.")
	end)
end

function cmd_clearwindow(arg1)
	lua_thread.create(function()
		sampSendChat("/me ������ ���������� � ������")
		wait(1500)
		sampSendChat("/me ������� ������������ �� ������")
		wait(1500)
		sampSendChat("/me ������ ������� ������ � ������������")
		wait(1500)
		sampSendChat("/todo � ��� " .. arg1 .. "*����� ���������� � ������")
	end)
end

-- command function

-- other function 

function cmd_getmystonks()
	local _, myid = sampGetPlayerIdByCharHandle(playerPed)
	mynick = sampGetPlayerNickname(myid)
	
	local result = 0
	
	nowmymoney = getPlayerMoney(mynick)
	result = nowmymoney - currentmoney
	
	sampAddChatMessage(tag .. "�� ������ �� ���������� " .. "{5EEE0C}" .. result .. "${FF0000}", -1)
end

function cmd_whomycar()

end

function cmd_whomyskin()

end

-- other function

-- music function 

--function cmd_stopplay()
--	setAudioStreamState(audio, ev.PAUSE)
--end

function cmd_smnbomj(arg)
	lua_thread.create(function()
	local sound = loadAudioStream("https://github.com/mrmastirie221/SMT/blob/main/mods/1531506626_sektor_gaza_-_bomzh_zf.fm.mp3?raw=true")
	print(tag .. "https://github.com/mrmastirie221/SMT/blob/main/mods/1531506626_sektor_gaza_-_bomzh_zf.fm.mp3?raw=true")
		setAudioStreamState(sound, ev.PLAY)
		setAudioStreamVolume(sound, arg)
		sampAddChatMessage(tag .. "17 second for start...", -1)
		sampAddChatMessage(tag .. "sektor_gaza_-_bomzh_zf", -1)
		wait(17000)
		sampSendChat("/s � ������� �� ��������, ��� ������")
		wait(3000)
		sampSendChat("/s � ������� ����� ��� �����������")
		wait(3000)
		sampSendChat("/s ��������������� ��� � ��� �����")
		wait(3000)
		sampSendChat("/s �� � �������� ��-������, ������")
		wait(3000)
		sampSendChat("/s �������� ��� ����� ������ ������ ��� ���")
		wait(3000)
		sampSendChat("/s ���������, ������, �� ������� � ��")
		wait(3000)
		sampSendChat("/s � ������ � ��������� �������� ���")
		wait(3000)
		sampSendChat("/S ���� ����� ������ ���������� ���?")
	end)
end

function cmd_slikeu(arg)
	lua_thread.create(function()
		local sound = loadAudioStream("https://github.com/mrmastirie221/SMT/blob/main/mods/hity-2022-post-malone-i-like-you-a-happier-song-with-doja-cat(mp3gid.me).mp3?raw=true")
		setAudioStreamState(sound, ev.PLAY)
		setAudioStreamVolume(sound, arg)
		print(tag .. "https://github.com/mrmastirie221/SMT/blob/main/mods/hity-2022-post-malone-i-like-you-a-happier-song-with-doja-cat(mp3gid.me).mp3?raw=true")
		sampAddChatMessage(tag .. "i-like-you-a-happier-song", -1)
		sampAddChatMessage(tag .. "9 second for start...", -1)
		wait(9000)
		sampSendChat("/s Ooh, girl, I like you, I do")
		wait(3000)
		sampSendChat("/s I wanna be your friend, go shoppin' in a Benz")
		wait(3000)
		sampSendChat("/s I like you, I do")
		wait(1500)
		sampSendChat("/s I'll hit you when I land, can you fit me in your plans?")
		wait(2000)
		sampSendChat("/s I like you, I do")
		wait(2500)
		sampSendChat("/s We went over to France and we woke up in Japan")
		wait(2500)
		sampSendChat("/s I like you, I do")
	end)
end

--function cmd_mysoundplay(arg)
--	local sound = loadAudioStream(arg)
--	setAudioStreamState(sound, ev.PLAY)
--  setAudioStreamVolume(sound, arg)
--	print(tag .. arg)
--	sampAddChatMessage(tag .. "Start: " .. arg, -1)
--end
--
-- ������ ������ � ����� �������.

-- music function

-- imgui
		
-- imgui

-- ��������! � ��� ������� ����!