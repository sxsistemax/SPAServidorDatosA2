unit uPrincipal;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp, OnGuard,
  Vcl.Buttons, Vcl.ExtCtrls, Data.Win.ADODB ;

type
  TfmPrincipal = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    pFooter: TPanel;
    pBotones: TPanel;
    bCerrar: TBitBtn;
    bRegistro: TBitBtn;
    bEditarConexion: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure bRegistroClick(Sender: TObject);
    procedure bCerrarClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bEditarConexionClick(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    { Private declarations }
  public
    { Public declarations }
    procedure ValidarParametro; Virtual;
    procedure CargarDatosAplicaion; virtual;
  end;

var
  fmPrincipal: TfmPrincipal;

implementation

uses
  Winapi.ShellApi, Datasnap.DSService, uUtilidadesSPA, uSeguridad, uUtilidades,
  uTablasConBlobAdministrativo, uDatosVulcano, uBaseDatosA2;

{$R *.dfm}

Const
  IdentificadorAplicacion : TKey = ($55,$8F,$4F,$34,$95,$51,$27,$0F,$CA,$FE,$8D,$13,$06,$E4,$88,$D8);


procedure TfmPrincipal.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure TfmPrincipal.bCerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TfmPrincipal.bEditarConexionClick(Sender: TObject);
var
  s : WideString;
begin
  s := PromptDataSource(Application.Handle, dmDatosVulcano.dbVulcano.ConnectionString);
  if s <> '' then
    dmDatosVulcano.GuardarConexion(S);
end;

procedure TfmPrincipal.bRegistroClick(Sender: TObject);
begin
  MostrarRegistrado;
end;

procedure TfmPrincipal.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s/ServerFunctionInvoker', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TfmPrincipal.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TfmPrincipal.ButtonStopClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TfmPrincipal.CargarDatosAplicaion;
begin
  Key := IdentificadorAplicacion;
end;

procedure TfmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 CanClose := Confirmar('Desea salir de la aplicación?');

end;

procedure TfmPrincipal.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);

  CargarDatosAplicaion;

  ModoDemo := true;

  // valida el registro
  ValidarRegistro(ModoDemo);

  //Valalida los parametros
  ValidarParametro;

  // Hace la verificación de sEmpresa.Dat
  if dmBasesDatos.ExisteSEmpresa then
  Begin
    // Abre empresas
    dmBasesDatos.AbrirSEmpresa;

    // Conecta la base de datos
    dmBasesDatos.ConectarDB(dmBasesDatos.sEmpresaFE_DIRDATOS.AsString);
  end
    Else
  begin
    ShowMessage(
      'No se encontro el archivo sEmpresas.dat, no puede ejecutar el programa'
      );
     Halt(1);
  end;


end;

procedure TfmPrincipal.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

procedure TfmPrincipal.ValidarParametro;
begin
  OpcionParametro(0);
end;

end.
