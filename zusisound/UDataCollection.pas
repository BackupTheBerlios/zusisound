unit UDataCollection;

{
Das Copyright der Software liegt beim ZusiSound Team. Die Software
kann frei verwendet und beliebig ge�ndert werden, solange der
Copyrighthinweis erhalten bleibt.
Die Ver�ffentlichung dieses Programms erfolgt in der Hoffnung, da�
es Ihnen von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar
ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT
F�R EINEN BESTIMMTEN ZWECK.

Autor(en):
- Jens Haupert <haupert@babylon2k.de>

http://zusisound.berlios.de

Version: $Id:
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cCiaBuffer, WSocket, ExtCtrls;

type
    TDataCollection = class(TObject)
      protected
        Speed : Single;
        Revolutions : Single;
        Fahrstufe : Single; // Uebersetzung notwendig
      private
      public
        procedure SetSpeed(NewSpeed: Single);
        procedure SetRevolutions(NewRevolutions: Single);
        //TODO: SET_Fahrstufe

        function GetSpeed() : Single;
        function GetRevolutions() : Single;
        //TODO: GET_Fahrstufe
      end;

implementation

procedure TDataCollection.SetSpeed(NewSpeed: Single);
begin
  Speed := NewSpeed;
end;

procedure TDataCollection.SetRevolutions(NewRevolutions: Single);
begin
  Revolutions := NewRevolutions;
end;

//TODO: SET_Fahrstufe

function TDataCollection.GetSpeed() : Single;
begin
  Result := Speed;
end;

function TDataCollection.GetRevolutions() : Single;
begin
  Result := Revolutions;
end;

//TODO: GET_Fahrstufe

end.
