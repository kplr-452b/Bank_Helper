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

global version_build := 1
global version_date := "01.01.2021"

global server_url := "https://github.com/kplr-452b/Bank_Helper/raw/main/"
global server_url_update := "https://github.com/kplr-452b/Bank_Helper/raw/main/BankHelper/update.ini"
global server_url_asi := "https://github.com/kplr-452b/Bank_Helper/raw/main/BankHelper.asi"
global server_url_exe := "https://github.com/kplr-452b/Bank_Helper/raw/main/BankHelper.exe"
global server_url_server := "https://github.com/kplr-452b/Bank_Helper/raw/main/BankHelper/server/"
global server_url_logo := "https://github.com/kplr-452b/Bank_Helper/raw/main/BankHelper/data/img/logo.png"
global server_url_ico := "https://github.com/kplr-452b/Bank_Helper/raw/main/BankHelper/data/helper.ico"


Loading:
{
	myRange := 100
	Gui, 1: -Caption
	Gui, 1: +AlwaysOnTop
	Gui, 1: Color, Black
	Gui, 1: Font, s6 cWhite
	Gui, 1: Add, Text, x5 y0 w200 h10 , Загрузка всех необходимых файлов
	Gui, 1: Add, Progress, x5 y10 w200 h10 BackgroundBlack cred vPro1 Range0-%myRange%,0
	Gui, 1: Show, w210 h22
	Gosub, Looping
	return
}
Looping:
{
	Pro1 := 0
	GuiControl,,Pro1,% Pro1
	Loop, 100
	{
		Pro1++
		GuiControl,,Pro1,% Pro1
		sleep, 10
	}
	Gosub, start
	return
}
start:
{
	Gui, 1: Destroy
	IniRead, temp_value, %A_ScriptDir%\BankHelper\update.ini, Main, build
	version_build = %temp_value%
	IniRead, temp_value, %A_ScriptDir%\BankHelper\update.ini, Main, version
	version_date = %temp_value%
	
	if (!checkFiles())
	{
		MsgBox, 0x10, BankHelper, Отсутствуют некоторые файлы хелпера, начинаю скачивать... 
		repairFiles()
	}
	
	Menu, Tray, Icon, %A_ScriptDir%\BankHelper\data\helper.ico, 1
	
	Gui, Add, Button, x25 y400 w120 h50 gSave, Сохранить
	Gui, Add, Button, x150 y400 w120 h50 gUpdate, Обновить
	
	Gui, Add, Text, x300 y400 cBlue gLaunchGroup, Группа Rodina Helpers
	Gui, Add, Text, x300 y420 cBlue gLaunchDev1, Maxim_Chekistov
	Gui, Add, Text, x300 y440 cBlue gLaunchDev2, Dmitriy_Hawk
	
	Gui, Add, Tab, x5 y5 w440 h390 , Главная|Настройки|Лекции
	Gui, Tab, Главная
	{
		Gui, Add, Picture, x30 y30 w150 h150, %A_ScriptDir%\BankHelper\data\img\logo.png
		Gui, font, s15
		Gui, Add, Text, x185 y55 w250 h40 vlabel_logo, Bank Helper [%version_date%]
		Gui, Font, S8 CDefault Normal
		Gui, Add, GroupBox, x185 y90 w230 h70,
		Gui, Add, GroupBox, x185 y90 w230 h40,
		Gui, Add, GroupBox, x185 y90 w230 h100, Профиль
		Gui, Add, Text, x195 y110 w200 h15 vlabel_pname, Фамилия и имя:
		Gui, Add, Text, x195 y140 w200 h15 vlabel_prang, Должность:
		Gui, Add, Text, x195 y170 w200 h15 vlabel_pserver, Округ:
		
		Gui, Add, GroupBox, x15 y200 w400 h180, Changelog
		Gui, Font, Bold
		Gui, Add, Text, x25 y230 w380 h155, 1. Убраны автозаполнение /me /do /todo`n`n2. Отыгровка операции со счетом перенесена на хоткей`n`n3. Изменена отыгровка рации
		Gui, Font, S8 CDefault Normal
	}
	Gui, Tab, Настройки
	{
		Gui, Add, GroupBox, x10 y30 w430 h150 , Основные настройки
		Gui, Add, Text, x25 y55 w100 h15 vlabel_name, Имя:
		Gui, Add, Edit, x100 y55 w150 h20 vedit_name,
		Gui, Add, Text, x25 y85 w100 h15 vlabel_firstname, Фамилия:
		Gui, Add, Edit, x100 y85 w150 h20 vedit_firstname,
		Gui, Add, Text, x25 y115 w100 h15 vlabel_rang, Должность:
		Gui, Add, Edit, x100 y115 w150 h20 vedit_rang,
		Gui, Add, Text, x25 y145 w100 h15 vlabel_server, Округ:
		Gui, Add, DropDownList, x100 y145 w150 h80 vedit_server,Центральный округ|Южный округ|Северный округ|Восточный округ
		Gui, Add, Text, x280 y55 w100 h15 vlabel_tag, Тег рации:
		Gui, Add, Edit, x350 y55 w50 h20 vedit_tag,
		Gui, Add, Text, x280 y85 w100 h15 vlabel_autoscreen, Автоскрин:
		Gui, Add, Checkbox, x350 y85 w50 h20 vcheckbox_autoscreen,
		Gui, Add, Text, x280 y105 w150 h35 vlabel_blockinchat, Блокировать биндер при открытом чате:
		Gui, Add, Checkbox, x370 y120 w50 h20 vcheckbox_blockinchat,
		Gui, Add, Text, x280 y145 w100 h15 vlabel_sex, Пол:
		Gui, Add, DropDownList, x320 y145 w80 h60 vedit_sex,Мужской|Женский
	
		Gui, Add, GroupBox, x10 y180 w430 h210, Клавиши
		Gui, Add, Text, x25 y205 w100 h15 vlabel_welcome, Приветствие:
		Gui, Add, Hotkey, x120 y205 w70 h20 vkey_welcome,
		Gui, Add, Text, x25 y235 w100 h15 vlabel_alert, Предупреждение:
		Gui, Add, Hotkey, x120 y235 w70 h20 vkey_alert,
		Gui, Add, Text, x25 y265 w100 h15 vlabel_lecture_dress, Лек. Дресс-Код:
		Gui, Add, Hotkey, x120 y265 w70 h20 vkey_lecture_dress,
		Gui, Add, Text, x25 y295 w100 h15 vlabel_lecture_drugs, Лек. Наркотики:
		Gui, Add, Hotkey, x120 y295 w70 h20 vkey_lecture_drugs,
		Gui, Add, Text, x25 y325 w100 h15 vlabel_menu, Главное меню:
		Gui, Add, Hotkey, x120 y325 w70 h20 vkey_menu,
		Gui, Add, Text, x25 y355 w100 h15 vlabel_quickmenu, Быстрое меню:
		Gui, Add, Hotkey, x120 y355 w70 h20 vkey_quickmenu,
	
		Gui, Add, Text, x205 y205 w100 h15 vlabel_lecture_eti, Лек. Этикет:
		Gui, Add, Hotkey, x315 y205 w70 h20 vkey_lecture_eti,
		Gui, Add, Text, x205 y235 w100 h15 vlabel_lecture_rule, Лек. Устав:
		Gui, Add, Hotkey, x315 y235 w70 h20 vkey_lecture_rule,
		Gui, Add, Text, x205 y265 w150 h15 vlabel_lecture_sub, Лек. Субординация:
		Gui, Add, Hotkey, x315 y265 w70 h20 vkey_lecture_sub,
		Gui, Add, Text, x205 y295 w150 h15 vlabel_sobes, Собеседование:
		Gui, Add, Hotkey, x315 y295 w70 h20 vkey_sobes,
		Gui, Add, Text, x205 y325 w150 h15 vlabel_report, Быстрый репорт:
		Gui, Add, Hotkey, x315 y325 w70 h20 vkey_report,
		Gui, Add, Text, x205 y355 w150 h15 vlabel_bankmenu, Операция со счетом:
		Gui, Add, Hotkey, x315 y355 w70 h20 vkey_bankmenu,
	}
	Gui, Tab, Лекции
	{
		Gui, Add, Text, x15 y35 w150 h15, Лекции:
		Gui, Add, ListBox, x15 y60 w150 h300 vlist_files,
		Gui, Add, GroupBox, x180 y35 w250 h280, Редактор
		Gui, Add, Text, x190 y60 w150 h15, Название лекции:
		Gui, Add, Edit, x290 y60 w100 h20 vedit_lecturename,
		Gui, Add, Text, x190 y90 w150 h15, Интервал:
		Gui, Add, Edit, x290 y90 w100 h20 number vedit_lectureinterval,
		Gui, Add, Edit, x190 y120 w230 R13 vedit_lecturetext,
		
		Gui, Add, Button, x35 y355 w90 h30 gOpenLecture, Открыть
		Gui, Add, Button, x190 y325 w90 h30 gCreateLecture, Добавить
		Gui, Add, Button, x290 y325 w90 h30 gSaveLecture, Сохранить
		Gui, Add, Button, x190 y360 w90 h30 gDeleteLecture, Удалить
	}
	
	IniRead iname, %A_ScriptDir%\BankHelper\config.ini, User, name
	GuiControl,, edit_name, %iname%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, User, firstname
	GuiControl,, edit_firstname, %value%
	GuiControl,, label_pname, Имя и фамилия: %iname% %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, User, rang
	GuiControl,, edit_rang, %value%
	GuiControl,, label_prang, Должность: %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, User, tag
	GuiControl,, edit_tag, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, User, autoscreen
	GuiControl,, checkbox_autoscreen, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, User, server, Центральный округ
	GuiControl, ChooseString, edit_server, %value%
	GuiControl,, label_pserver, Округ: %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, User, blockinchat
	GuiControl,, checkbox_blockinchat, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, User, sex, Мужской
	GuiControl, ChooseString, edit_sex, %value%
	
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_welcome
	GuiControl,, key_welcome, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_alert
	GuiControl,, key_alert, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_dress
	GuiControl,, key_lecture_dress, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_eti
	GuiControl,, key_lecture_eti, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_rule
	GuiControl,, key_lecture_rule, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_sub
	GuiControl,, key_lecture_sub, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_drugs
	GuiControl,, key_lecture_drugs, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_sobes
	GuiControl,, key_sobes, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_menu
	GuiControl,, key_menu, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_report
	GuiControl,, key_report, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_quickmenu
	GuiControl,, key_quickmenu, %value%
	IniRead value, %A_ScriptDir%\BankHelper\config.ini, Keys, key_bankmenu
	GuiControl,, key_bankmenu, %value%
	
	loadLectures()

	Gui, Show, w450 h470, Bank Helper [%version_date%]
	return
}

