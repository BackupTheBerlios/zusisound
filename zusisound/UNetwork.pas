unit UNetwork;

{
Das Copyright der Software liegt beim ZusiSound Team. Die Software
kann frei verwendet und beliebig ge�ndert werden, solange der
Copyrighthinweis erhalten bleibt.
Die Ver�ffentlichung dieses Programms erfolgt in der Hoffnung, da�
es Ihnen von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar
ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT
F�R EINEN BESTIMMTEN ZWECK.

Autor(en):
- Daniel Schuhmann <webmaster@smartcoder.net>
- Jens Haupert <haupert@babylon2k.de>

http://zusisound.berlios.de

Version: $Id:
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cCiaBuffer, WSocket, ExtCtrls, UDataCollection;


type TDataType = (Speed, Revolutions, FAHRSTUFE); // TODO: Uebersetzung

type
    TNetwork = class(TObject)
      protected
        CliSocket: TWSocket;
        CliSocketBuffer: TCiaBuffer;
        ClientNameUser: String;
        Host: String;
        Port: String;
        Data: TDataCollection;
        procedure CliSocketBufferReceived(Sender: TObject);
        procedure CliSocketDataAvailable(Sender: TObject; Error: Word);
        procedure CliSocketSessionClosed(Sender: TObject; Error: Word);
        procedure CliSocketSessionConnected(Sender: TObject; Error: Word);
      private
        procedure SendData(Data: String);
        procedure GetNeededData;
        procedure ParseInput(Input: String);
        procedure SetIncomingData(Data: String);
        procedure InitSocket(comp: TComponent);
        procedure SetUpNewData(NewData: Single; DType: TDataType);
      public
        constructor Create(comp: TComponent);
        destructor Destroy; override;
        procedure Connect(host, port: String); overload;
        procedure Connect(clientname, host, port: String); overload;
        procedure Disconnect();
      end;

resourcestring
    ClientName = 'ZusiSound 0.1';

implementation

constructor TNetwork.Create(comp: TComponent);
begin
  CliSocket := TWSocket.Create(comp);

  Data := TDataCollection.Create();

  // Socket initialisieren
  InitSocket(comp);
end;

destructor TNetwork.Destroy();
begin
  try
    // Verbindung beenden
    CliSocket.Close();

    // Socket loeschen
    CliSocketBuffer.Free;
    CliSocket.Free;
  finally
  end;
end;

procedure TNetwork.InitSocket(comp: TComponent);
begin

  with CliSocket do
  begin
    LineMode := False;
    LineLimit := 65536;
    LineEnd := #13#10;
    LineEcho := False;
    LineEdit := False;
    Proto := 'tcp';
    LocalAddr := '0.0.0.0';
    LocalPort := '0';
    MultiThreaded := True;
    MultiCast := False;
    MultiCastIpTTL := 1;
    ReuseAddr := False;
    ComponentOptions := [];
    ListenBacklog := 5;
    ReqVerLow := 1;
    ReqVerHigh := 1;
    OnDataAvailable := CliSocketDataAvailable;
    OnSessionClosed := CliSocketSessionClosed;
    OnSessionConnected := CliSocketSessionConnected;
    FlushTimeout := 60;
    SendFlags := wsSendNormal;
    LingerOnOff := wsLingerOn;
    LingerTimeout := 0;
    SocksLevel := '5';
    SocksAuthentication := socksNoAuthentication;
  end;

  CliSocketBuffer := TCiaBuffer.Create(comp);

  with CliSocketBuffer do
  begin
    InitialSize := 4096;
    SwapLen := False;
    OnReceived := CliSocketBufferReceived;
  end;

end;

procedure TNetwork.Connect(clientname, host, port: String);
begin
    ClientNameUser := clientname;
    Connect(host, port);
end;

procedure TNetwork.Connect(host, port: String);
begin
  try
    CliSocket.Addr := host;
    CliSocket.Port := port;
    CliSocket.Proto := 'tcp';
    CliSocket.Connect();
  except
    MessageDlg('Connect fehlgeschlagen!'+Host+Port, mtInformation, mbOKCancel, 0);
  end;
end;

procedure TNetwork.Disconnect();
begin
  try
    // TODO: Hier tritt eine Zugriffsverletzung auf
    CliSocket.Close();
  except
    MessageDlg('Disconnect fehlgeschlagen!', mtInformation, mbOKCancel, 0);
  end;
end;

procedure TNetwork.CliSocketBufferReceived(Sender: TObject);
var
  S: String;
begin
  S := CliSocketBuffer.ReceiveStr;
  ParseInput(S);
end;

procedure TNetwork.SendData(Data: String);
var
  I: Integer;
  S: String;
  FArray: Array [0..3] of Byte;
  FCardinal: Cardinal;
begin
  S := Data;
  // Paketl�nge festlegen
  FCardinal := Length(S);
  PCardinal(@FArray)^ := FCardinal;

  // Endg�ltigen Sendstring basteln
  // L�nge im Intel Byteorder-Format
  For I := 3 downto 0 do
    S := Chr(FArray[I]) + S;

  CliSocket.SendStr(S);
end;

procedure TNetwork.CliSocketDataAvailable(Sender: TObject; Error: Word);
var
  Count: Integer;
begin
  If Error <> 0 then
    Exit;

  With CliSocket do
    Count := Receive(CliSocketBuffer.MemoryWrite, CliSocketBuffer.MemFree);
  CliSocketBuffer.BytesWritten := Count;
  if CliSocketBuffer.MemFree < 512 then
    CliSocketBuffer.Grow(2048);
end;

procedure TNetwork.CliSocketSessionClosed(Sender: TObject; Error: Word);
begin
  //TODO
end;

procedure TNetwork.CliSocketSessionConnected(Sender: TObject; Error: Word);
var currentClientName : String;
begin
  if (Error <> 0) then
  begin
    // Verbindung konnte nicht hergestellt werden
    MessageBox(NULL,
               'Die Verbindung konnte nicht hergestellt werden.',
               'Keine Verbindung m�glich',
               MB_OK or MB_ICONERROR);
  end else
  begin
    // Wenn Name des Client gesetzt, dann diesen nehmen, sonst Standardwert
    if (ClientNameUser<>'') then
    begin
      currentClientName := ClientNameUser;
    end
    else begin
      currentClientName := ClientName;
    end;

    // Verbindung erfolgreich hergestellt: HELLO-Befehl senden
    SendData(Chr($00)+Chr($01)+        // CMD_HELLO
             Chr($01)+                 // PROTOKOLLVERSION 1
             Chr($02)+                 // TYP FAHRPULT
             Chr(Length(currentClientName))+  // STRING-L�NGE
             currentClientName);
  end;
end;

procedure TNetwork.GetNeededData;
begin
  // Mit dem Befehl GET_NEEDED_DATA die ben�tigen IDs anfordern.
  SendData(Chr($00) + Chr($03)+ // NEEDED_DATA
           Chr($00) + Chr($0A)+ // Datensatz

           Chr($01) +           // Geschwindigkeit = 1
           Chr($09) +           // Motordrehzahl = 9
           Chr($10));           // Fahrstufe = 16

  // Und den Befehl nochmal mit Datensatz 00 00 als Kennung f�r den letzten
  // Befehl.
  SendData(Chr($00) + Chr($03) + Chr($00) + Chr($00)); // Letzter Befehl
end;

procedure TNetwork.ParseInput(Input: String);
begin
  Case Ord(Input[1]) of
    $00: begin
           // Befehle mit Befehlsnummern bis max. 0x00FF, das sind zur Zeit
           // alle aktuellen Befehle
           Case Ord(Input[2]) of
             $01: begin
                    // HELLO-Befehl, kann der Client nicht verarbeiten.
                    // Keine Aktion.
                  end;
             $02: begin
                    // ACK_HELLO-Befehl:
                    // Pr�fen, ob der Client akzeptiert wurde, falls nicht,
                    // Fehlermeldung anzeigen und Verbindung trennen.
                    // Ansonsten ist alles glatt, NEEDED_DATA anfordern.
                    Case Ord(Input[3]) of
                      $00: begin
                             // Kein Fehler: Client wurde akzeptiert
                             // NEEDED_DATA anfordern
                             GetNeededData;
                           end;
                      $01: begin
                             // Zu viele Verbindungen
                             MessageBox(NULL,
                                        'Es bestehen zu viele Verbindungen. '+
                                        'Der Server hat diese nicht mehr '+
                                        'akzeptiert',
                                        'Zu viele Verbindungen',
                                        MB_OK or MB_ICONERROR);
                           end;
                      $02: begin
                             // Zusi bereits Verbunden
                             MessageBox(NULL,
                                        'Zusi ist bereits verbunden. Trennen '+
                                        'Sie Zusi und versuchen Sie es erneut.',
                                        'Zusi ist bereits verbunden',
                                        MB_OK or MB_ICONINFORMATION);
                           end;
                      else begin
                             // Unbekannter Fehler
                             MessageBox(NULL,
                                        'Es ist ein unbekannter Fehler beim '+
                                        'Verbinden w�hrend des CMD_HELLO-'+
                                        'Befehls aufgetreten. Falls Sie zuvor '+
                                        'den Server aktualisiert hatten, '+
                                        'aktualisieren Sie bitte nun das'+
                                        ' Client-Programm.',
                                        'Unbekannter Fehler',
                                        MB_OK or MB_ICONERROR);
                           end;
                    end;
                  end;
             $03: begin
                    // NEEDED_DATA-Befehl, kann der Client nicht verarbeiten.
                    // Keine Aktion.
                  end;
             $04: begin
                    // ACK_NEEDED_DATA-Befehl, dieser Befehl gibt Aufschlu�
                    // dar�ber, ob der NEEDED_DATA-Befehl vom Server akzeptiert
                    // wurde.
                    Case Ord(Input[3]) of
                      $00: begin
                             // Befehl wurde akzeptiert, keine weitere Aktion
                           end;
                      $01: begin
                             // NEEDED_DATA enth�lt einen unbekannten
                             // Befehlsvorrat
                             MessageBox(NULL,
                                        'NEEDED_DATA enth�lt einen unbekannten'+
                                        ' Befehlsvorrat, der vom Server nicht '+
                                        'akzeptiert wurde.',
                                        'Unbekannter Befehlsvorrat',
                                        MB_OK or MB_ICONERROR);
                           end;
                      else begin
                             // ACK_NEEDED_DATA hat einen unbekannten
                             // Fehlercode zur�ckgesendet.
                             MessageBox(NULL,
                                        'CMD_NEEDED_DATA verursachte '+
                                        'eine unbekannte Server-Fehlermeldung.',
                                        'Unbekannte Server-Fehlermeldung',
                                        MB_OK or MB_ICONERROR);
                           end;
                    end;
                  end;
             $0A: begin
                    // DATA-Befehl: Durch diesen Befehl werden die F�hrerstands-
                    // anzeigen aktualisiert.
                    SetIncomingData(Input);
                  end;
           end;
         end;
  end;
end;

procedure TNetwork.SetIncomingData(Data: String);
var
  Buffer: String;
  I: Integer;
  FSingle: Single;
  FArray: Array[1..4] of Byte;
begin
  // Mit dieser Prozedur werden die eingehenden Daten ausgegeben. Zun�chst wird
  // �berpr�ft, ob der Datensatz 00 0A vorliegt, ansonsten werden die Daten
  // ignoriert.
  If not ((Ord(Data[1])=$00) and (Ord(Data[2])=$0A)) then Exit;
  // Die Daten werden in den Arbeitspuffer kopiert
  Buffer := Copy(Data,3,Length(Data));
  // Wenn noch genug Daten im Puffer sind (mind. 1 Datensatz), werden die Daten
  // ausgelesen
  While Length(Buffer) >= 5 do
  begin
    // Bytes in das Array kopieren
    For I := 1 to 4 do
      FArray[I] := Ord(Buffer[I+1]);
    // Array in Single umwandeln
    FSingle := PSingle(@FArray)^;
    // Singlewert auf Typ pruefen
    if (Ord(Buffer[1]) = $01) then
      begin
        SetUpNewData(FSingle, Speed);
      end
    else if (Ord(Buffer[1]) = $09) then
      begin
        SetUpNewData(FSingle, Revolutions);
      end
    else if (Ord(Buffer[1]) = $10) then
      begin
        //SetUpNewData(FSingle, XXX);
      end;
    // Gerade verwendete Daten aus dem Puffer l�schen
    Delete(Buffer,1,5);
  end;
end;

procedure TNetwork.SetUpNewData(NewData: Single; DType: TDataType);
begin
  case DType of
    Speed:        Data.SetSpeed(NewData);
    Revolutions:  Data.SetRevolutions(NewData);
    FAHRSTUFE:    //TODO
  end;
end;

end.
