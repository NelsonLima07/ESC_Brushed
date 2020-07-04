unit FormPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ComCtrls, Vcl.ExtCtrls, CPort;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    TrackBar1: TTrackBar;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    v: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    ComPort1: TComPort;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    TrackBar2: TTrackBar;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    Panel3: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    TrackBar3: TTrackBar;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    Panel4: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    TrackBar4: TTrackBar;
    SpinEdit7: TSpinEdit;
    SpinEdit8: TSpinEdit;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