checkFiles()
{
	files := ["BankHelper.asi", "BankHelper\data\img\logo.png", "BankHelper\server\Central_District\charter.ini", "BankHelper\server\Eastern_District\charter.ini", "BankHelper\server\Northern_District\charter.ini", "BankHelper\server\Southern_District\charter.ini", "BankHelper\server\lectures\1.txt", "BankHelper\server\lectures\2.txt", "BankHelper\server\lectures\3.txt", "BankHelper\server\lectures\4.txt", "BankHelper\server\lectures\5.txt", "BankHelper\data\helper.ico", "BankHelper\update.ini"]
	
	
	for index, file in files
	{
		IfNotExist, %A_ScriptDir%\%file%
			return 0
	}
	
	return 1
}

global index_lecture := 0

loadLectures()
{
	lectures := ""
	GuiControl,, list_files, |
	Loop, %A_ScriptDir%\BankHelper\server\lectures\*.txt
	{
		indexfile := A_Index
		Loop, read, %A_LoopFileFullPath%
		{
			if(A_Index == 2)
				lectures = %lectures%%indexfile%.%A_LoopReadLine%|
		}
	}
	GuiControl, Text, list_files, %lectures%
	return
}

OpenLecture:
{
	Gui, Submit, NoHide
	Loop, parse, list_files, |
	{
		data := StrSplit(A_LoopField, ".")
		index_lecture := data[1]
		name := data[2]
		interval := 0
		
		GuiControl,, edit_lecturename, %name%	
		
		Loop, read, %A_ScriptDir%\BankHelper\server\lectures\%index_lecture%.txt
		{
			if(A_Index == 1)
			{
				GuiControl,, edit_lectureinterval, %A_LoopReadLine%	
				interval := A_LoopReadLine
			}
			if (A_Index > 2)
			{
				FileRead, FileContents, %A_ScriptDir%\BankHelper\server\lectures\%index_lecture%.txt
				lec_text := SubStr(FileContents, StrLen(name) + StrLen(interval) + 5, StrLen(FileContents) - (StrLen(name) + StrLen(interval)) + 5)
				GuiControl,, edit_lecturetext, %lec_text%	
			}
		}
		
	}
	return
}

