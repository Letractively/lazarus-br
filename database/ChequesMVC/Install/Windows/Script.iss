; Cheques 2.1, Controle pessoal de cheques.
; Copyright (C) 2010-2012 Everaldo - arcanjoebc@gmail.com
;
; See the LICENSE in http://www.gnu.org/licenses/lgpl-2.1.txt, for details about the copyright.
;
; This library is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;
; Powerfull contributors:
; - Silvio Clecio > http://blog.silvioprog.com.br
; - Joao Morais > http://blog.joaomorais.com.br
; - Luiz Americo > http://lazarusroad.blogspot.com

[Setup]
AppId={{57D1B1BB-950A-4496-A379-09FB07A3836E}
AppName=Cheques
AppVerName=Cheques 2.1
AppPublisherURL=http://groups.google.com.br/group/lazarus-br
AppSupportURL=http://groups.google.com.br/group/lazarus-br
AppUpdatesURL=http://groups.google.com.br/group/lazarus-br
DefaultDirName={pf}\Cheques
DefaultGroupName=Cheques
LicenseFile=..\Linux\DEB\opt\Cheques\LICENSE.txt
OutputBaseFilename=cheques_2.1_all
Compression=lzma/ultra
SolidCompression=true
VersionInfoVersion=2.1
VersionInfoDescription=Cheques 2.1 - Controle pessoal de cheques.
VersionInfoTextVersion=2.1
VersionInfoCopyright=Copyright © Everaldo <arcanjoebc@gmail.com>
VersionInfoProductName=Cheques
VersionInfoProductVersion=2.1
AppCopyright=Copyright © Everaldo <arcanjoebc@gmail.com>
PrivilegesRequired=none
UserInfoPage=true
AppPublisher=Copyright © Everaldo <arcanjoebc@gmail.com>
AppVersion=2.1
UninstallDisplayIcon={app}\cheques.exe
WizardImageFile=compiler:wizmodernimage-IS.bmp
WizardSmallImageFile=compiler:wizmodernsmallimage-IS.bmp
WindowVisible=true
BackColor=clTeal
BackColor2=clWhite
DisableStartupPrompt=false
ShowTasksTreeLines=true

[Languages]
Name: english; MessagesFile: compiler:Default.isl
Name: brazilianportuguese; MessagesFile: compiler:Languages\BrazilianPortuguese.isl

[Tasks]
Name: quicklaunchicon; Description: {cm:CreateQuickLaunchIcon}; GroupDescription: {cm:AdditionalIcons}

[Files]
Source: cheques.exe; DestDir: {app}; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: sqlite3.dll; DestDir: {app}
Source: ..\Linux\DEB\opt\Cheques\Leia-me.txt; DestDir: {app}
Source: ..\Linux\DEB\opt\Cheques\LICENSE.txt; DestDir: {app}
Source: ..\Linux\DEB\opt\Cheques\Data\cheques.db3; DestDir: {app}\Data\
Source: ..\Linux\DEB\opt\Cheques\DER\DER.png; DestDir: {app}\DER\
Source: ..\Linux\DEB\opt\Cheques\Doc\about.png; DestDir: {app}\Doc\
Source: ..\Linux\DEB\opt\Cheques\Doc\help.html; DestDir: {app}\Doc\
Source: ..\Linux\DEB\opt\Cheques\Media\cheques.png; DestDir: {app}\Media\
Source: ..\Linux\DEB\opt\Cheques\Media\cheques24.png; DestDir: {app}\Media\
Source: ..\Linux\DEB\opt\Cheques\Script\Firebird\Script.sql; DestDir: {app}\Script\Firebird
Source: ..\Linux\DEB\opt\Cheques\Script\PostgreSQL\Script.sql; DestDir: {app}\Script\PostgreSQL
Source: ..\Linux\DEB\opt\Cheques\Script\SQLite\Script.sql; DestDir: {app}\Script\SQLite
Source: cheques-conf; DestDir: {app}

[Icons]
Name: {group}\Cheques; Filename: {app}\cheques.exe; WorkingDir: {app}\; IconFilename: {app}\cheques.exe; IconIndex: 0
Name: {group}\{cm:ProgramOnTheWeb,Cheques}; Filename: http://groups.google.com.br/group/lazarus-br
Name: {group}\{cm:UninstallProgram,Cheques}; Filename: {uninstallexe}
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\Cheques; Filename: {app}\cheques.exe; Tasks: quicklaunchicon; WorkingDir: {app}\; IconFilename: {app}\cheques.exe; IconIndex: 0

[Run]
Filename: {app}\cheques.exe; Description: {cm:LaunchProgram,Cheques}; Flags: nowait postinstall skipifsilent
[Dirs]
Name: {app}\Data
Name: {app}\DER
Name: {app}\Doc
Name: {app}\Media
Name: {app}\Script
Name: {app}\Script\Firebird
Name: {app}\Script\PostgreSQL
Name: {app}\Script\SQLite
[Messages]
BeveledLabel=http://groups.google.com.br/group/lazarus-br
[UninstallDelete]
Name: {app}; Type: filesandordirs
