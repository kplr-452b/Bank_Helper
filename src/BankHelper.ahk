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

; ������
global version_build := 1
global version_date := "01.01.2021"
global server_url_update := "https://github.com/kplr-452b/Bank_Helper/raw/main/BankHelper/update.ini"
global name := "������"
global firstname := "��������"
global rang := "��������"
global tag := "�"
global autoscreen := 0
global server := "����������� �����"
global server_folder := "Central_District"
global BlockInChat := 0
global radioOn := 0
global sex := "�������"
global plrSex := []

; ������
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

; �����
global COLOR_RODINA_CAPTION := "{DE1439}"
global COLOR_BLUE := 0x2849DB

global targedID := -1

/*
	�������� ������ �� ������������
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
	�������� ������ �� ������������
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
		server = ����������� �����
	}
	if (sex == "ERROR")
	{
		server = �������
	}
	if (sex == "�������")
	{
		plrSex[1] := "�"
		plrSex[2] := "��"
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
	������������
*/
onLoad:
{
	if (IsSAMPAvailable())
	{
		IniRead, temp_value, %A_ScriptDir%\BankHelper\update.ini, Main, build
		version_build = %temp_value%
		IniRead, temp_value, %A_ScriptDir%\BankHelper\update.ini, Main, version
		version_date = %temp_value%
		
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: Bank Helper ������� ��������. ������������ ������ �� " version_date ".")
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ����� ������� ������� ���� �������: /bh.")
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ����������� Maxim_Chekistov & Dmitriy_Hawk.")
		
		URLDownloadToFile, %server_url_update%, %A_Temp%\update.ini
		IniRead, UpdateBuild, %A_Temp%\update.ini, Main, build
		IniRead, UpdateVersion, %A_Temp%\update.ini, Main, version
		if UpdateBuild > % version_build
		{
			addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ����� ���������� �� " UpdateVersion ".")
			addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ����� ���������� ������� � ��������� � ������� '��������'.")
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
		
		if (InStr(server, "����������� �����"))
			server_folder = Central_District
		if (InStr(server, "����� �����"))
			server_folder = Southern_District
		if (InStr(server, "�������� �����"))
			server_folder = Northern_District
		if (InStr(server, "��������� �����"))
			server_folder = Eastern_District
		
		SetTimer, onLoad, off
		SetTimer, plrTick, 100
		return
	}
}

/*
	������ �������
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
	�������
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
		return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ������ �" index " �� ����������.")
	
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
	sendChat("/todo ������������ ���� ����� �" name " " firstname "�*�� ����� ����� ������� �" rang "�")
	sleep, 2000
	sendChat("�� ������ � ��� �� �������������?")
	sleep, 1000
	addChatMessageEx(COLOR_BLUE, "[Bank Helper]: �������: 1 - ����������, 2 - ���������")
	while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
        continue
	if (GetKeyState("1", "P"))
	{
		sendChat("�������, �������� ��� ���� ���������, � ������ �������, �������� � ���.�����.")
		sleep, 2000
		sendChat("/b /showpass - �������, /showlic - ��������, /showmc - ���.�����, ��������� ��.")
		sleep, 1000
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: �������: 1 - ����������, 2 - ���������")
		while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
			continue
		if (GetKeyState("1", "P"))
		{
			sendChat("/me ����" plrSex[1] " ���������.")
			sleep, 2000
			sendChat("/do ��������� � �����.")
			sleep, 2000
			sendChat("/me �������� ���������, �������" plrSex[1] " �������� ��������.")
			sleep, 1000
			addChatMessageEx(COLOR_BLUE, "[Bank Helper]: �������: 1 - ����������, 2 - ���������")
			while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
				continue
			if (GetKeyState("1", "P"))
			{
				sendChat("�������� ���� ������ �������� ��������.")
				sleep, 2000
				sendChat("/do ������� �� �����.")
				sleep, 2000
				sendChat("/me ���� ������� �� ����� �������" plrSex[1] " �� �������� ��������.")
				sleep, 2000
				sendChat("������ ��������� �� ���.")
				sleep, 1000
				addChatMessageEx(COLOR_BLUE, "[Bank Helper]: �������: 1 - ����������, 2 - ���������")
				while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
					continue
				if (GetKeyState("1", "P"))
				{
					sendChat("�������.")
					sleep, 2000
					sendChat("/me ����" plrSex[1] " ������� � �������� ��������, ����� ���� �������" plrSex[1] " �� �� ����.")
					sleep, 2000
					sendChat("/do ������� �� �����.")
					sleep, 2000
					sendChat("�������� � ���-���������� ����������.")
					sleep, 2000
					sendChat("��������� 5 ��� � ��������� � ����� ����� �� ����� ����.")
					sleep, 1000
					addChatMessageEx(COLOR_BLUE, "[Bank Helper]: �������: 1 - �������, 2 - ��������")
					while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
						continue
					if (GetKeyState("1", "P"))
					{
						sendChat("/todo �������..*���������� �������")
						sleep, 2000
						sendChat("�� ������� �� ����������.")
						sleep, 2000
						sendChat("/do ��� ������ ����� ����� � ������ � ������.")
						sleep, 2000
						sendChat("/me ������" plrSex[1] " ����� � �������" plrSex[1] " �������� ��������")
						return
					}
					if (GetKeyState("2", "P"))
					{
						sendChat("�����. �� �������: ����. �������������.")
						return
					}
				}
				if (GetKeyState("2", "P"))
					return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: �� ��������� �������������.")
			}
			if (GetKeyState("2", "P"))
				return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: �� ��������� �������������.")
		}
		if (GetKeyState("2", "P"))
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: �� ��������� �������������.")
	}
	if (GetKeyState("2", "P"))
		return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: �� ��������� �������������.")
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
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ������� ���������� ����.")
		return -1 
	}
}

/*
	�������
*/

Binder_clearchat()
{
	Loop, 30
		addChatMessageEx(0xFFFFFF, "")
	return
}

Binder_welcome()
{
	sendChat("/todo ������������ ���� ����� �" name " " firstname "�*�� ����� ����� ������� �" rang "�")
	sleep, 1500
	sendChat("��� ���� ���� �������" plrSex[1] "?")
	return
}

Binder_menu()
{
	openDialog(1)
	return
}

Binder_Exit()
{
	addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ������ ������� ��������. ����� ��������� ����������� � ����.")
	ExitApp
}

Binder_expel(id)
{
	if (id >= 0 and id < SAMP_MAX_PLAYERS)
	{
		sleep, 3000
		sendChat("/me ������������ �� ���������� � �������� �������� ��� ����.")
		sleep, 3000
		sendChat("/me ������ ����� ���������� �� ����, ������� ��� �� �����.")
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
		return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ������� ������ ���� ����: /lecture [1-5]")
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
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ������� ������ ���� ����: /rule [�����]")
	}
	return
}

Binder_radio(words*)
{
	Loop % words.Length()
		String .= Words[A_Index] " "
	if (String > 0)
	{
		sendChat("/do C������" plrSex[1] " ���-�� �� �����.")
		sleep 2000
		sendChat("/me �������" plrSex[1] " ����� �� ����.")
		sleep 1600
		sendChat("/do ����� �� �����.")
	}
	return
}

Binder_bug(words*)
{
	Loop % words.Length()
		String .= words[A_Index] " "
	if (String > 0)
	{
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: �� ��������� ��������� �� ������ �������������.")
		vk_report("[Bank Helper] [" getUsername() " (" rang ")]:%0A� " String "%0A%0A@dmitriy_hawk, @kplr452b")
	}
	return
}

Binder_leaders()
{
	Sleep 2000
	sendChat("/me ������" plrSex[1] " �����.")
    Sleep 2000
    SendChat("/do ����� �������.")
    Sleep 2000
    SendChat("/me �����" plrSex[1] " �������� ������ ���� ����.")
    Sleep 5000
    SendChat("/todo ��..*�������� �����")
	return
}

Binder_zams()
{
	Sleep 2000
	sendChat("/me ������" plrSex[1] " �����.")
    Sleep 2000
    sendChat("/do ����� �������.")
    Sleep 2000
    sendChat("/me �����" plrSex[1] " �������� ������ ���� ������������ ����.")
    Sleep 5000
    sendChat("/todo ��..*�������� �����")
	return
}

Binder_armour()
{
	Sleep 2000
    sendChat("/do " name " " firstname " ������ ���������� � �����.")
    Sleep 2000
    sendChat("/me �����" plrSex[1] " �� ���� ����������.")
	return
}

Binder_mask()
{
	Sleep 2000
    sendChat("/do ����� ����� � �������.")
    Sleep 2000
    sendChat("/me ������" plrSex[1] " ����� �� ������� � �����" plrSex[1] " � �� ����.")
    Sleep 2000
    sendChat("/do ����� ������.")
	return
}

Binder_gps()
{
    Sleep 2000
    sendChat("/do � ����� ������� ����� ���������.")
    Sleep 2000
    sendChat("/me ������" plrSex[1] " ��������� �� ������ �������.")
    Sleep 2000
    sendChat("/do ��������� � �����.")
	return
}

Binder_dropgun()
{
    Sleep 2000
    SendChat("/me �������" plrSex[1] " ������ �� �����.")
    Sleep 2000
    SendChat("/do ������ ��������� �� �����.")
	return
}

Binder_unfwarn(id)
{
	if (id >= 0 and id < SAMP_MAX_PLAYERS)
	{
		Sleep 2000
		sendChat("/me ������" plrSex[1] " �������� ������ ����������.")
		Sleep 2000
		sendChat("/do ����" plrSex[1] " ������� ���������� �� �������� ������.")
	}
	return
}

Binder_funmute(id)
{
	if (id >= 0 and id < SAMP_MAX_PLAYERS)
	{
		Sleep 2000
		sendChat("/me ������" plrSex[1] " ���.")
		Sleep 2000
		sendChat("/do ��� ������.")
		Sleep 2000
		sendChat("/me �������" plrSex[1] " ����� ����� ����������� ����������.")
	}
	return
}

Binder_unblacklist(id)
{
	if (id >= 0 and id < SAMP_MAX_PLAYERS)
	{
		Sleep 2000
		sendChat("/me ������" plrSex[1] " ���.")
		Sleep 2000
		sendChat("/do ��� ������.")
		Sleep 2000
		sendChat("/me �����" plrSex[2] " ���������� �� ������� ������ �����������.")
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
		sendChat("/me ������" plrSex[1] " ���.")
		Sleep 2000
		sendChat("/do ��� ������.")
		Sleep 2000
		sendChat("/me ������" plrSex[1] " ������ � ����������.")
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
		sendChat("/me ������" plrSex[1] " �������� ������ ����������.")
		Sleep 2000
		sendChat("/do �����" plrSex[2] " � �������� ������ �������.")
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
		sendChat("/me ������" plrSex[1] " ���.")
		Sleep 2000
		sendChat("/do ��� ������.")
		Sleep 2000
		sendChat("/me ��������" plrSex[1] " ����� ����� ����������.")
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
		sendChat("/me ������" plrSex[1] " ���.")
		Sleep 2000
		sendChat("/do ��� ������.")
		Sleep 2000
		sendChat("/me �����" plrSex[2] " � ������ ������ ����������� ����������.")
	}
	return
}

Binder_post()
{
	if (getPost() > 0)
	{
		sleep 1500
		sendChat("/r [" tag "]: ����������� " name " " firstname " | ����: " getPost() " | ���������: ����������")
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
			sendChat("/me ����" plrSex[1] " �������.")
			sleep, 2000
			sendChat("/do ������� � �����.")
			sleep, 2000
			sendChat("/me �������� ���������, �������" plrSex[1] " �������� ��������.")
			return
		}
		if (index == 2)
		{
			sendChat("/me ����" plrSex[1] " ���.�����.")
			sleep, 2000
			sendChat("/do ���.����� � �����.")
			sleep, 2000
			sendChat("/me �������� ���������, �������" plrSex[1] " �������� ��������.")
			return
		}
		if (index == 3)
		{
			sendChat("/me ����" plrSex[1] " ��������.")
			sleep, 2000
			sendChat("/do �������� � �����.")
			sleep, 2000
			sendChat("/me �������� ���������, �������" plrSex[1] " �������� ��������.")
			return
		}
	}
	else
	{
		return addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ������� ������ ���� ����: /docs [1-3]")
	}
}