DeleteLecture:
{
	IfNotExist, %A_ScriptDir%\BankHelper\server\lectures\%index_lecture%.txt
		return
	FileDelete, %A_ScriptDir%\BankHelper\server\lectures\%index_lecture%.txt
	GuiControl,, edit_lecturetext,
	GuiControl,, edit_lecturename,
	GuiControl,, edit_lectureinterval,
	loadLectures()
	return
}

CreateLecture:
{
	Gui, Submit, NoHide
	last_index := 0
	
	Loop, %A_ScriptDir%\BankHelper\server\lectures\*.txt
	{
		last_index := A_Index + 1
	}
	
	FileAppend, 
	(
	%edit_lectureinterval%
%edit_lecturename%
%edit_lecturetext%
	), %A_ScriptDir%\BankHelper\server\lectures\%last_index%.txt
	loadLectures()
	return
}

SaveLecture:
{
	Gui, Submit, NoHide
	IfNotExist, %A_ScriptDir%\BankHelper\server\lectures\%index_lecture%.txt
		return
	FileDelete, %A_ScriptDir%\BankHelper\server\lectures\%index_lecture%.txt
	FileAppend, 
	(
	%edit_lectureinterval%
%edit_lecturename%
%edit_lecturetext%
	), %A_ScriptDir%\BankHelper\server\lectures\%index_lecture%.txt
	loadLectures()
	MsgBox, , Лекция, Лекция успешно сохранена
	return 
}

