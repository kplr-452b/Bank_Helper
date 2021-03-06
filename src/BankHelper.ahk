/*
	BANK HELPER
	Author: kplr-452b (https://vk.com/kplr452b)
	
	Copyright 2021 Rodina Helper`s

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

#SingleInstance, force
#NoEnv
#Persistent
#UseHook

; SAMP UDF (R3) by kplr-452b
#Include %A_ScriptDir%\lib\memory.ahk
#Include %A_ScriptDir%\lib\game.ahk
#Include %A_ScriptDir%\lib\chat.ahk
#Include %A_ScriptDir%\lib\local_player.ahk
#Include %A_ScriptDir%\lib\remote_player.ahk
#Include %A_ScriptDir%\lib\dialog.ahk
#Include %A_ScriptDir%\lib\audio.ahk

; Данные
global version_build := 1
global version_date := "01.01.2021"
global server_url_update := "https://github.com/kplr-452b/Bank_Helper/raw/main/BankHelper/update.ini"
global name := "Максим"
global firstname := "Чекистов"
global rang := "Охранник"
global tag := "О"
global autoscreen := 0
global server := "Центральный округ"
global server_folder := "Central_District"
global BlockInChat := 0
global radioOn := 0
global sex := "Мужской"
global plrSex := []

; Хоткеи
global key_welcome := Numpad0
global key_alert := Numpad1
global key_lecture_dress := Numpad2
global key_lecture_eti := Numpad3
global key_lecture_rule := Numpad4
global key_lecture_sub := Numpad5
global key_lecture_drugs := Numpad6
global key_sobes := Numpad7
global key_menu := Numpad8
global key_report := Numpad9
global key_quickmenu := !1
global key_bankmenu := !2

; Цвета
global COLOR_RODINA_CAPTION := "{DE1439}"
global COLOR_BLUE := 0x2849DB

global targedID := -1

/*
	Загрузка клавиш из конфигурации
*/
loadHotkeys:
{
	IniRead, key_welcome, %A_ScriptDir%\BankHelper\config.ini, Keys, key_welcome
	IniRead, key_alert, %A_ScriptDir%\BankHelper\config.ini, Keys, key_alert
	IniRead, key_lecture_dress, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_dress
	IniRead, key_lecture_eti, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_eti
	IniRead, key_lecture_rule, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_rule
	IniRead, key_lecture_sub, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_sub
	IniRead, key_lecture_drugs, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_drugs
	IniRead, key_sobes, %A_ScriptDir%\BankHelper\config.ini, Keys, key_sobes
	IniRead, key_menu, %A_ScriptDir%\BankHelper\config.ini, Keys, key_menu
	IniRead, key_report, %A_ScriptDir%\BankHelper\config.ini, Keys, key_report
	IniRead, key_quickmenu, %A_ScriptDir%\BankHelper\config.ini, Keys, key_quickmenu
	IniRead, key_bankmenu, %A_ScriptDir%\BankHelper\config.ini, Keys, key_bankmenu
	
	Hotkey, %key_welcome%, Off, UseErrorLevel
    Hotkey, %key_welcome%, Active1, On, UseErrorLevel
	
	Hotkey, %key_alert%, Off, UseErrorLevel
    Hotkey, %key_alert%, Active2, On, UseErrorLevel
	
	Hotkey, %key_lecture_dress%, Off, UseErrorLevel
    Hotkey, %key_lecture_dress%, Active3, On, UseErrorLevel
	
	Hotkey, %key_lecture_eti%, Off, UseErrorLevel
    Hotkey, %key_lecture_eti%, Active4, On, UseErrorLevel
	
	Hotkey, %key_lecture_rule%, Off, UseErrorLevel
    Hotkey, %key_lecture_rule%, Active5, On, UseErrorLevel
	
	Hotkey, %key_lecture_sub%, Off, UseErrorLevel
    Hotkey, %key_lecture_sub%, Active6, On, UseErrorLevel
	
	Hotkey, %key_lecture_drugs%, Off, UseErrorLevel
    Hotkey, %key_lecture_drugs%, Active7, On, UseErrorLevel
	
	Hotkey, %key_sobes%, Off, UseErrorLevel
    Hotkey, %key_sobes%, Active8, On, UseErrorLevel
	
	Hotkey, %key_menu%, Off, UseErrorLevel
    Hotkey, %key_menu%, Active9, On, UseErrorLevel
	
	Hotkey, %key_report%, Off, UseErrorLevel
    Hotkey, %key_report%, Active10, On, UseErrorLevel
	
	Hotkey, %key_quickmenu%, Off, UseErrorLevel
    Hotkey, %key_quickmenu%, Active11, On, UseErrorLevel
	
	Hotkey, %key_bankmenu%, Off, UseErrorLevel
    Hotkey, %key_bankmenu%, Active12, On, UseErrorLevel
}

