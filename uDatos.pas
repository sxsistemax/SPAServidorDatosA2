unit uDatos;

interface

uses
  System.SysUtils, System.Classes, Data.DB, dbisamtb;

type
  TdmDatos = class(TDataModule)
    qrClientes: TDBISAMQuery;
    qrUnCliente: TDBISAMQuery;
    qrInventario: TDBISAMQuery;
    qrUnElementoInventario: TDBISAMQuery;
    qrConsulta: TDBISAMQuery;
    SOperacionInv: TDBISAMTable;
    SDetalleVenta: TDBISAMTable;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AbrirClientes;
    function ConsultarUnCliente( Campo : Integer; Valor : string) : Boolean;
    procedure AbrirInventario;
    procedure AbrirArchivosPedidos;
    function ConsultarUnElementoInventario( Campo : Integer; Valor : string) : Boolean;
    procedure AbrirConsulta( SQL : string; Tipo : integer = 0);
    procedure ConsultarCuentasXCobrar;
  end;

var
  dmDatos: TdmDatos;

implementation

Uses Vcl.Dialogs, uBaseDatosA2, uTablasConBlobAdministrativo, uUtilidadesSPA;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TdmDatos }



procedure TdmDatos.AbrirArchivosPedidos;
begin
  try
    if not SOperacionInv.Active then
      SOperacionInv.Open;

    if not SDetalleVenta.Active then
      SDetalleVenta.Open;

  except on E: Exception do
  end;
end;

procedure TdmDatos.AbrirClientes;
begin
  qrClientes.Close;

  // Si esta en modo demo solo retorna 10 registros
  if ModoDemo then
    qrClientes.MaxRowCount := 10
  else
    qrClientes.MaxRowCount := -1;

  qrClientes.Open;
end;

procedure TdmDatos.AbrirConsulta(SQL: string; Tipo : integer = 0);
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

procedure TdmDatos.AbrirInventario;
begin
  qrInventario.Close;

  // Si esta en modo demo solo retorna 10 registros
  if ModoDemo then
    qrInventario.MaxRowCount := 10
  else
    qrInventario.MaxRowCount := -1;

  qrInventario.Open;
end;

procedure TdmDatos.ConsultarCuentasXCobrar;
begin
  AbrirConsulta('SELECT                      ' +
     '  Scuentasxcobrar.FCC_TIPOTRANSACCION, ' +
     '  Scuentasxcobrar.FCC_NUMERO,          ' +
     '  Scuentasxcobrar.FCC_DESCRIPCIONMOV,  ' +
     '  Scuentasxcobrar.FCC_CODIGO,          ' +
     '  Scuentasxcobrar.FCC_NUMERO2,         ' +
     '  Scuentasxcobrar.FCC_FECHAEMISION,    ' +
     '  Scuentasxcobrar.FCC_FECHAVENCIMIENTO,' +
     '  Scuentasxcobrar.FCC_SALDODOCUMENTO, Sclientes.FC_LIMITECREDITO   ' +
     'FROM                                   ' +
     ' Scuentasxcobrar INNER JOIN Sclientes ON (Scuentasxcobrar.FCC_CODIGO=Sclientes.FC_CODIGO) ' +
     'WHERE                                  ' +
     '  (Scuentasxcobrar.FCC_SALDODOCUMENTO <> 0)');
end;

function TdmDatos.ConsultarUnCliente(Campo : Integer; Valor: string): Boolean;
var
  Condicion : string;
begin
  try
    result := true;

    qrUnCliente.Close;
    qrUnCliente.SQL.Text := qrClientes.SQL.Text;
    case Campo of
      1 : Condicion := ' Where FC_Codigo = ''' + Valor + '''';
      2 : Condicion := ' Where FC_Nit = ''' + Valor + '''';
    end;
    qrUnCliente.SQL.Text := qrUnCliente.SQL.Text + ' ' + Condicion;
    qrUnCliente.Open;
  except on E: Exception do
  end;
end;

function TdmDatos.ConsultarUnElementoInventario(Campo: Integer;
  Valor: string): Boolean;
var
  Condicion : string;
begin
  try
    result := true;

    qrUnElementoInventario.Close;
    qrUnElementoInventario.SQL.Text := qrInventario.SQL.Text;
    case Campo of
      1 : Condicion := ' And FI_Codigo = ''' + Valor + '''';
    end;
    qrUnElementoInventario.SQL.Text := qrUnElementoInventario.SQL.Text + ' ' + Condicion;
    qrUnElementoInventario.Open;
  except on E: Exception do
  end;
end;

end.