LaunchGroup:
{
	Run, https://vk.com/rodina_helpers
	return
}

LaunchDev1:
{
	Run, https://vk.com/kplr452b
	return
}
LaunchDev2:
{
	Run, https://vk.com/dmitriy_hawk
	return
}

Save:
{
	Gui, Submit, NoHide
	IniDelete, %A_ScriptDir%\BankHelper\config.ini, 0,
    IniWrite %edit_name%, %A_ScriptDir%\BankHelper\config.ini, User, name
	IniWrite %edit_firstname%, %A_ScriptDir%\BankHelper\config.ini, User, firstname
	IniWrite %edit_rang%, %A_ScriptDir%\BankHelper\config.ini, User, rang
	IniWrite %edit_tag%, %A_ScriptDir%\BankHelper\config.ini, User, tag
	IniWrite %edit_server%, %A_ScriptDir%\BankHelper\config.ini, User, server
	IniWrite %checkbox_autoscreen%, %A_ScriptDir%\BankHelper\config.ini, User, autoscreen
	IniWrite %checkbox_blockinchat%, %A_ScriptDir%\BankHelper\config.ini, User, blockinchat
	IniWrite %edit_sex%, %A_ScriptDir%\BankHelper\config.ini, User, sex
	
	IniWrite %key_welcome%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_welcome
	IniWrite %key_alert%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_alert
	IniWrite %key_lecture_dress%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_dress
	IniWrite %key_lecture_eti%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_eti
	IniWrite %key_lecture_rule%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_rule
	IniWrite %key_lecture_sub%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_sub
	IniWrite %key_lecture_drugs%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_lecture_drugs
	IniWrite %key_sobes%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_sobes
	IniWrite %key_menu%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_menu
	IniWrite %key_report%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_report
	IniWrite %key_quickmenu%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_quickmenu
	IniWrite %key_bankmenu%, %A_ScriptDir%\BankHelper\config.ini, Keys, key_bankmenu
	
	GuiControl,, label_pname, Имя и фамилия: %edit_name% %edit_firstname%
	GuiControl,, label_prang, Должность: %edit_rang%
	GuiControl,, label_pserver, Округ: %edit_server%
	
	MsgBox,, Bank Helper, Данные успешно сохранены!
	return
}

