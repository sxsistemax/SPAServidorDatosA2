unit uDatosVulcano;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, System.IniFiles, Dialogs;

type
  TdmDatosVulcano = class(TDataModule)
    dbVulcano: TADOConnection;
    Clientesso: TADOTable;
    Productosso: TADOTable;
    Cartera: TADOTable;
    ClientessoNit: TWideStringField;
    ClientessoSuc: TIntegerField;
    ClientessoNombre: TWideStringField;
    ClientessoContacto: TWideStringField;
    ClientessoDireccion: TWideStringField;
    ClientessoBarrio: TWideStringField;
    ClientessoCiudad: TWideStringField;
    ClientessoPais: TWideStringField;
    ClientessoTel1: TWideStringField;
    ClientessoCupo: TWideStringField;
    ClientessoVD: TWideStringField;
    ClientessoEstado: TWideStringField;
    ClientessoTel2: TWideStringField;
    ClientessoTel3: TWideStringField;
    ClientessoTel4: TWideStringField;
    ClientessoFax: TWideStringField;
    ClientessoMail: TWideStringField;
    ClientessoCupoDisponible: TBCDField;
    ClientessoObservaciones: TWideStringField;
    ClientessoCumple: TWideStringField;
    ClientessoAutor: TWideStringField;
    ClientessoBenreteiva: TWideStringField;
    ClientessoLP: TWideStringField;
    ClientessoUsuario: TIntegerField;
    ClientessoNitAux: TWideStringField;
    ProductossoProducto: TWideStringField;
    ProductossoNombre: TWideStringField;
    ProductossoReferencia: TWideStringField;
    ProductossoPrecio1: TWideStringField;
    ProductossoPrecio2: TWideStringField;
    ProductossoPrecio3: TWideStringField;
    ProductossoPrecio4: TWideStringField;
    ProductossoPrecio5: TWideStringField;
    ProductossoPrecio6: TWideStringField;
    ProductossoPrecio7: TWideStringField;
    ProductossoPrecio8: TWideStringField;
    ProductossoPrecio9: TWideStringField;
    ProductossoPrecio10: TWideStringField;
    ProductossoPrecio11: TWideStringField;
    ProductossoPrecio12: TWideStringField;
    ProductossoCosto1: TWideStringField;
    ProductossoCosto2: TWideStringField;
    ProductossoCantidad: TWideStringField;
    ProductossoValorInv: TWideStringField;
    ProductossoIva: TWideStringField;
    ProductossoUnitario: TWideStringField;
    ProductossoRet: TWideStringField;
    ProductossoUn2: TWideStringField;
    CarteraTipo: TWideStringField;
    CarteraDoc: TWideStringField;
    CarteraDescripcion: TWideStringField;
    CarteraNit: TWideStringField;
    CarteraCodDoc: TWideStringField;
    CarteraFechaDoc: TWideStringField;
    CarteraFechaVen: TWideStringField;
    CarteraSaldo: TBCDField;
    CarteraCupo: TBCDField;
    CarteraSuc: TIntegerField;
    qrConsulta: TADOQuery;
    cmVulcano: TADOCommand;
    ProductossoDescripcion: TWideMemoField;
    qrPedidos: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AbrirClientes;
    procedure AbrirProductos;
    procedure AbrirCartera;
    procedure AbrirConsultaPedidos;
    procedure MarcarPedidoEnviado(Pedido : string);
    procedure BorrarCartera;
    procedure AbrirConsulta( SQL : string; Tipo : integer = 0);
    procedure GuardarConexion(S : string);
    procedure ConectarDatos;
  end;

var
  dmDatosVulcano: TdmDatosVulcano;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TdmDatosVulcano.AbrirCartera;
begin
  if not Cartera.Active then
    Cartera.Open;
end;

procedure TdmDatosVulcano.AbrirClientes;
begin
  if not Clientesso.Active then
    Clientesso.Open;
end;

procedure TdmDatosVulcano.AbrirConsulta(SQL: string; Tipo: integer);
begin
  try
    qrConsulta.Close;
    qrConsulta.SQL.Text := SQL;
    if Tipo = 1 then
      qrConsulta.ExecSQL
    else
      qrConsulta.Open;
  except on E: Exception do
  end;
end;

procedure TdmDatosVulcano.AbrirConsultaPedidos;
begin
  try
    AbrirConsulta(qrPedidos.SQL.Text);
  except on E: Exception do
  end;
end;

procedure TdmDatosVulcano.AbrirProductos;
begin
  if not Productosso.Active then
    Productosso.Open;
end;

procedure TdmDatosVulcano.BorrarCartera;
begin

end;

procedure TdmDatosVulcano.ConectarDatos;
var
  i : TIniFile;
  s : string;
begin
  try

    dbVulcano.Close;
    i := TIniFile.Create( ExtractFilePath(ParamStr(0)) + 'Datos.INI' );

    s := i.ReadString('DNS', 'CS', dbVulcano.ConnectionString);
    dbVulcano.ConnectionString := S;

    i.Free;

    dbVulcano.Open;
  except on E: Exception do
  end;

end;

procedure TdmDatosVulcano.DataModuleCreate(Sender: TObject);
begin
  ConectarDatos;
end;

procedure TdmDatosVulcano.GuardarConexion(S : string);
var
  i : TIniFile;
begin
  try
    i := TIniFile.Create( ExtractFilePath(ParamStr(0)) + 'Datos.INI' );

    i.WriteString('DNS', 'CS', S);
    i.Free;

    ConectarDatos;
  except on E: Exception do
     ShowMessage('Error conectando a vulcano ' + E.Message);
  end;
end;

procedure TdmDatosVulcano.MarcarPedidoEnviado(Pedido: string);
begin
  try
    cmVulcano.CommandText := 'Update Pedido Set Enviado = 1 Where Pedido = ''' + Pedido + '''';
    cmVulcano.Execute;
  except on E: Exception do
  end;
end;

end.