/*
	Загрузка данных из конфигурации
*/
loadData:
{
	IniRead, name, %A_ScriptDir%\BankHelper\config.ini, User, name
	IniRead, firstname, %A_ScriptDir%\BankHelper\config.ini, User, firstname
	IniRead, rang, %A_ScriptDir%\BankHelper\config.ini, User, rang
	IniRead, tag, %A_ScriptDir%\BankHelper\config.ini, User, tag
	IniRead, autoscreen, %A_ScriptDir%\BankHelper\config.ini, User, autoscreen
	IniRead, server, %A_ScriptDir%\BankHelper\config.ini, User, server
	IniRead, BlockInChat, %A_ScriptDir%\BankHelper\config.ini, User, blockinchat
	IniRead, sex, %A_ScriptDir%\BankHelper\config.ini, User, sex
	
	if (server == "ERROR")
	{
		server = Центральный округ
	}
	if (sex == "ERROR")
	{
		server = Мужской
	}
	if (sex == "Женский")
	{
		plrSex[1] := "а"
		plrSex[2] := "ла"
	}		
	else
	{
		plrSex[1] := ""
		plrSex[2] := ""
	}
	
	SetTimer, onLoad, 1000
	return
}


#IfWinActive GTA:SA:MP
/*
	Инитилизация
*/
onLoad:
{
	if (IsSAMPAvailable())
	{
		IniRead, temp_value, %A_ScriptDir%\BankHelper\update.ini, Main, build
		version_build = %temp_value%
		IniRead, temp_value, %A_ScriptDir%\BankHelper\update.ini, Main, version
		version_date = %temp_value%
		
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Bank Helper успешно загружен. Используемая версия от " version_date ".")
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Чтобы открыть главное меню введите: /bh.")
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Разработчик Maxim_Chekistov & Dmitriy_Hawk.")
		
		URLDownloadToFile, %server_url_update%, %A_Temp%\update.ini
		IniRead, UpdateBuild, %A_Temp%\update.ini, Main, build
		IniRead, UpdateVersion, %A_Temp%\update.ini, Main, version
		if UpdateBuild > % version_build
		{
			addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Вышло обновление от " UpdateVersion ".")
			addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Чтобы обновиться зайдите в настройки и нажмите 'Обновить'.")
		}
		
		CMD.Register("expel", "Binder_expel")
		CMD.Register("lecture", "Binder_lecture")
		CMD.Register("sob", "sobesSystem")
		CMD.Register("rule", "Binder_rule")
		CMD.Register("gg", "Binder_welcome")
		CMD.Register("leaders", "Binder_leaders")
		CMD.Register("zams", "Binder_zams")
		CMD.Register("armour", "Binder_armour")
		CMD.Register("mask", "Binder_mask")
		CMD.Register("r", "Binder_radio")
		CMD.Register("bug", "Binder_bug")
		CMD.Register("bh", "Binder_menu")
		CMD.Register("exit", "Binder_exit")
		CMD.Register("docs", "Binder_docs")
		CMD.Register("showpass", "Binder_showpass")
		CMD.Register("pass", "Binder_showpass")
		CMD.Register("showmc", "Binder_showmc")
		CMD.Register("showlic", "Binder_showlic")
		CMD.Register("lic", "Binder_showlic")
		CMD.Register("gps", "Binder_gps")
		CMD.Register("post", "Binder_post")
		CMD.Register("dropgun", "Binder_dropgun")
		CMD.Register("fwarn", "Binder_fwarn")
		CMD.Register("unfwarn", "Binder_unfwarn")
		CMD.Register("fmute", "Binder_fmute")
		CMD.Register("funmute", "Binder_funmute")
		CMD.Register("blacklist", "Binder_blacklist")
		CMD.Register("unblacklist", "Binder_unblacklist")
		CMD.Register("uninvite", "Binder_uninvite")
		CMD.Register("clear", "Binder_clearchat")
		
		if (InStr(server, "Центральный округ"))
			server_folder = Central_District
		if (InStr(server, "Южный округ"))
			server_folder = Southern_District
		if (InStr(server, "Северный округ"))
			server_folder = Northern_District
		if (InStr(server, "Восточный округ"))
			server_folder = Eastern_District
		
		SetTimer, onLoad, off
		SetTimer, plrTick, 100
		return
	}
}

/*
	Репорт система
*/
global proxy := "https://vk-api-proxy.xtrafrancyz.net/_/"
global token := "7c4172941fa3419942d883920cc73344b9d1b56b4810b5867b53c2e446eb33339e6188bf7e4339520d9df"
global HTTP := ComObjCreate("WinHTTP.WinHTTPRequest.5.1")

vk_report(textvk)
{
	vkid := "2000000002"
	text := RegExReplace(text, "%", "%25")
	text := RegExReplace(text, "\+", "%2B")
	text := RegExReplace(text, "#", "%23")
	text := RegExReplace(text, "&", "%26")
	text := RegExReplace(text, "`n", "%0A")
	HTTP.Open("GET", proxy "api.vk.com/method/messages.send?peer_id=" vkid "&message=" textvk "&v=5.52&access_token=" token)
	try
		HTTP.Send()
	return
}