repairFiles()
{
	FileCreateDir, %A_ScriptDir%\BankHelper\
	FileCreateDir, %A_ScriptDir%\BankHelper\data\
	FileCreateDir, %A_ScriptDir%\BankHelper\data\img\
	FileCreateDir, %A_ScriptDir%\BankHelper\server\Central_District\
	FileCreateDir, %A_ScriptDir%\BankHelper\server\Eastern_District\
	FileCreateDir, %A_ScriptDir%\BankHelper\server\Northern_District\
	FileCreateDir, %A_ScriptDir%\BankHelper\server\Southern_District\
	FileCreateDir, %A_ScriptDir%\BankHelper\server\lectures\
	
	SplashTextOn, 200, 80, Менеджер обновлений,  Ожидайте..`n------------------------`nЗагружаем Bank Helper [Plugin]!
	URLDownloadToFile, %server_url_asi%, %A_ScriptDir%\BankHelper.asi
	SplashTextOn, 200, 80, Менеджер обновлений,  Ожидайте..`n------------------------`nЗагружаем Bank Helper [GUI]!
	URLDownloadToFile, %server_url_logo%, %A_ScriptDir%\BankHelper\data\img\logo.png
	URLDownloadToFile, %server_url_ico%, %A_ScriptDir%\BankHelper\data\helper.ico
	URLDownloadToFile, %server_url_exe%, %A_ScriptDir%\BankHelper.exe
	SplashTextOn, 200, 80, Менеджер обновлений,  Ожидайте..`n------------------------`nЗагружаем Bank Helper [Other]!
	URLDownloadToFile, %server_url_server%/lectures/1.txt, %A_ScriptDir%\BankHelper\server\lectures\1.txt
	URLDownloadToFile, %server_url_server%/lectures/2.txt, %A_ScriptDir%\BankHelper\server\lectures\2.txt
	URLDownloadToFile, %server_url_server%/lectures/3.txt, %A_ScriptDir%\BankHelper\server\lectures\3.txt
	URLDownloadToFile, %server_url_server%/lectures/4.txt, %A_ScriptDir%\BankHelper\server\lectures\4.txt
	URLDownloadToFile, %server_url_server%/lectures/5.txt, %A_ScriptDir%\BankHelper\server\lectures\5.txt
		
	URLDownloadToFile, %server_url_server%/Central_District/charter.ini, %A_ScriptDir%\BankHelper\server\Central_District\charter.ini
	URLDownloadToFile, %server_url_server%/Eastern_District/charter.ini, %A_ScriptDir%\BankHelper\server\Eastern_District\charter.ini
	URLDownloadToFile, %server_url_server%/Northern_District/charter.ini, %A_ScriptDir%\BankHelper\server\Northern_District\charter.ini
	URLDownloadToFile, %server_url_server%/Southern_District/charter.ini, %A_ScriptDir%\BankHelper\server\Southern_District\charter.ini
	SplashTextOff
	Run, %A_ScriptDir%\BankHelper.exe
	ExitApp
	return 1
}

