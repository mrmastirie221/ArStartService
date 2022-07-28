require "lib.moonloader"

-- libs
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


-- help text
local help_text_in_menu = [[ Lavloria Team, - с нами, ты станешь богатым!
{FFFFFF}
Прежде чем ознакомиться с командами скрипта, рекомендую прочитать инструкцию по выживанию.
/readlive

Основные команды скрипта:

- Для получение денег. (подработки)
/pricelist - Список твоих услуг.
/moneyguys - Попросить денег.
/cleartap (желлаемая сумма) - Почистить обувь.
/clearsortir (желлаемая сумма) - Почистить туалеты. 
/clearwindow (желлаемая сумма) - Почистить стекло машины.
/giveice (желлаемая сумма) - Продать мороженко.

- Музыкальные функции (можешь спеть чтобы получить денег)
/smnbomj (громкость)
/slikeu (громкость)
/sgimn (громкость) - Патриотический гимн бомжей
/sdancin (громость)

- Прочее
/givepivo (id) - Угостить пивом.
/takebich - Закурить бычок с земли.
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

local update_script_news_in_menu = [[ {FF0000} Update 2 {FFFFFF}
1. Расширены тексты песен
2. Добавлены две новые песни. (Бомж, какое гордое слово, Dancin Korno Remix)
3. Добавлена возможность угостить пивом друга. by @NotFound https://www.blast.hk/members/466499/
4. Добавлен офицальный гимн, который вы будите слышать при авторизации, а так-же вы сможете спеть его /sgimn
5. Добавлена возможность закурить бычок с земли.
6. Пофикшены баги с командами работы.
7. Добавлена отыгровка работы мороженшика.
]]

local vajnoe_obyavlenie_for_gamers = [[{FFFFFF}Как мы знаем, очень много бомжей работают не только на обычных работах.
А например: Таксистом, трактористом, басткейтболистом, карьерийстом, сатанистом, гитаристом и т.д
В связи с этим событием, мы понимаем, что для всех этих работ нужны биндеры.
Я планирую их добавить в наш скрипт как аддоны, которые вы сможете скачать в настройках скрипта.
С вашей стороны прошу выразить свое мнение на эту тему. 
Это можно делать в тему с скриптом.
]]

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
	print(tag .. "Status: OK.")

	sampRegisterChatCommand('homeless', cmd_homeless)
	sampRegisterChatCommand('readlive', cmd_readlive)
	sampRegisterChatCommand('homeupdate', cmd_homeupdate)
	
	sampRegisterChatCommand('pricelist', cmd_pricelist)
	sampRegisterChatCommand('moneyguys', cmd_moneyguys)
	sampRegisterChatCommand('cleartap', cmd_cleartap)
	sampRegisterChatCommand('clearsortir', cmd_clearsortir)
	sampRegisterChatCommand('clearwindow', cmd_clearwindow)
	sampRegisterChatCommand('giveice', cmd_giveice)
	
	sampRegisterChatCommand('takebich', cmd_takebich)
	sampRegisterChatCommand('givepivo', cmd_givepivo)
	sampRegisterChatCommand('getmystonks', cmd_getmystonks)
	sampRegisterChatCommand('whomycar', cmd_whomycar)
	sampRegisterChatCommand('whomyskin', cmd_whomyskin)
	
	sampRegisterChatCommand('smnbomj', cmd_smnbomj)
	sampRegisterChatCommand('slikeu', cmd_slikeu)
	sampRegisterChatCommand('sgimn', cmd_sgimn)
	sampRegisterChatCommand('sdancin', cmd_sdancin)
	
	-- временное
	sampRegisterChatCommand('homelessband', cmd_homelessband)

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
	sampAddChatMessage(tag .. "Меню скрипта: /homeless, Посмотреть о новом обновлении: /homeupdate", -1)

	loadmymoney()
	
	wait(10000)
	msg("Если вы свободны прочтите объявление. {FF0000} /homelessband")
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
	if dialogId == 2 then
		local sound = loadAudioStream("https://github.com/mrmastirie221/SMT/blob/main/mods/bomjkakoegordoeslovo.mp3?raw=true")
		setAudioStreamState(sound, ev.PLAY)
		msg("Nice Day :D")
	end

	if dialogId == 1 then
		local sound = loadAudioStream("https://github.com/mrmastirie221/SMT/blob/main/mods/bomjkakoegordoeslovo.mp3?raw=true")
		setAudioStreamState(sound, ev.PLAY)
		msg("Nice Day :D")
	end
end

function cmd_homeless()
	sampShowDialog(21982193812, "I'm that homeless...", help_text_in_menu, "ОК", "Отмена", DIALOG_STYLE_MSGBOX)
end

function cmd_readlive()
	sampShowDialog(27812386182, "Пособие по выживанию для начинающих.", help_for_survival_in_menu, "OK", "Отмена", DIALOG_STYLE_MSGBOX) 
end

function cmd_homeupdate()
	sampShowDialog(24124286182, "Информация о обновлении", update_script_news_in_menu, "OK", "Отмена", DIALOG_STYLE_MSGBOX) 
end

function msg(text)
    sampAddChatMessage("[{FFCC66}I'm that homeless...{FFFFFF}] "..text , 0xFFFFFF)
end

function loadmymoney()
	currentmoney = getPlayerMoney(mynick)
	print("Start Money: " .. currentmoney)
end

function cmd_homelessband()
	sampShowDialog(2412124282, "Объявление", vajnoe_obyavlenie_for_gamers, "OK", "Отмена", DIALOG_STYLE_MSGBOX) 
end

-- command function 

function cmd_pricelist()
	lua_thread.create(function()
	
		sampSendChat("Я могу - Почистить обувь, помыть окно в машине, почистить туалет.")
		wait(1500)
		sampSendChat("Я так-же отлично пою, на выбор четыри песни. ")
		wait(1500)
		sampSendChat("Я имею при себе морожено разного вкуса, оно очень вкусное.")
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
		sampSendChat("С вас " .. arg1 .. " долларов")
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
		sampSendChat("С вас " .. arg1 .. " долларов")
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
		sampSendChat("С вас " .. arg1 .. " долларов")
	end)
end

function cmd_giveice(arg1)
	lua_thread.create(function()
		sampSendChat("/me достал из сумки холодильника мороженое")
		wait(1500)
		sampSendChat("/me дал мороженое покупателю")
		wait(1500)
		sampSendChat("/me закрыл сумку")
		wait(1500)
		sampSendChat("С вас " .. arg1 .. " долларов")
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

function cmd_givepivo(arg1)
	local targetnick = sampGetPlayerNickname(arg1)
	lua_thread.create(function()
		msg("Думаю, ему понравится пиво, хорошего вам отдыха.")
		sampSendChat("/me достал из сумки пиво")
		wait(1500)
		sampSendChat("/me передал пиво " .. targetnick)
		wait(1500)
		sampSendChat("Угощяйся бро")
	end)
end

function cmd_takebich()
	lua_thread.create(function()
		msg("Если не получится, попробуй /smoke")
		sampSendChat("/me нагнулся и взял бычок с земли ")
		wait(1500)
		sampSendChat("/me закурил бычок")
		wait(1500)
		sampSendChat("/smoke")
	end)
end

function cmd_smnbomj(arg)
	lua_thread.create(function()
	local sound = loadAudioStream("https://github.com/mrmastirie221/SMT/blob/main/mods/bomjsectorgaza.mp3?raw=true")
	print(tag .. "https://github.com/mrmastirie221/SMT/blob/main/mods/bomjsectorgaza.mp3?raw=true")
		setAudioStreamState(sound, ev.PLAY)
		setAudioStreamVolume(sound, arg)
		sampAddChatMessage(tag .. "1 second for start...", -1)
		sampAddChatMessage(tag .. "sektor_gaza_-_bomzh_zf.mp3", -1)
		sampAddChatMessage(tag .. "Для остановки музыки и слов используйте ctrl + r", -1)
		wait(1000)
	    local song1 =
        	[[Я копаюсь на помойках, как червяк
        	С детства жизнь моя наперекосяк
        	Канализационный люк — моя дверь
        	Но я счастлив по-своему, поверь
        	Двадцать лет назад сгорел родной мой дом
        	Документы, деньги, всё сгорело в нём
        	И теперь я побираюсь двадцать лет
        	Кому нужен старый никудышный дед?
			Я бычок подниму — горький дым затяну
			Покурю и полезу домой
			Не жалейте меня, я прекрасно живу
			Только кушать охота порой
			А я бычок подниму — горький дым затяну
			Люк открою — полезу домой
			Не жалейте меня, я прекрасно живу
			Только кушать охота порой
			Эй, ребята, как допьёте вы вино
			Мне бутылки вы оставьте заодно
			Пожалейте вы несчастного бомжу
			Я их в сумку аккуратно положу
			Отнесу я завтра их в приёмный пункт
			Мне за них 60 копеек отдадут
			Я куплю буханку хлеба и сырок
			Чтобы с голоду не протянуть мне ног
			Я бычок подниму — горький дым затяну
			Покурю и полезу домой
			Не жалейте меня, я прекрасно живу
			Только кушать охота порой
			А я бычок подниму — горький дым затяну
			Люк открою — полезу домой
			Не жалейте меня, я прекрасно живу
			Только кушать охота порой
			Ах, подайте, люди, мне ради Христа!
			Не мила мне жизнь, я от неё устал
			Помоги, прохожий милый, пятаком
			Сжалься надо мной, над бедным стариком!
			Ах, отпусти меня, товарищ старшина
			Я простой советский бомж, а не шпана
			Я не сделал ведь плохого никому
			Так за что меня берёте, не пойму?!
			Я бычок подниму — горький дым затяну
			Покурю и полезу домой
			Не жалейте меня, я прекрасно живу
			Только кушать охота порой
			А я бычок подниму — горький дым затяну
			Люк открою — полезу домой
			Не жалейте меня, я прекрасно живу
			Только кушать охота порой
			]]
		for line in string.gmatch(song1, "([^\n]+)") do
            sampSendChat('/s '..line)
            wait(3500)
        end
	end)
end

function cmd_slikeu(arg)
	lua_thread.create(function()
		local sound = loadAudioStream("https://github.com/mrmastirie221/SMT/blob/main/mods/hity-2022-post-malone-i-like-you-a-happier-song-with-doja-cat(mp3gid.me).mp3?raw=true")
		setAudioStreamState(sound, ev.PLAY)
		setAudioStreamVolume(sound, arg)
		print(tag .. "https://github.com/mrmastirie221/SMT/blob/main/mods/hity-2022-post-malone-i-like-you-a-happier-song-with-doja-cat(mp3gid.me).mp3?raw=true")
		sampAddChatMessage(tag .. "i-like-you-a-happier-song.mp3", -1)
		sampAddChatMessage(tag .. "9 second for start...", -1)
		sampAddChatMessage(tag .. "Для остановки музыки и слов используйте ctrl + r", -1)
		local song2 =
        [[Ooh, girl, I like you, I do
			I wanna be your friend, go shoppin' in a Benz
			I like you, I do
			I'll hit you when I land, can you fit me in your plans?
			I like you, I do
			We went over to France and we woke up in Japan
			I like you, I do (I do, mm, mm)
			Oh, girl, I know you only like it fancy (fancy)
			So I pull up in that Maybach Candy
			Yeah, your boyfriend'll never understand me (understand me)
			'Cause I'm 'bout to pull this girl like a hammy, hammy (wow)
			Let's take a lil' dip, lil' lady
			Hit PCH, one-eighty
			Hey, I've been thinkin' lately
			That I need someone to save me
			Now that I'm famous, I got hoes all around me
			But I need a good girl, I need someone to ground me
			So please be true, don't fuck around with me
			I need someone to share this heart with me
			Feel you up, then run it back again (run it back again)
			Ooh, girl, I like you, I do (I do)
			I wanna be your friend, go shoppin' in a Benz (woo)
			I like you, I do (I do)
			I'll hit you when I land, can you fit me in your plans?
			I like you, I do (mm, I do)
			We went over to France and we woke up in Japan
			I like you, I do (mm, mm, I do)
			Let me know when you're free
			'Cause I've been tryna hit it all week, babe
			Why you actin' all sweet?
			I know that you want lil' ol me
			I get a little OD
			But ain't shit new to a freak
			Lemme drop bands, put a jewel in your teeth
			He love the way I drip, turn that pool to the beach
			And I coulda copped the Birkin but I cop C?line
			Why we got the same taste for the finer things?
			Brand new nigga with the same old team
			Now he got me on a leash 'cause we said no strings
			You know I'm cool with that
			Stole the pussy, you ain't get sued for that (get sued, sued)
			Wonder what a nigga might do for that (do, might do)
			I could be your Chaka, where Rufus at? (Where?)
			Eighty in the Benz when the roof go back, ayy
			They don't wanna see us get too attached, ayy
			I just got a feelin' that we might be friends for a long, long time
			Your mine, and you know I like you for that
			Ooh, girl, I like you, I do (I do)
			I wanna be your friend, go shoppin' in a Benz
			I like you, I do (I do)
			I'll hit you when I land, can you fit me in your plans? (Fit me in your plans)
			I like you, I do (I do)
			We went over to France and we woke up in Japan
			I like you, I do (I do, mm, I do)
			I just want you, I just want you
			Your heart's so big but that ass is huge
			Just want you, oh baby
			Do you like me too? (Yeah, I like you too)
			Ooh, girl, I like you, I do (I do)
			I wanna be your friend, go shoppin' in a Benz
			I like you, I do (I do, mm, I do)
			I like you
			I wanna be your girlfriend, baby
			]]
        wait(9000)
        for line in string.gmatch(song2, "([^\n]+)") do
            sampSendChat('/s '..line)
            wait(3000)
        end
	end)
end

function cmd_sgimn(arg)
	lua_thread.create(function()
		local sound = loadAudioStream("https://github.com/mrmastirie221/SMT/blob/main/mods/bomjkakoegordoeslovo.mp3?raw=true")
		setAudioStreamState(sound, ev.PLAY)
		setAudioStreamVolume(sound, arg)
		print(tag .. "https://github.com/mrmastirie221/SMT/blob/main/mods/bomjkakoegordoeslovo.mp3?raw=true")
		sampAddChatMessage(tag .. "Бомж-какое-гордое-слово.mp3", -1)
		sampAddChatMessage(tag .. "1.5 second for start...", -1)
		sampAddChatMessage(tag .. "Для остановки музыки и слов используйте ctrl + r", -1)
		msg("гимн слушать стоя!")
		wait(1500)
		local song3 = [[ Бомж - Какое гордое слово
		Бомж - зайду сейчас я с основы
		Бомж - отдай скатина мой скутер
		Бомж - всех дмить так круто
		круто круто круто круто
		скутер скутер скутер круто
		круто круто скутер круто
		скутер!]]
        for line in string.gmatch(song3, "([^\n]+)") do
            sampSendChat('/s '..line)
        	wait(3000)
		end
	end)
end

function cmd_sdancin(arg)
	lua_thread.create(function()
		local sound = loadAudioStream("https://github.com/mrmastirie221/SMT/blob/main/mods/Aaron%20Smith,%20Luvli%20-%20Dancin%20(Krono%20Remix).mp3?raw=true")
		setAudioStreamState(sound, ev.PLAY)
		setAudioStreamVolume(sound, arg)
		print(tag .. "https://github.com/mrmastirie221/SMT/blob/main/mods/Aaron%20Smith,%20Luvli%20-%20Dancin%20(Krono%20Remix).mp3?raw=true")
		sampAddChatMessage(tag .. "Aaron Smith, Luvli - Dancin (Krono Remix).mp3", -1)
		sampAddChatMessage(tag .. "1.5 second for start...", -1)
		sampAddChatMessage(tag .. "Для остановки музыки и слов используйте ctrl + r", -1)
		wait(1500)
		local song4 = [[Get up on the floor
		Dancing all night long
		Get up on the floor
		Dancing 'til the break of dawn
		Get up on the floor
		Dancing 'til the break of dawn
		Get up on the floor
		Dancing
		All the time
		My baby, you're on my mind
		And I don't know why
		Yeah, but the feeling is fine
		Can't you see
		Honey you are for me, oh
		We were meant to be
		Dancing in the moonlight
		Gazing at the stars so bright
		Holding you until the sunrise
		Sleeping until the midnight
		Get up on the floor
		Dancing all night long
		Get up on the floor
		Dancing 'til the break of dawn
		Get up on the floor
		Dancing 'til the break of dawn
		Get up on the floor
		Dancing
		Dancing is what to do
		Dancing's when I think of you
		Dancing's what clears my soul
		Dancing's what makes me whole
		Dancing is what to do
		Dancing's when I think of you
		Dancing's what clears my soul
		Dancing's what makes me whole
		Every time when I look in your eyes
		I smile with pride, happy that you're mine
		Joy in love, your love is true I know
		You are the best thing that has happened to me
		Get up on the floor
		Dancing all night long
		Get up on the floor
		Dancing 'til the break of dawn
		Get up on the floor
		Dancing 'til the break of dawn
		Get up on the floor
		Dancing
		Dancing is what to do
		Dancing's when I think of you
		Dancing's what clears my soul
		Dancing's what makes me whole
		Dancing is what to do
		Dancing's when I think of you
		Dancing's what clears my soul
		Dancing's what makes me whole
		Get up on the floor
		Dancing all night long
		Get up on the floor
		Dancing 'til the break of dawn
		Get up on the floor
		Dancing 'til the break of dawn
		Get up on the floor
		Dancing (oh)
		Get up on the floor
		Dancing all night long
		Get up on the floor
		Dancing 'til the break of dawn
		Get up on the floor
		Dancing 'til the break of dawn
		Get up on the floor
		Dancing (oh)
		Dancing is what to do
		Dancing's when I think of you
		Dancing's what clears my soul
		Dancing's what makes me whole
		Dancing is what to do
		Dancing's when I think of you
		Dancing's what clears my soul
		Dancing's what makes me whole
		Dancing is what to do
		Dancing's when I think of you
		Dancing's what clears my soul
		Dancing's what makes me whole
		Dancing is what to do
		Dancing's when I think of you
		Dancing's what clears my soul
		Dancing's what makes me whole
		]]
		for line in string.gmatch(song4, "([^\n]+)") do
            sampSendChat('/s '..line)
        	wait(3000)
		end

	end)
end


-- music function

-- imgui

-- imgui

-- ВНИМАНИЕ! В КОД ВЛОЖЕНА ДУША!