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
local help_text_in_menu = [[ Lavloria Team, - � ����, �� ������� �������!
{FFFFFF}
������ ��� ������������ � ��������� �������, ���������� ��������� ���������� �� ���������.
/readlive

�������� ������� �������:

- ��� ��������� �����. (����������)
/pricelist - ������ ����� �����.
/moneyguys - ��������� �����.
/cleartap (��������� �����) - ��������� �����.
/clearsortir (��������� �����) - ��������� �������. 
/clearwindow (��������� �����) - ��������� ������ ������.
/giveice (��������� �����) - ������� ���������.

- ����������� ������� (������ ����� ����� �������� �����)
/smnbomj (���������)
/slikeu (���������)
/sgimn (���������) - �������������� ���� ������
/sdancin (��������)

- ������
/givepivo (id) - �������� �����.
/takebich - �������� ����� � �����.
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

local update_script_news_in_menu = [[ {FF0000} Update 2 {FFFFFF}
1. ��������� ������ �����
2. ��������� ��� ����� �����. (����, ����� ������ �����, Dancin Korno Remix)
3. ��������� ����������� �������� ����� �����. by @NotFound https://www.blast.hk/members/466499/
4. �������� ���������� ����, ������� �� ������ ������� ��� �����������, � ���-�� �� ������� ����� ��� /sgimn
5. ��������� ����������� �������� ����� � �����.
6. ��������� ���� � ��������� ������.
7. ��������� ��������� ������ �����������.
]]

local vajnoe_obyavlenie_for_gamers = [[{FFFFFF}��� �� �����, ����� ����� ������ �������� �� ������ �� ������� �������.
� ��������: ���������, ������������, ����������������, ������������, ����������, ���������� � �.�
� ����� � ���� ��������, �� ��������, ��� ��� ���� ���� ����� ����� �������.
� �������� �� �������� � ��� ������ ��� ������, ������� �� ������� ������� � ���������� �������.
� ����� ������� ����� �������� ���� ������ �� ��� ����. 
��� ����� ������ � ���� � ��������.
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
	
	-- ���������
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

	sampAddChatMessage(tag .. "������� �����������, ����� ���������� �����, {FFCC66}" .. mynick, -1)
	sampAddChatMessage(tag .. "���� �������: /homeless, ���������� � ����� ����������: /homeupdate", -1)

	loadmymoney()
	
	wait(10000)
	msg("���� �� �������� �������� ����������. {FF0000} /homelessband")
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
	sampShowDialog(21982193812, "I'm that homeless...", help_text_in_menu, "��", "������", DIALOG_STYLE_MSGBOX)
end

function cmd_readlive()
	sampShowDialog(27812386182, "������� �� ��������� ��� ����������.", help_for_survival_in_menu, "OK", "������", DIALOG_STYLE_MSGBOX) 
end

function cmd_homeupdate()
	sampShowDialog(24124286182, "���������� � ����������", update_script_news_in_menu, "OK", "������", DIALOG_STYLE_MSGBOX) 
end

function msg(text)
    sampAddChatMessage("[{FFCC66}I'm that homeless...{FFFFFF}] "..text , 0xFFFFFF)
end

function loadmymoney()
	currentmoney = getPlayerMoney(mynick)
	print("Start Money: " .. currentmoney)
end

function cmd_homelessband()
	sampShowDialog(2412124282, "����������", vajnoe_obyavlenie_for_gamers, "OK", "������", DIALOG_STYLE_MSGBOX) 
end

-- command function 

function cmd_pricelist()
	lua_thread.create(function()
	
		sampSendChat("� ���� - ��������� �����, ������ ���� � ������, ��������� ������.")
		wait(1500)
		sampSendChat("� ���-�� ������� ���, �� ����� ������ �����. ")
		wait(1500)
		sampSendChat("� ���� ��� ���� �������� ������� �����, ��� ����� �������.")
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
		sampSendChat("� ��� " .. arg1 .. " ��������")
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
		sampSendChat("� ��� " .. arg1 .. " ��������")
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
		sampSendChat("� ��� " .. arg1 .. " ��������")
	end)
end

function cmd_giveice(arg1)
	lua_thread.create(function()
		sampSendChat("/me ������ �� ����� ������������ ���������")
		wait(1500)
		sampSendChat("/me ��� ��������� ����������")
		wait(1500)
		sampSendChat("/me ������ �����")
		wait(1500)
		sampSendChat("� ��� " .. arg1 .. " ��������")
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

function cmd_givepivo(arg1)
	local targetnick = sampGetPlayerNickname(arg1)
	lua_thread.create(function()
		msg("�����, ��� ���������� ����, �������� ��� ������.")
		sampSendChat("/me ������ �� ����� ����")
		wait(1500)
		sampSendChat("/me ������� ���� " .. targetnick)
		wait(1500)
		sampSendChat("�������� ���")
	end)
end

function cmd_takebich()
	lua_thread.create(function()
		msg("���� �� ���������, �������� /smoke")
		sampSendChat("/me �������� � ���� ����� � ����� ")
		wait(1500)
		sampSendChat("/me ������� �����")
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
		sampAddChatMessage(tag .. "��� ��������� ������ � ���� ����������� ctrl + r", -1)
		wait(1000)
	    local song1 =
        	[[� ������� �� ��������, ��� ������
        	� ������� ����� ��� �����������
        	��������������� ��� � ��� �����
        	�� � �������� ��-������, ������
        	�������� ��� ����� ������ ������ ��� ���
        	���������, ������, �� ������� � ��
        	� ������ � ��������� �������� ���
        	���� ����� ������ ���������� ���?
			� ����� ������� � ������� ��� ������
			������ � ������ �����
			�� ������� ����, � ��������� ����
			������ ������ ����� �����
			� � ����� ������� � ������� ��� ������
			��� ������ � ������ �����
			�� ������� ����, � ��������� ����
			������ ������ ����� �����
			��, ������, ��� ������� �� ����
			��� ������� �� �������� ������
			��������� �� ����������� �����
			� �� � ����� ��������� ������
			������ � ������ �� � ������� �����
			��� �� ��� 60 ������ �������
			� ����� ������� ����� � �����
			����� � ������ �� ��������� ��� ���
			� ����� ������� � ������� ��� ������
			������ � ������ �����
			�� ������� ����, � ��������� ����
			������ ������ ����� �����
			� � ����� ������� � ������� ��� ������
			��� ������ � ������ �����
			�� ������� ����, � ��������� ����
			������ ������ ����� �����
			��, �������, ����, ��� ���� ������!
			�� ���� ��� �����, � �� �� �����
			������, �������� �����, �������
			������� ���� ����, ��� ������ ��������!
			��, ������� ����, ������� ��������
			� ������� ��������� ����, � �� �����
			� �� ������ ���� ������� ������
			��� �� ��� ���� �����, �� �����?!
			� ����� ������� � ������� ��� ������
			������ � ������ �����
			�� ������� ����, � ��������� ����
			������ ������ ����� �����
			� � ����� ������� � ������� ��� ������
			��� ������ � ������ �����
			�� ������� ����, � ��������� ����
			������ ������ ����� �����
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
		sampAddChatMessage(tag .. "��� ��������� ������ � ���� ����������� ctrl + r", -1)
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
		sampAddChatMessage(tag .. "����-�����-������-�����.mp3", -1)
		sampAddChatMessage(tag .. "1.5 second for start...", -1)
		sampAddChatMessage(tag .. "��� ��������� ������ � ���� ����������� ctrl + r", -1)
		msg("���� ������� ����!")
		wait(1500)
		local song3 = [[ ���� - ����� ������ �����
		���� - ����� ������ � � ������
		���� - ����� ������� ��� ������
		���� - ���� ����� ��� �����
		����� ����� ����� �����
		������ ������ ������ �����
		����� ����� ������ �����
		������!]]
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
		sampAddChatMessage(tag .. "��� ��������� ������ � ���� ����������� ctrl + r", -1)
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

-- ��������! � ��� ������� ����!