Update:
{
	URLDownloadToFile, %server_url_update%, %A_ScriptDir%\BankHelper\update.ini
	IniRead, UpdateBuild, %A_ScriptDir%\BankHelper\update.ini, Main, build
	if UpdateBuild > % version_build
	{		
		FileCreateDir, %A_ScriptDir%\BankHelper\
		FileCreateDir, %A_ScriptDir%\BankHelper\data\
		FileCreateDir, %A_ScriptDir%\BankHelper\data\img\
		FileCreateDir, %A_ScriptDir%\BankHelper\server\Central_District\
		FileCreateDir, %A_ScriptDir%\BankHelper\server\Eastern_District\
		FileCreateDir, %A_ScriptDir%\BankHelper\server\Northern_District\
		FileCreateDir, %A_ScriptDir%\BankHelper\server\Southern_District\
		FileCreateDir, %A_ScriptDir%\BankHelper\server\lectures\
		
		SplashTextOn, 200, 80, Менеджер обновлений,  Ожидайте..`n------------------------`nОбновляем Bank Helper [Plugin]!
		URLDownloadToFile, %server_url_asi%, %A_ScriptDir%\BankHelper.asi
		SplashTextOn, 200, 80, Менеджер обновлений,  Ожидайте..`n------------------------`nОбновляем Bank Helper [GUI]!
		URLDownloadToFile, %server_url_ico%, %A_ScriptDir%\BankHelper\data\helper.ico
		URLDownloadToFile, %server_url_exe%, %A_ScriptDir%\BankHelper.exe
		URLDownloadToFile, %server_url_logo%, %A_ScriptDir%\BankHelper\data\img\logo.png
		SplashTextOn, 200, 80, Менеджер обновлений,  Ожидайте..`n------------------------`nОбновляем Bank Helper [Other]!
		URLDownloadToFile, %server_url_server%/lectures/1.txt, %A_ScriptDir%\BankHelper\server\lectures\1.txt
		URLDownloadToFile, %server_url_server%/lectures/2.txt, %A_ScriptDir%\BankHelper\server\lectures\2.txt
		URLDownloadToFile, %server_url_server%/lectures/3.txt, %A_ScriptDir%\BankHelper\server\lectures\3.txt
		URLDownloadToFile, %server_url_server%/lectures/4.txt, %A_ScriptDir%\BankHelper\server\lectures\4.txt
		URLDownloadToFile, %server_url_server%/lectures/5.txt, %A_ScriptDir%\BankHelper\server\lectures\5.txt
		
		URLDownloadToFile, %server_url_server%/Central_District/charter.ini, %A_ScriptDir%\BankHelper\server\Central_District\charter.ini
		URLDownloadToFile, %server_url_server%/Eastern_District/charter.ini, %A_ScriptDir%\BankHelper\server\Eastern_District\charter.ini
		URLDownloadToFile, %server_url_server%/Northern_District/charter.ini, %A_ScriptDir%\BankHelper\server\Northern_District\charter.ini
		URLDownloadToFile, %server_url_server%/Southern_District/charter.ini, %A_ScriptDir%\BankHelper\server\Southern_District\charter.ini
		SplashTextOff
		Run, %A_ScriptDir%\BankHelper.exe
		ExitApp
	}
	else
	{
		MsgBox, 0x31, Обновление и восстановление, Обновление не найдено! Восстановить файлы?
		IfMsgBox, OK
		{
			repairFiles()
		}
	}
	return
}

GuiClose:
{
	ExitApp
	return
}

Utf8ToAnsi(ByRef Utf8String, CodePage = 1251)
{
    If (NumGet(Utf8String) & 0xFFFFFF) = 0xBFBBEF
        BOM = 3
    Else
        BOM = 0
    UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
    , "UInt", &Utf8String + BOM, "Int", -1
    , "Int", 0, "Int", 0)
    VarSetCapacity(UniBuf, UniSize * 2)
    DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
    , "UInt", &Utf8String + BOM, "Int", -1
    , "UInt", &UniBuf, "Int", UniSize)
    AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
    , "UInt", &UniBuf, "Int", -1
    , "Int", 0, "Int", 0
    , "Int", 0, "Int", 0)
    VarSetCapacity(AnsiString, AnsiSize)
    DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
    , "UInt", &UniBuf, "Int", -1
    , "Str", AnsiString, "Int", AnsiSize
    , "Int", 0, "Int", 0)
    Return AnsiString
}