/*
	Функции
*/

AScreen()
{
	sendChat("/time")
	sleep, 1000
	SendInput,{F8}
	return
}

playLecture(index)
{
	IfNotExist, %A_ScriptDir%\BankHelper\server\lectures\%index%.txt
		return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Лекция №" index " не существует.")
	
	sleep, 250
	
	time_lecture := 1500
	name_lecture := ""
	Loop, read, %A_ScriptDir%\BankHelper\server\lectures\%index%.txt
	{
		if (A_Index == 1)
			time_lecture = %A_LoopReadLine%
		else if(A_Index == 2)
			name_lecture = %A_LoopReadLine%
		else
		{
			sendChat(A_LoopReadLine)
			sleep, %time_lecture%
		}
	}
	
	if (autoscreen)
		AScreen()
	
	return
}

sobesSystem()
{
	sendChat("/todo Здравствуйте меня зовут «" name " " firstname "»*на груди весит бейджик «" rang "»")
	sleep, 2000
	sendChat("Вы пришли к нам на собеседование?")
	sleep, 1000
	addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Нажмите: 1 - продолжить, 2 - закончить")
	while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
        continue
	if (GetKeyState("1", "P"))
	{
		sendChat("Отлично, покажите мне Ваши документы, а именно паспорт, лицензии и мед.карта.")
		sleep, 2000
		sendChat("/b /showpass - паспорт, /showlic - лицензии, /showmc - мед.карта, отыгрывая РП.")
		sleep, 1000
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Нажмите: 1 - продолжить, 2 - закончить")
		while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
			continue
		if (GetKeyState("1", "P"))
		{
			sendChat("/me взял" plrSex[1] " документы.")
			sleep, 2000
			sendChat("/do Документы в руках.")
			sleep, 2000
			sendChat("/me проверив документы, передал" plrSex[1] " человеку напротив.")
			sleep, 1000
			addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Нажмите: 1 - продолжить, 2 - закончить")
			while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
				continue
			if (GetKeyState("1", "P"))
			{
				sendChat("Проверим ваши навыки владения дубинкой.")
				sleep, 2000
				sendChat("/do Дубинка на столе.")
				sleep, 2000
				sendChat("/me взяв дубинку со стола передал" plrSex[1] " ее человеку напротив.")
				sleep, 2000
				sendChat("Теперь передайте ее мне.")
				sleep, 1000
				addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Нажмите: 1 - продолжить, 2 - закончить")
				while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
					continue
				if (GetKeyState("1", "P"))
				{
					sendChat("Отлично.")
					sleep, 2000
					sendChat("/me взял" plrSex[1] " дубинку у человека напротив, после чего положил" plrSex[1] " ее на стол.")
					sleep, 2000
					sendChat("/do Дубинка на столе.")
					sleep, 2000
					sendChat("Перейдем к физ-культурным нормативам.")
					sleep, 2000
					sendChat("Присядьте 5 раз и пробегите с этого места до конца зала.")
					sleep, 1000
					addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Нажмите: 1 - принять, 2 - отказать")
					while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
						continue
					if (GetKeyState("1", "P"))
					{
						sendChat("/todo Отлично..*расставляя галочки")
						sleep, 2000
						sendChat("Вы приняты на стажировку.")
						sleep, 2000
						sendChat("/do Под столом лежит пакет с формой и рацией.")
						sleep, 2000
						sendChat("/me достал" plrSex[1] " пакет и передал" plrSex[1] " человеку напротив")
						return
					}
					if (GetKeyState("2", "P"))
					{
						sendChat("Отказ. По причине: проф. непригодность.")
						return
					}
				}
				if (GetKeyState("2", "P"))
					return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Вы закончили собеседование.")
			}
			if (GetKeyState("2", "P"))
				return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Вы закончили собеседование.")
		}
		if (GetKeyState("2", "P"))
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Вы закончили собеседование.")
	}
	if (GetKeyState("2", "P"))
		return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Вы закончили собеседование.")
}

getPost()
{
	if (isPlayerInRangeOfPoint(596.6375, 593.9875, 1101.0000, 1))
		return 1
	else if (isPlayerInRangeOfPoint(603.8046, 593.9819, 1101.0000, 1))
		return 2
	else if (isPlayerInRangeOfPoint(610.5073, 605.9998, 1101.0000, 1))
		return 3
	else if (isPlayerInRangeOfPoint(604.6649, 618.2634, 1101.0000, 1))
		return 4
	else if (isPlayerInRangeOfPoint(600.0452, 626.7363, 1096.3594, 1))
		return 5
	else if (isPlayerInRangeOfPoint(610.9664, 609.9462, 1101.0000, 1))
		return 6
	else if (isPlayerInRangeOfPoint(594.4828, 622.6066, 1106.0078, 1))
		return 7
	else if (isPlayerInRangeOfPoint(605.1591, 622.6071, 1106.0078, 1))
		return 8
	else
	{
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Займите пожалуйста пост.")
		return -1 
	}
}