Binder_showpass(id)
{
	if (id >= 0)
	{
		sleep 1600
		sendChat("/me ������" plrSex[1] " ������� �� �������.")
		sleep 1600
		sendChat("/do " name " " firstname " ������ ������� � ����.")
		sleep 1600
		sendChat("/me �������" plrSex[1] " ������� �������� ��������.")
	}
	return
}

Binder_showmc(id)
{
	if (id >= 0)
	{
		sleep 1600
		sendChat("/me ������" plrSex[1] " ���.����� �� �������.")
		sleep 1600
		sendChat("/do " name " " firstname " ������ ���.����� � ����.")
		sleep 1600
		sendChat("/me �������" plrSex[1] " ���.����� �������� ��������.")
	}
	return
}

Binder_showlic(id)
{
	if (id >= 0)
	{
		sleep 1600
		sendChat("/me ������" plrSex[1] " �������� �� �������.")
		sleep 1600
		sendChat("/do " name " " firstname " ������ �������� � ����.")
		sleep 1600
		sendChat("/me �������" plrSex[1] "�������� �������� ��������.")
	}
	return
}


/*
	������
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
	sendChat("/todo ����� ��� ����� ���� ��������� ��� � ��� ������ �� �����*������ �������")
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
	sendChat("/me ����" plrSex[1] " �������.")
	sleep 1500
	sendChat("/do ������� � �����.")
	sleep 1500
	sendChat("/me ������" plrSex[1] " ���� ������ ��.")
	sleep 1500
	sendChat("/me ������" plrSex[1] " ������� ���������� � ������" plrSex[1] " ������.")
	sleep 1500
	sendChat("/do ������ �������.")
	sleep 1500
	sendChat("/me ����" plrSex[1] " ������ ""��"".")
	sleep 1500
	sendChat("/do ������ ""��"" � �����.")
	sleep 1500
	sendChat("/me ��������" plrSex[1] " ������ ""��"".")
	return
}

/*
	������� �������
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
			addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ������ 'Radio Energy' ���� ��������.")
			radioOn = 1
		}
		else
		{
			patchRadio()
			stopAudioStream()
			unPatchRadio()
			addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ������ 'Radio Energy' ���� ���������.")
			radioOn = 0
		}			
	}
	return
}

dialogListSobes(index)
{
	if (index == 1)
	{
		sendChat("/todo ������������ ���� ����� �" name " " firstname "�*�� ����� ����� ������� �" rang "�")
		sleep, 2000
		sendChat("�� ������ � ��� �� �������������?")
		return
	}
	if (index == 2)
	{
		sendChat("�������, �������� ��� ���� ���������, � ������ �������, �������� � ���.�����.")
		sleep, 2000
		sendChat("/b /showpass - �������, /showlic - �������� , /showmc - ���.�����, ��������� ��.")
	}
	if (index == 3)
		Binder_docs(1)
	if (index == 4)
		Binder_docs(3)
	if (index == 5)
		Binder_docs(2)
	if (index == 6)
	{
		sendChat("�������� ���� ������ �������� ��������.")
		sleep, 2000
		sendChat("/do ������� �� �����.")
		sleep, 2000
		sendChat("/me ���� ������� �� ����� �������" plrSex[1] " �� �������� ��������.")
		sleep, 2000
		sendChat("������ ��������� �� ���.")
	}
	if (index == 7)
	{
		sendChat("�������.")
		sleep, 2000
		sendChat("/me ����" plrSex[1] " ������� � �������� ��������, ����� ���� �������" plrSex[1] " �� �� ����.")
		sleep, 2000
		sendChat("/do ������� �� �����.")
	}
	if (index == 8)
	{
		sendChat("�������� � ���-���������� ����������.")
		sleep, 2000
		sendChat("��������� 5 ��� � ��������� � ����� ����� �� ����� ����.")
	}
	if (index == 9)
	{
		sendChat("/todo �������..*���������� �������")
		sleep, 2000
		sendChat("�� ������� �� ����������.")
		sleep, 2000
		sendChat("/do ��� ������ ����� ����� � ������ � ������.")
		sleep, 2000
		sendChat("/me ������" plrSex[1] " ����� � �������" plrSex[1] " �������� ��������")
		return
	}
	if (index == 10)
	{
		sendChat("�����. �� �������: ����. �������������.")
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
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper] �������� ������ ������ ������� ����.")
		sendChat("/expel " targedID)
		sleep, 3000
		sendChat("/me ������������ �� ���������� � �������� �������� ��� ����.")
		sleep, 3000
		sendChat("/me ������ ����� ���������� �� ����, ������� ��� �� �����.")
	}
	if (index == 2)
	{
		if (targedID == -1 || getPlayerScore(targedID) == "")
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper] �������� ������ ������ ������� ����.")
		sendChat("/me ������" plrSex[1] " ������� �� �������.")
		sleep 1600
		sendChat("/do " name " " firstname " ������ ������� � ����.")
		sleep 1600
		sendChat("/me �������" plrSex[1] " ������� �������� ��������.")
		sleep 1600
		sendChat("/showpass " targedID)
	}
	if (index == 3)
	{
		if (targedID == -1 || getPlayerScore(targedID) == "")
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper] �������� ������ ������ ������� ����.")
		sendChat("/me ������" plrSex[1] " ���.����� �� �������.")
		sleep 1600
		sendChat("/do " name " " firstname " ������ ���.����� � ����.")
		sleep 1600
		sendChat("/me �������" plrSex[1] " ���.����� �������� ��������.")
		sleep 1600
		sendChat("/showmc " targedID)
	}
	if (index == 4)
	{
		if (targedID == -1 || getPlayerScore(targedID) == "")
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper] �������� ������ ������ ������� ����.")
		sendChat("/me ������" plrSex[1] " �������� �� �������.")
		sleep 1600
		sendChat("/do " name " " firstname " ������ �������� � ����.")
		sleep 1600
		sendChat("/me �������" plrSex[1] " �������� �������� ��������.")
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
			return addChatMessageEx(COLOR_BLUE, "[Bank Helper] �������� ������ ������ ������� ����.")
		sendChat("/bankmenu " targedID)
	}
	return
}

/*
	�������
*/
openDialog(id)
{
	; ������� ����
	if (id == 1)
	{
		showDialog(DIALOG_STYLE_LIST, COLOR_RODINA_CAPTION "Bank Helper", DIALOG_COLOR_WHITE "1. ������� ����������`n2. �������`n3. �������`n4. �������������`n5. ������`n6. �����", "�������", "", 1)
		onDialogResponse(1, "dialogListMenu")
		return
	}
	; ����������
	if (id == 2)
	{
		showDialog(DIALOG_STYLE_MSGBOX, COLOR_RODINA_CAPTION "Bank Helper [����������]", COLOR_RODINA_CAPTION "Bank Helper [" version_date "]`n�����������: Maxim_Chekistov & Dmitriy_Hawk" COLOR_RODINA_CAPTION "`n`nBank Helper " DIALOG_COLOR_WHITE "- ������ ��� ����������� ������������ �����, �������`n����� ��������� �������������� ������ � ������ ���`n���������� ���������� ����� ������.`n`n���� ����� ������ � �������, ��:`n/bug [�����]`nVK: vk.com/kplr452b | vk.com/dmitriy_hawk", "�������", "", 2)
	}
	; ������� �������
	if (id == 3)
	{
		showDialog(DIALOG_STYLE_MSGBOX, COLOR_RODINA_CAPTION "Bank Helper [�������]", COLOR_RODINA_CAPTION "�������� ����� �������:`n`n" key_welcome DIALOG_COLOR_WHITE " - �����������`n" COLOR_RODINA_CAPTION key_alert DIALOG_COLOR_WHITE " - �������������� ������`n" COLOR_RODINA_CAPTION key_lecture_dress DIALOG_COLOR_WHITE " - ������ '�����-���'`n" COLOR_RODINA_CAPTION key_lecture_eti DIALOG_COLOR_WHITE " - ������ '������'`n" COLOR_RODINA_CAPTION key_lecture_rule DIALOG_COLOR_WHITE " - ������ '�����'`n" COLOR_RODINA_CAPTION key_lecture_sub DIALOG_COLOR_WHITE " - ������ '������������'`n" COLOR_RODINA_CAPTION key_lecture_drugs DIALOG_COLOR_WHITE " - ������ '���������'`n" COLOR_RODINA_CAPTION key_sobes DIALOG_COLOR_WHITE " - ������ �������������`n" COLOR_RODINA_CAPTION key_menu DIALOG_COLOR_WHITE " - ������� ������� ����`n" COLOR_RODINA_CAPTION key_report DIALOG_COLOR_WHITE " - ������� ������`n" COLOR_RODINA_CAPTION key_quickmenu DIALOG_COLOR_WHITE " - ������� ����`n" COLOR_RODINA_CAPTION key_bankmenu DIALOG_COLOR_WHITE " - �������� �� ������", "�������", "", 3)
	}
	; ������� �������
	if (id == 4)
	{
		showDialog(DIALOG_STYLE_MSGBOX, COLOR_RODINA_CAPTION "Bank Helper [�������]", COLOR_RODINA_CAPTION "�������� ������� �������:`n`n" "/lecture [index]" DIALOG_COLOR_WHITE " - ������ ������`n" COLOR_RODINA_CAPTION "/sob" DIALOG_COLOR_WHITE " - ������ �������������`n" COLOR_RODINA_CAPTION "/rule [index]" DIALOG_COLOR_WHITE " - �������� ����� ������`n" COLOR_RODINA_CAPTION "/gg" DIALOG_COLOR_WHITE " - �����������`n" COLOR_RODINA_CAPTION "/bug [text]" DIALOG_COLOR_WHITE " - ��������� ������ �������������`n" COLOR_RODINA_CAPTION "/bh" DIALOG_COLOR_WHITE " - ������� ������� ����`n" COLOR_RODINA_CAPTION "/exit" DIALOG_COLOR_WHITE " - ��������� ������ �������`n" COLOR_RODINA_CAPTION "/docs [1-3]" DIALOG_COLOR_WHITE " - ��������� ���������`n" COLOR_RODINA_CAPTION "/post" DIALOG_COLOR_WHITE " - �������� ��������� �����`n" COLOR_RODINA_CAPTION "/clear" DIALOG_COLOR_WHITE " - �������� ���", "�������", "", 4)
	}
	; �������������
	if (id == 5)
	{
		showDialog(DIALOG_STYLE_LIST, COLOR_RODINA_CAPTION "Bank Helper [�������������]", DIALOG_COLOR_WHITE "1. �����������`n2. ������ ����������`n3. �������� ��������`n4. �������� ��������`n5. �������� ���.�����`n6. �������� ��������`n7. ������� �������� ��������`n8. ���������`n" DIALOG_COLOR_GREEN "9. �������`n" DIALOG_COLOR_RED "10. ��������", "�������", "", 5)
		onDialogResponse(5, "dialogListSobes")
		return
	}
	; ������
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
		
		
		showDialog(DIALOG_STYLE_LIST, COLOR_RODINA_CAPTION "Bank Helper [������]", DIALOG_COLOR_WHITE lectures, "�������", "", 6)
		onDialogResponse(6, "dialogListLecture")
		return
	}
	; ������� ����
	if (id == 7)
	{
		showDialog(DIALOG_STYLE_LIST, COLOR_RODINA_CAPTION "Bank Helper [" targedID "]", DIALOG_COLOR_WHITE "1. ������� ����������`n2. �������� �������`n3. �������� ���.�����`n4. �������� ��������`n5. ������`n6. �������������`n7. �������� �� ������", "�������", "", 7)
		onDialogResponse(7, "dialogListQuickMenu")
		return
	}
	return
}

/*
	����� ����������� ������
*/
~RButton::
{
	updatePlayers()
	Sleep, 250
	if (getIdByPed(getTargetPed()) != -1 and getIdByPed(getTargetPed()) != targedID)
	{
		targedID := getIdByPed(getTargetPed())
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: �� ���������� ����� �� ������ " getPlayerName(targedID) "[" targedID "]")
		return
	}
	return
}

/*
	������������� ������
*/
currentWeapon := -1

plrTick:
{
	if (targedID != -1 and !getStreamedInPlayersInfo()[targedID])
	{
		targedID = -1
		addChatMessageEx(COLOR_BLUE, "[Bank Helper]: ����� ��� ���� ������. ����� ��������.")
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
			sendChat("/me �����" plrSex[1] " ������� � ����� � ������" plrSex[1] " ��.")
		}
		if (type == 2)
		{
			sendChat("/do ������� ����� �� �����.")
			sleep 2000
			sendChat("/me ����" plrSex[1] " ������� � �����.")
		}
	}
}