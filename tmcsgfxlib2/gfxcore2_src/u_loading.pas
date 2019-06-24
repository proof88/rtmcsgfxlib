unit u_loading;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  Tfrm_loading = class(TForm)
    lbl_info: TLabel;
    lbl_info02: TLabel;
    pbar: TProgressBar;
    pnl: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_loading: Tfrm_loading;

implementation

{$R *.dfm}

end.