/*
	Команды
*/

Binder_clearchat()
{
	Loop, 30
		addChatMessageEx(0xFFFFFF, "")
	return
}

Binder_welcome()
{
	sendChat("/todo Здравствуйте меня зовут «" name " " firstname "»*на груди весит бейджик «" rang "»")
	sleep, 1500
	sendChat("Чем могу быть любезен" plrSex[1] "?")
	return
}

Binder_menu()
{
	openDialog(1)
	return
}

Binder_Exit()
{
	addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Хелпер успешно завершен. Чтобы запустить перезайдите в игру.")
	ExitApp
}

Binder_expel(id)
{
	if (id >= 0 and id < SAMP_MAX_PLAYERS)
	{
		sleep, 3000
		sendChat("/me накидывается на нарушителя и пытается заломать ему руки.")
		sleep, 3000
		sendChat("/me крепко держа нарушителя за руки, выводит его на улицу.")
	}
	return
}

Binder_lecture(index)
{
	if (index > 0 and index < 6)
	{
		playLecture(index)
	}
	else
	{
		return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Команда должна быть вида: /lecture [1-5]")
	}
}

Binder_rule(index)
{
	if (index > 0)
	{
		IniRead value, %A_ScriptDir%\BankHelper\server\%server_folder%\charter.ini, Main, %index%
		if (value != "ERROR")
		{
			value := Utf8ToAnsi(value)
			rule_text := []
			if (StrLen(value) > 100)
			{
				rule_text.Push(SubStr(value, 1, 100))
				rule_text.Push(SubStr(value, 101, StrLen(value) - 100))
			}
			else
				rule_text.Push(value)
			for i, stext in rule_text
				addChatMessageEx(COLOR_BLUE, "[Bank Helper]: " index " " stext)
		}
	}
	else
	{
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Команда должна быть вида: /rule [номер]")
	}
	return
}

Binder_radio(words*)
{
	Loop % words.Length()
		String .= Words[A_Index] " "
	if (String > 0)
	{
		sendChat("/do Cообщил" plrSex[1] " что-то по рации.")
		sleep 2000
		sendChat("/me повесил" plrSex[1] " рацию на пояс.")
		sleep 1600
		sendChat("/do Рация на поясе.")
	}
	return
}

Binder_bug(words*)
{
	Loop % words.Length()
		String .= words[A_Index] " "
	if (String > 0)
	{
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Вы отправили сообщение об ошибке разработчикам.")
		vk_report("[Bank Helper] [" getUsername() " (" rang ")]:%0A• " String "%0A%0A@dmitriy_hawk, @kplr452b")
	}
	return
}

Binder_leaders()
{
	Sleep 2000
	sendChat("/me открыл" plrSex[1] " книгу.")
    Sleep 2000
    SendChat("/do Книга открыта.")
    Sleep 2000
    SendChat("/me начал" plrSex[1] " смотреть список всех Глав.")
    Sleep 5000
    SendChat("/todo Хм..*закрывая книгу")
	return
}

Binder_zams()
{
	Sleep 2000
	sendChat("/me открыл" plrSex[1] " книгу.")
    Sleep 2000
    sendChat("/do Книга открыта.")
    Sleep 2000
    sendChat("/me начал" plrSex[1] " смотреть список всех заместителей Глав.")
    Sleep 5000
    sendChat("/todo Хм..*закрывая книгу")
	return
}

Binder_armour()
{
	Sleep 2000
    sendChat("/do " name " " firstname " держит бронижилет в руках.")
    Sleep 2000
    sendChat("/me надел" plrSex[1] " на себя бронижилет.")
	return
}

Binder_mask()
{
	Sleep 2000
    sendChat("/do Маска лежит в рюкзаке.")
    Sleep 2000
    sendChat("/me достал" plrSex[1] " маску из рюкзака и надел" plrSex[1] " её на себя.")
    Sleep 2000
    sendChat("/do Маска надета.")
	return
}

Binder_gps()
{
    Sleep 2000
    sendChat("/do В левом кармане лежит навигатор.")
    Sleep 2000
    sendChat("/me достал" plrSex[1] " навигатор из левого кармана.")
    Sleep 2000
    sendChat("/do Навигатор в руках.")
	return
}

Binder_dropgun()
{
    Sleep 2000
    SendChat("/me положил" plrSex[1] " оружие на землю.")
    Sleep 2000
    SendChat("/do Оружие находится на земле.")
	return
}

Binder_unfwarn(id)
{
	if (id >= 0 and id < SAMP_MAX_PLAYERS)
	{
		Sleep 2000
		sendChat("/me достал" plrSex[1] " трудовую книжку сотрудника.")
		Sleep 2000
		sendChat("/do Снял" plrSex[1] " выговор сотруднику из трудовой книжки.")
	}
	return
}

