program ZusiSound;

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

uses
  Forms,
  UMain in 'UMain.pas' {FMain},
  UConf in 'UConf.pas' {FConf},
  UNetwork in 'UNetwork.pas',
  UDataCollection in 'UDataCollection.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ZusiSound';
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFConf, FConf);
  Application.Run;
end.
