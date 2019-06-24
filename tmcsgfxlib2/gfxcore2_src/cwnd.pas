unit cwnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tfrm_c = class(TForm)
    mm: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_c: Tfrm_c;

implementation

{$R *.dfm}

procedure Tfrm_c.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mm.Lines.SaveToFile('tmcslog.txt');
end;

end.