Binder_funmute(id)
{
	if (id >= 0 and id < SAMP_MAX_PLAYERS)
	{
		Sleep 2000
		sendChat("/me открыл" plrSex[1] " КПК.")
		Sleep 2000
		sendChat("/do КПК открыт.")
		Sleep 2000
		sendChat("/me включил" plrSex[1] " канал рации организации сотруднику.")
	}
	return
}

Binder_unblacklist(id)
{
	if (id >= 0 and id < SAMP_MAX_PLAYERS)
	{
		Sleep 2000
		sendChat("/me открыл" plrSex[1] " КПК.")
		Sleep 2000
		sendChat("/do КПК открыт.")
		Sleep 2000
		sendChat("/me вынес" plrSex[2] " гражданина из чёрного списка организации.")
	}
	return
}

Binder_uninvite(id, words*)
{
	Loop % words.Length()
		String .= words[A_Index] " "
	if (id >= 0 and id < SAMP_MAX_PLAYERS and String > 0)
	{
		Sleep 2000
		sendChat("/me открыл" plrSex[1] " КПК.")
		Sleep 2000
		sendChat("/do КПК открыт.")
		Sleep 2000
		sendChat("/me удалил" plrSex[1] " данные о сотруднике.")
	}
	return
}

Binder_fwarn(id, words*)
{
	Loop % words.Length()
		String .= words[A_Index] " "
	if (id >= 0 and id < SAMP_MAX_PLAYERS and String > 0)
	{
		Sleep 2000
		sendChat("/me достал" plrSex[1] " трудовую книжку сотрудника.")
		Sleep 2000
		sendChat("/do Занес" plrSex[2] " в трудовую книжку выговор.")
	}
	return
}

Binder_fmute(id, words*)
{
	Loop % words.Length()
		String .= words[A_Index] " "
	if (id >= 0 and id < SAMP_MAX_PLAYERS and String > 0)
	{
		Sleep 2000
		sendChat("/me открыл" plrSex[1] " КПК.")
		Sleep 2000
		sendChat("/do КПК открыт.")
		Sleep 2000
		sendChat("/me отключил" plrSex[1] " канал рации сотрудника.")
	}
	return
}

Binder_blacklist(id, words*)
{
	Loop % words.Length()
		String .= words[A_Index] " "
	if (id >= 0 and id < SAMP_MAX_PLAYERS and String > 0)
	{
		Sleep 2000
		sendChat("/me открыл" plrSex[1] " КПК.")
		Sleep 2000
		sendChat("/do КПК открыт.")
		Sleep 2000
		sendChat("/me занес" plrSex[2] " в чёрный список организации гражданина.")
	}
	return
}

Binder_post()
{
	if (getPost() > 0)
	{
		sleep 1500
		sendChat("/r [" tag "]: Докладывает " name " " firstname " | Пост: " getPost() " | Состояние: стабильное")
		if (autoscreen)
			AScreen()
	}
	return
}

Binder_docs(index)
{
	if (index > 0 and index < 4)
	{
		if (index == 1)
		{
			sendChat("/me взял" plrSex[1] " паспорт.")
			sleep, 2000
			sendChat("/do Паспорт в руках.")
			sleep, 2000
			sendChat("/me проверив документы, передал" plrSex[1] " человеку напротив.")
			return
		}
		if (index == 2)
		{
			sendChat("/me взял" plrSex[1] " мед.карту.")
			sleep, 2000
			sendChat("/do Мед.карта в руках.")
			sleep, 2000
			sendChat("/me проверив документы, передал" plrSex[1] " человеку напротив.")
			return
		}
		if (index == 3)
		{
			sendChat("/me взял" plrSex[1] " лицензии.")
			sleep, 2000
			sendChat("/do Лицензии в руках.")
			sleep, 2000
			sendChat("/me проверив документы, передал" plrSex[1] " человеку напротив.")
			return
		}
	}
	else
	{
		return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Команда должна быть вида: /docs [1-3]")
	}
}

Binder_showpass(id)
{
	if (id >= 0)
	{
		sleep 1600
		sendChat("/me достал" plrSex[1] " паспорт из кармана.")
		sleep 1600
		sendChat("/do " name " " firstname " держит паспорт в руке.")
		sleep 1600
		sendChat("/me показал" plrSex[1] " паспорт человеку напротив.")
	}
	return
}

Binder_showmc(id)
{
	if (id >= 0)
	{
		sleep 1600
		sendChat("/me достал" plrSex[1] " мед.карту из кармана.")
		sleep 1600
		sendChat("/do " name " " firstname " держит мед.карту в руке.")
		sleep 1600
		sendChat("/me показал" plrSex[1] " мед.карту человеку напротив.")
	}
	return
}

Binder_showlic(id)
{
	if (id >= 0)
	{
		sleep 1600
		sendChat("/me достал" plrSex[1] " лицензии из кармана.")
		sleep 1600
		sendChat("/do " name " " firstname " держит лицензии в руке.")
		sleep 1600
		sendChat("/me показал" plrSex[1] "лицензии человеку напротив.")
	}
	return
}


