unit UDataCollection;

{
Das Copyright der Software liegt beim ZusiSound Team. Die Software
kann frei verwendet und beliebig geändert werden, solange der
Copyrighthinweis erhalten bleibt.
Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß
es Ihnen von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar
ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT
FÜR EINEN BESTIMMTEN ZWECK.

Copyright (C) 2004 Daniel Schuhmann <webmaster@smartcoder.net>
Copyright (C) 2004 Jens Haupert <haupert@babylon2k.de>

http://zusisound.berlios.de

Version: $Id: UDataCollection.pas,v 1.2 2004/12/02 08:37:07 jens_h Exp $
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
