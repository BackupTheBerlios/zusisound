unit UConf;

{
Das Copyright der Software liegt beim ZusiSound Team. Die Software
kann frei verwendet und beliebig geändert werden, solange der
Copyrighthinweis erhalten bleibt.
Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß
es Ihnen von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar
ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT
FÜR EINEN BESTIMMTEN ZWECK.

Autor(en):
- Daniel Schuhmann <webmaster@smartcoder.net>
- Jens Haupert <haupert@babylon2k.de>

http://zusisound.berlios.de

Version: $Id:
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cCiaBuffer, WSocket, ExtCtrls, UNetwork;

type
  TFConf = class(TForm)
    CliSocket: TWSocket;
    CliSocketBuffer: TCiaBuffer;
    GroupBox1: TGroupBox;
    laServer: TLabel;
    Label5: TLabel;
    edServer: TEdit;
    cbPort: TComboBox;
    cbOnTop: TCheckBox;
    procedure cbOnTopClick(Sender: TObject);
  private
  public
    { Public-Deklarationen }
  end;

var
  FConf: TFConf;

resourcestring
    ClientName = 'TEST';

implementation

{$R *.dfm}


procedure TFConf.cbOnTopClick(Sender: TObject);
var
  Flags: Cardinal;
begin
  Flags := SWP_DRAWFRAME or SWP_NOMOVE or SWP_NOSIZE;
  If cbOnTop.Checked
    then SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, Flags)
      else SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, Flags);
end;

end.