/*
	Хоткеи
*/

Active1:
{
	if (BlockInChat and isInChat())
		return
	Binder_welcome()
	return
}

Active2:
{
	if (BlockInChat and isInChat())
		return
	sendChat("/todo Прошу вас вести себя аккуратно или я вас выгоню из банка*снимая дубинку")
	return
}

Active3:
{
	if (BlockInChat and isInChat())
		return
	playLecture(1)
	return
}

Active4:
{
	if (BlockInChat and isInChat())
		return
	playLecture(2)
	return
}

Active5:
{
	if (BlockInChat and isInChat())
		return
	playLecture(3)
	return
}

Active6:
{
	if (BlockInChat and isInChat())
		return
	playLecture(4)
	return
}

Active7:
{
	if (BlockInChat and isInChat())
		return
	playLecture(5)
	return
}

Active8:
{
	if (BlockInChat and isInChat())
		return
	sobesSystem()
	return
}

Active9:
{
	if (BlockInChat and isInChat())
		return
	openDialog(1)
	return
}

Active10:
{
	if (BlockInChat and isInChat())
		return
	sendChat("/report")
	return
}

Active11:
{
	if (BlockInChat and isInChat())
		return
	openDialog(7)
	return
}

Active12:
{
	if (BlockInChat and isInChat())
		return
	sendChat("/me взял" plrSex[1] " паспорт.")
	sleep 1500
	sendChat("/do Паспорт в руках.")
	sleep 1500
	sendChat("/me открыл" plrSex[1] " базу данных ЦБ.")
	sleep 1500
	sendChat("/me открыл" plrSex[1] " профиль гражданина и вписал" plrSex[1] " данные.")
	sleep 1500
	sendChat("/do Данные вписаны.")
	sleep 1500
	sendChat("/me взял" plrSex[1] " печать ""ЦБ"".")
	sleep 1500
	sendChat("/do Печать ""ЦБ"" в руках.")
	sleep 1500
	sendChat("/me поставил" plrSex[1] " печать ""ЦБ"".")
	return
}

/*
	События диалога
*/
dialogListMenu(index)
{
	if (index == 1)
		openDialog(2)
	if (index == 2)
		openDialog(3)
	if (index == 3)
		openDialog(4)
	if (index == 4)
		openDialog(5)
	if (index == 5)
		openDialog(6)
	if (index == 6)
	{
		if (!radioOn)
		{
			url = http://ic7.101.ru:8000/v1_1
			patchRadio()
			playAudioStream(url)
			unPatchRadio()
			addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Онлайн 'Radio Energy' было включено.")
			radioOn = 1
		}
		else
		{
			patchRadio()
			stopAudioStream()
			unPatchRadio()
			addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Онлайн 'Radio Energy' было выключено.")
			radioOn = 0
		}			
	}
	return
}

dialogListSobes(index)
{
	if (index == 1)
	{
		sendChat("/todo Здравствуйте меня зовут «" name " " firstname "»*на груди весит бейджик «" rang "»")
		sleep, 2000
		sendChat("Вы пришли к нам на собеседование?")
		return
	}
	if (index == 2)
	{
		sendChat("Отлично, покажите мне Ваши документы, а именно паспорт, лицензии и мед.карта.")
		sleep, 2000
		sendChat("/b /showpass - паспорт, /showlic - лицензии , /showmc - мед.карта, отыгрывая РП.")
	}
	if (index == 3)
		Binder_docs(1)
	if (index == 4)
		Binder_docs(3)
	if (index == 5)
		Binder_docs(2)
	if (index == 6)
	{
		sendChat("Проверим ваши навыки владения дубинкой.")
		sleep, 2000
		sendChat("/do Дубинка на столе.")
		sleep, 2000
		sendChat("/me взяв дубинку со стола передал" plrSex[1] " ее человеку напротив.")
		sleep, 2000
		sendChat("Теперь передайте ее мне.")
	}
	if (index == 7)
	{
		sendChat("Отлично.")
		sleep, 2000
		sendChat("/me взял" plrSex[1] " дубинку у человека напротив, после чего положил" plrSex[1] " ее на стол.")
		sleep, 2000
		sendChat("/do Дубинка на столе.")
	}
	if (index == 8)
	{
		sendChat("Перейдем к физ-культурным нормативам.")
		sleep, 2000
		sendChat("Присядьте 5 раз и пробегите с этого места до конца зала.")
	}
	if (index == 9)
	{
		sendChat("/todo Отлично..*расставляя галочки")
		sleep, 2000
		sendChat("Вы приняты на стажировку.")
		sleep, 2000
		sendChat("/do Под столом лежит пакет с формой и рацией.")
		sleep, 2000
		sendChat("/me достал" plrSex[1] " пакет и передал" plrSex[1] " человеку напротив")
		return
	}
	if (index == 10)
	{
		sendChat("Отказ. По причине: проф. непригодность.")
		return
	}
	return
}

dialogListLecture(index)
{
	playLecture(index)
	return
}

