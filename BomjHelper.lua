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
local help_text_in_menu = [[ Lavloria Team, - с нами, ты станешь богатым!
{FFFFFF}
Прежде чем ознакомиться с командами скрипта, рекомендую прочитать инструкцию по выживанию.
/readlive

Основные команды скрипта:

-- Для получение денег.
/pricelist - Список твоих услуг.
/moneyguys - Попросить денег.
/cleartap (желлаемая сумма) - Почистить обувь.
/clearsortir (желлаемая сумма) - Почистить туалеты. 
/clearwindow (желлаемая сумма) - Почистить стекло машины.

-- Музыкальные функции (можешь спеть чтобы получить денег)
/smnbomj (громкость)
/slikeu (громкость)


(Больше музыки в новых версиях.)

-- Прочее
/getmystonks - Посмотреть свой доход за текующую сессию.


{FF0000} ~! По ошибкам сообщяйте в тему на форуме.
]]

local help_for_survival_in_menu = [[ Lavloria Team, - с нами, ты станешь богатым!
{FF0000}Памятка для бомжа{FFFFFF}

Страница 01

Твоя жизнь будет не проста, а очень трудна, по этому это пособие должно помочь тебе.
Первое правило любого бомжа, это грамотно просить деньги. 
Словом "сер" никого не удивишь, уже не в моде, для просьбы денег есть более лучшее решение.
Попросить денег можно командой /moneyguys, там все сделают за тебя, просто улыбайся и будь хорошим.
Но ещё не все так просто, тебе нужно поплнять свою сытость, делай это только в ларьках, в закусочных дорого.
Вторым твоим способом заработка будет чистильще обуви. Есть агрессивный и пассивный метод. 
Пассивный - просто чистишь обувь за деньги, а агрессивный роняешь шетку по рп, тебе её поднимают
ты за это чистишь обувь, а затем просишь денег, если не дают, то при тебе всегда должен быть пистолет или лопата.
Но в начале врятли ты сможешь иметь оружие, по этому пользуйся пассивным.
Команды для чистки обуви: /cleartap
Так же ты можешь предлогать другим игрокам разные виды услуг, какие именно?
Посмотри в списке команд, там есть много работ.

На этом пока все, с новыми версиями обещяю дополнить эту статью.

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

	sampAddChatMessage(tag .. "Успешно загрузились, добро пожаловать домой, {FFCC66}" .. mynick, -1)
	sampAddChatMessage(tag .. "/homeless", -1)
	
	currentmoney = getPlayerMoney(mynick)
	print("Start Money: " .. currentmoney)
end

function cmd_homeless()
	main_window_state.v = not main_window_state.v 
	sampShowDialog(21982193812, "I'm that homeless...", help_text_in_menu, "ОК", "Отмена", DIALOG_STYLE_MSGBOX)
end

function cmd_readlive()
	sampShowDialog(27812386182, "Пособие по выживанию для начинающих.", help_for_survival_in_menu, "OK", "Отмена", DIALOG_STYLE_MSGBOX) 
end

-- command function 

function cmd_pricelist()
	lua_thread.create(function()
	
		sampSendChat("Я могу - Почистить обувь, помыть окно в машине, почистить туалет.")
		wait(1500)
		sampSendChat("Я так-же отлично пою, на выбор две песни. ")
		wait(1500)
		sampSendChat("Надеюсь вас заинтересует данные услуги.")
	
	end)
end

function cmd_moneyguys(arg1)
	lua_thread.create(function()
		sampSendChat("Здравствуйте, сэр.")
		wait(3000)
		sampSendChat("Я оказался в очень сложной ситуации, не могли вы бы помочь мне деньгами? ")
		wait(5000)
		sampSendChat("Если, да, то дайте сколько посчитаете нужным, или я могу оказать вам какую-то услугу. ")
		wait(3000)
		sampSendChat("Я умею чистить обувь, стоимость чистки - " .. arg1 .. " долларов.")
	end)
end

function cmd_cleartap(arg1)
	lua_thread.create(function()
		sampSendChat("/me достал из кармана тряпку с антисептиком")
		wait(1500)
		sampSendChat("/me пшыкнул антисептиком на обувь")
		wait(1500)
		sampSendChat("/me вытер обувь тярпкой")
		wait(1500)
		sampSendChat("/todo Все готово! С вас " .. arg .. "*убрав тряпу и антисептик")	
	end)
end

function cmd_clearsortir(arg1)
	lua_thread.create(function()
		sampSendChat("Сейчас почистим тогда.")
		wait(1500)
		sampSendChat("/me взял ёршик и средство для туалетов")
		wait(1500)
		sampSendChat("/me налил средство затем потер ёрщиком")
		wait(1500)
		sampSendChat("/me потер ерщиком, затем смыл нажав на крючок")
		wait(1500)
		sampSendChat("/todo Готово, с вас " .. arg1 .. "*убрав ершик.")
	end)
end

function cmd_clearwindow(arg1)
	lua_thread.create(function()
		sampSendChat("/me достал антисептик и тряпку")
		wait(1500)
		sampSendChat("/me пшыкнул антисептиком на стекло")
		wait(1500)
		sampSendChat("/me протер тряпкой стекло с антисептиком")
		wait(1500)
		sampSendChat("/todo С вас " .. arg1 .. "*убрав антисептик и тряпку")
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
	
	sampAddChatMessage(tag .. "За сессию вы заработали " .. "{5EEE0C}" .. result .. "${FF0000}", -1)
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
		sampSendChat("/s Я копаюсь на помойках, как червяк")
		wait(3000)
		sampSendChat("/s С детства жизнь моя наперекосяк")
		wait(3000)
		sampSendChat("/s Канализационный люк — моя дверь")
		wait(3000)
		sampSendChat("/s Но я счастлив по-своему, поверь")
		wait(3000)
		sampSendChat("/s Двадцать лет назад сгорел родной мой дом")
		wait(3000)
		sampSendChat("/s Документы, деньги, всё сгорело в нём")
		wait(3000)
		sampSendChat("/s И теперь я побираюсь двадцать лет")
		wait(3000)
		sampSendChat("/S Кому нужен старый никудышный дед?")
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
-- Больше музыки в новых версиях.

-- music function

-- imgui
		
-- imgui

-- ВНИМАНИЕ! В КОД ВЛОЖЕНА ДУША!