unit UMain;

{
Das Copyright der Software liegt beim ZusiSound Team. Die Software
kann frei verwendet und beliebig geändert werden, solange der
Copyrighthinweis erhalten bleibt.
Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß
es Ihnen von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar
ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT
FÜR EINEN BESTIMMTEN ZWECK.

Autor(en):
- Jens Haupert <haupert@babylon2k.de>

http://zusisound.berlios.de

Version: $Id:
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UNetwork, StdCtrls;

type
  TFMain = class(TForm)
    BConnect: TButton;
    procedure BConnectClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

procedure TFMain.BConnectClick(Sender: TObject);
var net: TNetwork;
    host, port, client: String;
begin

    host := '127.0.0.1';
    port := '1435';

    if (BConnect.Caption = 'Verbinden') then
    begin
      net := TNetwork.Create(Owner);
      net.Connect(host, port);
      BConnect.Caption := 'Trennen';
    end else
    begin
      net.Disconnect();
      net.Free;
      BConnect.Caption := 'Verbinden';
    end;

end;

end.