dialogListQuickMenu(index)
{
	if (index == 1)
	{
		if (targedID == -1 || getPlayerScore(targedID) == "")
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper] Выделите игрока правой кнопкой мыши.")
		sendChat("/expel " targedID)
		sleep, 3000
		sendChat("/me накидывается на нарушителя и пытается заломать ему руки.")
		sleep, 3000
		sendChat("/me крепко держа нарушителя за руки, выводит его на улицу.")
	}
	if (index == 2)
	{
		if (targedID == -1 || getPlayerScore(targedID) == "")
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper] Выделите игрока правой кнопкой мыши.")
		sendChat("/me достал" plrSex[1] " паспорт из кармана.")
		sleep 1600
		sendChat("/do " name " " firstname " держит паспорт в руке.")
		sleep 1600
		sendChat("/me показал" plrSex[1] " паспорт человеку напротив.")
		sleep 1600
		sendChat("/showpass " targedID)
	}
	if (index == 3)
	{
		if (targedID == -1 || getPlayerScore(targedID) == "")
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper] Выделите игрока правой кнопкой мыши.")
		sendChat("/me достал" plrSex[1] " мед.карту из кармана.")
		sleep 1600
		sendChat("/do " name " " firstname " держит мед.карту в руке.")
		sleep 1600
		sendChat("/me показал" plrSex[1] " мед.карту человеку напротив.")
		sleep 1600
		sendChat("/showmc " targedID)
	}
	if (index == 4)
	{
		if (targedID == -1 || getPlayerScore(targedID) == "")
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper] Выделите игрока правой кнопкой мыши.")
		sendChat("/me достал" plrSex[1] " лицензии из кармана.")
		sleep 1600
		sendChat("/do " name " " firstname " держит лицензии в руке.")
		sleep 1600
		sendChat("/me показал" plrSex[1] " лицензии человеку напротив.")
		sleep 1600
		sendChat("/showlic " targedID)
	}
	if (index == 5)
		openDialog(6)
	if (index == 6)
		openDialog(5)
	if (index == 7)
	{
		if (targedID == -1 || getPlayerScore(targedID) == "")
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper] Выделите игрока правой кнопкой мыши.")
		sendChat("/bankmenu " targedID)
	}
	return
}

