; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppPublisher "Straylight Labs LLC"
#define MyAppURL "https://github.com/fflewddur/archivo"
#define MyAppExeName "Archivo.jar"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{7370FEB8-7A03-4F39-9B4D-1BFA12081EF9}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputBaseFilename={#MyAppName} {#MyAppVersion}
Compression=lzma
SolidCompression=yes
SourceDir={#SrcDir}
MinVersion=0,6.0
SignTool=signtool

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "*.jar"; DestDir: "{app}"; Flags: ignoreversion
Source: "*.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "comskip.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "comskip.dictionary"; DestDir: "{app}"; Flags: ignoreversion
Source: "archivo.ico"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\archivo.ico"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\archivo.ico"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent; Check: IsJREInstalled

[InstallDelete]
Type: files; Name: {app}\appbundler-*.jar;
Type: files; Name: {app}\commons-codec-*.jar;
Type: files; Name: {app}\commons-logging-*.jar;
Type: files; Name: {app}\hola-*.jar;
Type: files; Name: {app}\httpclient-*.jar;
Type: files; Name: {app}\httpcore-*.jar;
Type: files; Name: {app}\json-*.jar;
Type: files; Name: {app}\logback-classic-*.jar;
Type: files; Name: {app}\logback-core-*.jar;
Type: files; Name: {app}\slf4j-api-*.jar;
Type: files; Name: {app}\tivo-libre-*.jar;

[Code]
#define MinJRE "1.8"
#define WebJRE "https://java.com/en/download/"

function IsJREInstalled: Boolean;
var
  JREVersion: string;
begin
  // read JRE version
  Result := RegQueryStringValue(HKLM32, 'Software\JavaSoft\Java Runtime Environment',
    'CurrentVersion', JREVersion);
  // if the previous reading failed and we're on 64-bit Windows, try to read
  // the JRE version from WOW node
  if not Result and IsWin64 then
    Result := RegQueryStringValue(HKLM64, 'Software\JavaSoft\Java Runtime Environment',
      'CurrentVersion', JREVersion);
  // if the JRE version was read, check if it's at least the minimum one
  if Result then
    Result := CompareStr(JREVersion, '{#MinJRE}') >= 0;
end;

function InitializeSetup: Boolean;
var
  ErrorCode: Integer;
begin
  Result := True;
  // check if JRE is installed; if not, then...
  if not IsJREInstalled then
  begin
    // show a message box and let user to choose if they want to download JRE;
    // if so, go to its download site and exit setup; continue otherwise
    if MsgBox('Archivo requires Java 8 or newer. Do you want to download it now?',
      mbConfirmation, MB_YESNO) = IDYES then
    begin
      Result := False;
      ShellExec('', '{#WebJRE}', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
    end;
  end;
end;