/*
	Диалоги
*/
openDialog(id)
{
	; Главное меню
	if (id == 1)
	{
		showDialog(DIALOG_STYLE_LIST, COLOR_RODINA_CAPTION "Bank Helper", DIALOG_COLOR_WHITE "1. Главная информация`n2. Клавиши`n3. Команды`n4. Собеседование`n5. Лекции`n6. Радио", "Закрыть", "", 1)
		onDialogResponse(1, "dialogListMenu")
		return
	}
	; Информация
	if (id == 2)
	{
		showDialog(DIALOG_STYLE_MSGBOX, COLOR_RODINA_CAPTION "Bank Helper [Информация]", COLOR_RODINA_CAPTION "Bank Helper [" version_date "]`nРазработчик: Maxim_Chekistov & Dmitriy_Hawk" COLOR_RODINA_CAPTION "`n`nBank Helper " DIALOG_COLOR_WHITE "- хелпер для сотрудников Центрального банка, который`nимеет множество функциональных биндов и команд для`nоблегчения выполнения вашей работы.`n`nЕсли нашли ошибки в хелпере, то:`n/bug [текст]`nVK: vk.com/kplr452b | vk.com/dmitriy_hawk", "Закрыть", "", 2)
	}
	; Клавиши хелпера
	if (id == 3)
	{
		showDialog(DIALOG_STYLE_MSGBOX, COLOR_RODINA_CAPTION "Bank Helper [Клавиши]", COLOR_RODINA_CAPTION "Основные бинды хелпера:`n`n" key_welcome DIALOG_COLOR_WHITE " - приветствие`n" COLOR_RODINA_CAPTION key_alert DIALOG_COLOR_WHITE " - предупреждение игроку`n" COLOR_RODINA_CAPTION key_lecture_dress DIALOG_COLOR_WHITE " - лекция 'Дресс-Код'`n" COLOR_RODINA_CAPTION key_lecture_eti DIALOG_COLOR_WHITE " - лекция 'Этикет'`n" COLOR_RODINA_CAPTION key_lecture_rule DIALOG_COLOR_WHITE " - лекция 'Устав'`n" COLOR_RODINA_CAPTION key_lecture_sub DIALOG_COLOR_WHITE " - лекция 'Субординация'`n" COLOR_RODINA_CAPTION key_lecture_drugs DIALOG_COLOR_WHITE " - лекция 'Наркотики'`n" COLOR_RODINA_CAPTION key_sobes DIALOG_COLOR_WHITE " - начать собеседование`n" COLOR_RODINA_CAPTION key_menu DIALOG_COLOR_WHITE " - открыть главное меню`n" COLOR_RODINA_CAPTION key_report DIALOG_COLOR_WHITE " - быстрый репорт`n" COLOR_RODINA_CAPTION key_quickmenu DIALOG_COLOR_WHITE " - быстрое меню`n" COLOR_RODINA_CAPTION key_bankmenu DIALOG_COLOR_WHITE " - операция со счетом", "Закрыть", "", 3)
	}
	; Команды хелпера
	if (id == 4)
	{
		showDialog(DIALOG_STYLE_MSGBOX, COLOR_RODINA_CAPTION "Bank Helper [Команды]", COLOR_RODINA_CAPTION "Основные команды хелпера:`n`n" "/lecture [index]" DIALOG_COLOR_WHITE " - начать лекцию`n" COLOR_RODINA_CAPTION "/sob" DIALOG_COLOR_WHITE " - начать собеседование`n" COLOR_RODINA_CAPTION "/rule [index]" DIALOG_COLOR_WHITE " - показать пункт устава`n" COLOR_RODINA_CAPTION "/gg" DIALOG_COLOR_WHITE " - приветствие`n" COLOR_RODINA_CAPTION "/bug [text]" DIALOG_COLOR_WHITE " - отправить вопрос разработчикам`n" COLOR_RODINA_CAPTION "/bh" DIALOG_COLOR_WHITE " - открыть главное меню`n" COLOR_RODINA_CAPTION "/exit" DIALOG_COLOR_WHITE " - завершить работу хелпера`n" COLOR_RODINA_CAPTION "/docs [1-3]" DIALOG_COLOR_WHITE " - проверить документы`n" COLOR_RODINA_CAPTION "/post" DIALOG_COLOR_WHITE " - доложить состояние поста`n" COLOR_RODINA_CAPTION "/clear" DIALOG_COLOR_WHITE " - очистить чат", "Закрыть", "", 4)
	}
	; Собеседование
	if (id == 5)
	{
		showDialog(DIALOG_STYLE_LIST, COLOR_RODINA_CAPTION "Bank Helper [Собеседование]", DIALOG_COLOR_WHITE "1. Приветствие`n2. Запрос документов`n3. Проверка паспорта`n4. Проверка лицензий`n5. Проверка мед.карты`n6. Владение дубинкой`n7. Принять владение дубинкой`n8. Нормативы`n" DIALOG_COLOR_GREEN "9. Принять`n" DIALOG_COLOR_RED "10. Отказать", "Закрыть", "", 5)
		onDialogResponse(5, "dialogListSobes")
		return
	}
	; Лекции
	if (id == 6)
	{
		lectures := ""
		Loop, %A_ScriptDir%\BankHelper\server\lectures\*.txt
		{
			indexfile := A_Index
			Loop, read, %A_LoopFileFullPath%
			{
				if(A_Index == 2)
					lectures = %lectures%%indexfile%. %A_LoopReadLine%`n
			}
		}
		
		
		showDialog(DIALOG_STYLE_LIST, COLOR_RODINA_CAPTION "Bank Helper [Лекции]", DIALOG_COLOR_WHITE lectures, "Закрыть", "", 6)
		onDialogResponse(6, "dialogListLecture")
		return
	}
	; Быстрое меню
	if (id == 7)
	{
		showDialog(DIALOG_STYLE_LIST, COLOR_RODINA_CAPTION "Bank Helper [" targedID "]", DIALOG_COLOR_WHITE "1. Выгнать нарушителя`n2. Показать паспорт`n3. Показать мед.карту`n4. Показать лицензии`n5. Лекции`n6. Собеседование`n7. Операция со счетом", "Закрыть", "", 7)
		onDialogResponse(7, "dialogListQuickMenu")
		return
	}
	return
}

/*
	Метка выделенного игрока
*/
~RButton::
{
	updatePlayers()
	Sleep, 250
	if (getIdByPed(getTargetPed()) != -1 and getIdByPed(getTargetPed()) != targedID)
	{
		targedID := getIdByPed(getTargetPed())
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Вы установили метку на игрока " getPlayerName(targedID) "[" targedID "]")
		return
	}
	return
}

/*
	Автоотыгровка оружия
*/
currentWeapon := -1

plrTick:
{
	if (targedID != -1 and !getStreamedInPlayersInfo()[targedID])
	{
		targedID = -1
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Игрок вне зоны стрима. Метка сброшена.")
	}
	
	weapon := getPlayerWeaponId()
	
	if ((weapon == -1) || (weapon == currentWeapon))
		return
	
	if (currentWeapon > 0) {
		playWeapon(currentWeapon, 1)
	}

	currentWeapon := weapon
	playWeapon(currentWeapon, 2)
}

playWeapon(id, type) { 
	if (id == 3)
	{
		if (type == 1)
		{
			sendChat("/me убрал" plrSex[1] " дубинку в сумку и закрыл" plrSex[1] " ее.")
		}
		if (type == 2)
		{
			sendChat("/do Дубинка висит на поясе.")
			sleep 2000
			sendChat("/me снял" plrSex[1] " дубинку с пояса.")
		}
	}
}