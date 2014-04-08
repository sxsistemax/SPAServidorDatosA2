unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth, Data.DBXJSON, Data.db;

type
{$METHODINFO ON}
  TServerMethods1 = class(TComponent)
  private
    { Private declarations }
  public
    { Public declarations }
    function getClientes : TJSONArray;
    function getCliente(Campo : Integer; Valor : String ) : TJSONArray;
    function getInventario : TJSONArray;
    function getElementoInventario(Campo : Integer; Valor : String ) : TJSONArray;
    function getConsulta( SQL : string) : TJSONArray;
    function SincronizarClientes: TJSONArray;
    function SincronizarInventario: TJSONArray;
    function SincronizarCartera: TJSONArray;
    function SincronizarPedidos: TJSONArray;

    function postPedido( Encabezado, Detalle : TJSONArray) : TJSONArray;
  end;
{$METHODINFO OFF}

implementation


uses System.StrUtils, uDatos, uUtilidadesSPA, uTablasConBlobAdministrativo, dbisamtb,
  uDatosVulcano;

function QuitarDigitoVerificacion( Valor : String) : string;
var
  p : integer;
begin
  p := Pos( '-', Valor);
  if p > 0 then
    Result := Copy( Valor, 1, P - 1)
  else
    Result := Valor;
end;

function TServerMethods1.getCliente(Campo: Integer; Valor: String): TJSONArray;
var                 
  jRecord: TJSONObject;
  I: Integer;
begin

  dmDatos.ConsultarUnCliente( Campo, Valor);
  Result := TJSonArray.Create;

  while not dmDatos.qrUnCliente.EOF do
  begin
    jRecord := TJSONObject.Create;
    for I := 0 to dmDatos.qrUnCliente.FieldCount - 1 do
      jRecord.AddPair(
        dmDatos.qrUnCliente.Fields[I].FieldName,
        TJSONString.Create (dmDatos.qrUnCliente.Fields[I].AsString));
    Result.AddElement(jRecord);

    dmDatos.qrUnCliente.Next;
  end;
  dmDatos.qrUnCliente.Close;

end;

function TServerMethods1.getClientes: TJSONArray;
var
  jRecord: TJSONObject;
  I: Integer;
begin
  Result := TJSonArray.Create;

  dmDatos.AbrirClientes;

  while not dmDatos.qrClientes.EOF do
  begin
    jRecord := TJSONObject.Create;
    for I := 0 to dmDatos.qrClientes.FieldCount - 1 do
      jRecord.AddPair(
        dmDatos.qrClientes.Fields[I].FieldName,
        TJSONString.Create (dmDatos.qrClientes.Fields[I].AsString));
    Result.AddElement(jRecord);
    dmDatos.qrClientes.Next;
  end;
  dmDatos.qrClientes.Close;
end;

function TServerMethods1.getConsulta(SQL: string): TJSONArray;
var
  jRecord: TJSONObject;
  I: Integer;
begin
  Result := TJSonArray.Create;

  dmDatos.AbrirConsulta(SQL);

  while not dmDatos.qrConsulta.EOF do
  begin
    jRecord := TJSONObject.Create;
    for I := 0 to dmDatos.qrConsulta.FieldCount - 1 do
      jRecord.AddPair(
        dmDatos.qrConsulta.Fields[I].FieldName,
        TJSONString.Create (dmDatos.qrConsulta.Fields[I].AsString));
    Result.AddElement(jRecord);
    dmDatos.qrConsulta.Next;
  end;
  dmDatos.qrConsulta.Close;
end;

function TServerMethods1.getInventario: TJSONArray;
var
  jRecord, JPrecio : TJSONObject;
  JRecordCosto : TJSONArray;
  I, J: Integer;
begin
  dmDatos.AbrirInventario;
  Result := TJSonArray.Create;

  // Recorro todo el archivo
  while not dmDatos.qrInventario.EOF do
  begin
    jRecord := TJSONObject.Create;
    for I := 0 to dmDatos.qrInventario.FieldCount - 1 do
    begin
      if dmDatos.qrInventario.Fields[I].FieldName <> 'Costos'then
      begin
        jRecord.AddPair(
          dmDatos.qrInventario.Fields[I].FieldName,
          TJSONString.Create (dmDatos.qrInventario.Fields[I].AsString));
      end
      else
      begin
        // Carga el costo de sfixed
        dmAdministrativo.CargarTablaCostos(TDBISAMTable(dmDatos.qrInventario),
          TBlobField(dmDatos.qrInventario.FieldByName('Costos')));

        // CArga los campos del costo
        dmAdministrativo.tbCostos.First;
        for J := 0 to dmAdministrativo.tbCostos.FieldCount -1 do
        begin
          jRecord.AddPair(
            dmAdministrativo.tbCostos.Fields[J].FieldName,
            TJSONString.Create (dmAdministrativo.tbCostos.Fields[J].AsString));
        end;

        // Cargo los campos de los precios
        JRecordCosto := TJSONArray.Create;

        dmAdministrativo.tbPrecios.First;
        while not dmAdministrativo.tbPrecios.Eof do
        begin

          // Genero el elemento precio
          JPrecio := TJSONObject.Create;
          for J := 0 to dmAdministrativo.tbPrecios.FieldCount -1 do
          begin
            JPrecio.AddPair(
                dmAdministrativo.tbPrecios.Fields[J].FieldName,
                TJSONString.Create (dmAdministrativo.tbPrecios.Fields[J].AsString));
          end;

          // Adiciono el elemento precio
          JRecordCosto.AddElement( JPrecio);

          dmAdministrativo.tbPrecios.Next;
        end;

        // Adicion el registro completo
        jRecord.AddPair(TJSONPair.Create('Precios', JRecordCosto));
      end;
    end;
    Result.AddElement(jRecord);
    dmDatos.qrInventario.Next;
  end;
  dmDatos.qrInventario.Close;
end;

function TServerMethods1.postPedido(Encabezado,
  Detalle: TJSONArray): TJSONArray;
var
  jRecord : TJSONObject;
begin
  Result := TJSonArray.Create;

  Result.AddElement(TJSONObject.Create(
      TJSONPair.Create('resultado', 'Datos recibidos')));
end;

function TServerMethods1.SincronizarCartera: TJSONArray;
var
  jRecord : TJSONObject;
begin
  Result := TJSonArray.Create;
   
  dmDatosVulcano.AbrirConsulta('delete from Cartera', 1);
  dmDatosVulcano.AbrirCartera;
  dmDatos.ConsultarCuentasXCobrar;

  dmDatos.qrConsulta.First;
  while not dmDatos.qrConsulta.Eof do
  begin
    try
      dmDatosVulcano.Cartera.Append;

      dmDatosVulcano.CarteraTipo.Value := dmDatos.qrConsulta.FieldByName('FCC_TIPOTRANSACCION').AsString;
      dmDatosVulcano.CarteraDoc.Value := dmDatos.qrConsulta.FieldByName('FCC_NUMERO').AsString;
      dmDatosVulcano.CarteraDescripcion.Value := Copy( dmDatos.qrConsulta.FieldByName('FCC_DESCRIPCIONMOV').AsString, 1 , dmDatosVulcano.CarteraDescripcion.Size);
      dmDatosVulcano.CarteraNit.Value := QuitarDigitoVerificacion( dmDatos.qrConsulta.FieldByName('FCC_CODIGO').Value);
      dmDatosVulcano.CarteraFechaDoc.Value := dmDatos.qrConsulta.FieldByName('FCC_FECHAEMISION').AsString;
      dmDatosVulcano.CarteraFechaVen.Value := dmDatos.qrConsulta.FieldByName('FCC_FECHAVENCIMIENTO').AsString;
      dmDatosVulcano.CarteraSaldo.Value := dmDatos.qrConsulta.FieldByName('FCC_SALDODOCUMENTO').Value;
      dmDatosVulcano.CarteraCupo.Value := dmDatos.qrConsulta.FieldByName('FC_LIMITECREDITO').Value;
      dmDatosVulcano.CarteraSuc.Value := 0;

      dmDatosVulcano.Cartera.Post;
    except on E: Exception do
       Result.AddElement(TJSONObject.Create(
                TJSONPair.Create('error', E.Message + 
                      ' Transaccion : ' + dmDatos.qrConsulta.FieldByName('FCC_TIPOTRANSACCION').AsString +
                      ' Documento : ' +  dmDatos.qrConsulta.FieldByName('FCC_NUMERO').AsString)));

    end;
    dmDatos.qrConsulta.Next;
  end;
  dmDatosVulcano.Cartera.Close;
  Result.AddElement(TJSONObject.Create(
              TJSONPair.Create('resultado', 'Datos Sincronizados')));
end;

function TServerMethods1.SincronizarClientes: TJSONArray;
var
  jRecord : TJSONObject;
begin
  Result := TJSonArray.Create;

  dmDatos.AbrirClientes;
  dmDatosVulcano.AbrirClientes;

  while not dmDatos.qrClientes.EOF do
  begin
    try
      if dmDatosVulcano.Clientesso.Locate('Nit',
        dmDatos.qrClientes.FieldByName('FC_CODIGO').Value, []) then
        dmDatosVulcano.Clientesso.Edit
      else
        dmDatosVulcano.Clientesso.Append;

      dmDatosVulcano.ClientessoNit.Value := dmDatos.qrClientes.FieldByName('FC_CODIGO').Value;
      dmDatosVulcano.ClientessoSuc.Value := 0;
      dmDatosVulcano.ClientessoNombre.Value := Copy( dmDatos.qrClientes.FieldByName('FC_DESCRIPCION').AsString, 1, dmDatosVulcano.ClientessoNombre.Size);
      dmDatosVulcano.ClientessoContacto.Value := Copy( dmDatos.qrClientes.FieldByName('FC_CONTACTO').AsString, 1, dmDatosVulcano.ClientessoContacto.Size);
      dmDatosVulcano.ClientessoDireccion.Value := Copy( dmDatos.qrClientes.FieldByName('FC_DIRECCION1').AsString, 1, dmDatosVulcano.ClientessoDireccion.Size);
      dmDatosVulcano.ClientessoBarrio.Value := Copy( dmDatos.qrClientes.FieldByName('FC_DIRECCION2').AsString, 1, dmDatosVulcano.ClientessoBarrio.Size);
      dmDatosVulcano.ClientessoCiudad.Value := Copy( dmDatos.qrClientes.FieldByName('FC_DIRECCION3').AsString, 1, dmDatosVulcano.ClientessoCiudad.Size);
      dmDatosVulcano.ClientessoPais.Value := '';
      dmDatosVulcano.ClientessoTel1.Value := dmDatos.qrClientes.FieldByName('FC_TELEFONO').AsString;
      dmDatosVulcano.ClientessoCupo.Value := '0';
      dmDatosVulcano.ClientessoVD.Value := dmDatos.qrClientes.FieldByName('FC_VENDEDOR').AsString;
      dmDatosVulcano.ClientessoEstado.Value := '';
      dmDatosVulcano.ClientessoTel2.Value := '';
      dmDatosVulcano.ClientessoTel3.Value := '';
      dmDatosVulcano.ClientessoTel4.Value := '';
      dmDatosVulcano.ClientessoFax.Value := dmDatos.qrClientes.FieldByName('FC_TELEFAX').AsString;
      dmDatosVulcano.ClientessoMail.Value := dmDatos.qrClientes.FieldByName('FC_EMAIL').AsString;
      dmDatosVulcano.ClientessoCupoDisponible.Value := 0;
      dmDatosVulcano.ClientessoObservaciones.Value := dmDatos.qrClientes.FieldByName('FC_MSGTEXTO1').AsString;
      dmDatosVulcano.ClientessoCumple.Value := '';
      dmDatosVulcano.ClientessoAutor.Value := '';
      dmDatosVulcano.ClientessoBenreteiva.Value := '';
      //dmDatosVulcano.ClientessoAgereteica.Value := '';
      dmDatosVulcano.ClientessoLP.Value := '';
      dmDatosVulcano.ClientessoUsuario.Value := 0;
      dmDatosVulcano.ClientessoNitAux.Value := dmDatos.qrClientes.FieldByName('FC_NIT').AsString;
      dmDatosVulcano.Clientesso.Post;
    except on E: Exception do
      begin
        Result.AddElement(TJSONObject.Create(
                TJSONPair.Create('error', E.Message + ' Cliente : ' + dmDatos.qrClientes.FieldByName('FC_CODIGO').Value)));
        dmDatosVulcano.Clientesso.Cancel;
      end;
      
    end;
    dmDatos.qrClientes.Next;
  end ;
  dmDatosVulcano.Clientesso.Close;
  dmDatos.qrClientes.Close;
  Result.AddElement(TJSONObject.Create(
            TJSONPair.Create('resultado', 'Datos Sincronizados')));
end;

function TServerMethods1.SincronizarInventario: TJSONArray;
var
  jRecord : TJSONArray;
  Producto : string;
begin
    jRecord := TJSonArray.Create;

    dmDatos.AbrirInventario;
    dmDatosVulcano.AbrirProductos;
  
    // Recorro todo el archivo
    while not dmDatos.qrInventario.EOF do
    begin
      Producto := dmDatos.qrInventario.FieldByName('FI_CODIGO').Value; 

      try
        if dmDatosVulcano.Productosso.Locate('Producto', Producto, []) then
          dmDatosVulcano.Productosso.Edit
        else
          dmDatosVulcano.Productosso.Append;
  
        dmAdministrativo.CargarTablaCostos(TDBISAMTable(dmDatos.qrInventario),
          TBlobField(dmDatos.qrInventario.FieldByName('Costos')));

        // CArga los campos del costo
        dmAdministrativo.tbCostos.First;
  
        dmAdministrativo.tbPrecios.First;
        while not dmAdministrativo.tbPrecios.Eof do
        begin
          case dmAdministrativo.tbPrecios.RecNo of
            1 : dmDatosVulcano.ProductossoPrecio1.Value := dmAdministrativo.tbPreciosPrecio.AsString;
            2 : dmDatosVulcano.ProductossoPrecio2.Value := dmAdministrativo.tbPreciosPrecio.AsString;
            3 : dmDatosVulcano.ProductossoPrecio3.Value := dmAdministrativo.tbPreciosPrecio.AsString;
            4 : dmDatosVulcano.ProductossoPrecio4.Value := dmAdministrativo.tbPreciosPrecio.AsString;
            5 : dmDatosVulcano.ProductossoPrecio5.Value := dmAdministrativo.tbPreciosPrecio.AsString;
            6 : dmDatosVulcano.ProductossoPrecio6.Value := dmAdministrativo.tbPreciosPrecio.AsString;
          end;

          dmAdministrativo.tbPrecios.Next;
        end;

        dmDatosVulcano.ProductossoProducto.Value := dmDatos.qrInventario.FieldByName('FI_CODIGO').AsString;
        dmDatosVulcano.ProductossoNombre.Value := dmDatos.qrInventario.FieldByName('FI_DESCRIPCION').AsString;
        dmDatosVulcano.ProductossoDescripcion.Value := dmDatos.qrInventario.FieldByName('FI_DESCRIPCIONDETALLADA').AsString;
        dmDatosVulcano.ProductossoReferencia.Value := dmDatos.qrInventario.FieldByName('FI_REFERENCIA').AsString;
        dmDatosVulcano.ProductossoCosto1.Value := dmAdministrativo.tbCostosCostoPromedio.AsString;
        dmDatosVulcano.ProductossoCantidad.Value := '0';
        dmDatosVulcano.ProductossoValorInv.Value := '0';
        dmDatosVulcano.ProductossoIva.Value := dmAdministrativo.tbCostosmImpuesto1.AsString;
        dmDatosVulcano.ProductossoUnitario.Value := '';
        dmDatosVulcano.ProductossoRet.Value := '';
        dmDatosVulcano.ProductossoUn2.Value := '';
        
        dmDatosVulcano.Productosso.Post;  

      except on E: Exception do
        begin
           jRecord.AddElement(TJSONObject.Create(
                  TJSONPair.Create('error', E.Message + '. Codigo : ' + Producto)));
           dmDatosVulcano.Productosso.Cancel;
        end;
      end;
      dmDatos.qrInventario.Next;
    end;
    dmDatos.qrInventario.Close;
    dmDatosVulcano.Productosso.Close;
    jRecord.AddElement(TJSONObject.Create(
              TJSONPair.Create('resultado', 'Datos Sincronizados')));

    Result := jRecord;
end;

function TServerMethods1.SincronizarPedidos: TJSONArray;
var
  Pedido : string;
begin
  try
    Result := TJSonArray.Create;

    dmDatosVulcano.AbrirConsultaPedidos;
    dmDatos.AbrirArchivosPedidos;

    while not dmDatosVulcano.qrConsulta.EOF do
    begin
      Pedido := dmDatosVulcano.qrConsulta.FieldByName('Pedido').Value;

      // Inserta el traslado en SOperacionInv
      dmDAtos.SOperacionInv.Append;

      dmDAtos.SOperacionInv.FieldByName('FTI_DOCUMENTO').Value :=	Pedido;
      dmDAtos.SOperacionInv.FieldByName('FTI_TIPO').Value := integer( toiPedidos);
      dmDAtos.SOperacionInv.FieldByName('FTI_STATUS').Value := 4;
      dmDAtos.SOperacionInv.FieldByName('FTI_VISIBLE').Value :=		True;
      dmDAtos.SOperacionInv.FieldByName('FTI_FECHAEMISION').Value := dmDatosVulcano.qrConsulta.FieldByName('FECHA').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_DEPOSITOSOURCE').Value :=		1;
      dmDAtos.SOperacionInv.FieldByName('FTI_TOTALITEMS').Value := 3;
      dmDAtos.SOperacionInv.FieldByName('FTI_TOTALITEMSINICIAL').Value := dmDatosVulcano.qrConsulta.FieldByName('TotalItems').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_MONEDA').Value := 1;
      dmDAtos.SOperacionInv.FieldByName('FTI_FACTORCAMBIO').Value := 1;
      dmDAtos.SOperacionInv.FieldByName('FTI_TOTALCOSTO').Value := dmDatosVulcano.qrConsulta.FieldByName('TOTALCOSTO').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_TOTALCOSTOREAL').Value := dmDatosVulcano.qrConsulta.FieldByName('TotalCosto').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_CLASIFICACION').Value :=	0;
      dmDAtos.SOperacionInv.FieldByName('FTI_USER').Value :=		1;
      dmDAtos.SOperacionInv.FieldByName('FTI_AUTORIZADOPOR').Value :=	 'Crédito';
      dmDAtos.SOperacionInv.FieldByName('FTI_RESPONSABLE').Value :=	dmDatosVulcano.qrConsulta.FieldByName('CLIENTE').Value ;
      dmDAtos.SOperacionInv.FieldByName('FTI_TIENELOTES').Value :=		FALSE ;
      dmDAtos.SOperacionInv.FieldByName('FTI_UPDATEITEMS').Value :=		TRUE ;
      dmDAtos.SOperacionInv.FieldByName('FTI_TOTALBRUTO').Value :=	dmDatosVulcano.qrConsulta.FieldByName('TotalBruto').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_DESCUENTO1PORCENT').Value :=		0;
      dmDAtos.SOperacionInv.FieldByName('FTI_DESCUENTO1MONTO').Value :=	 dmDatosVulcano.qrConsulta.FieldByName('DESCUENTO').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_DESCUENTO1ORIGEN').Value := 1;
      dmDAtos.SOperacionInv.FieldByName('FTI_DESCUENTO2PORCENT').Value :=	0;
      dmDAtos.SOperacionInv.FieldByName('FTI_DESCUENTO2MONTO').Value :=	0;
      dmDAtos.SOperacionInv.FieldByName('FTI_DESCUENTO2ORIGEN').Value := 1;
      dmDAtos.SOperacionInv.FieldByName('FTI_DESCUENTOPARCIAL').Value := 0;
      dmDAtos.SOperacionInv.FieldByName('FTI_FLETEPORCENT').Value := 0;
      dmDAtos.SOperacionInv.FieldByName('FTI_FLETEMONEDA').Value :=	0;
      dmDAtos.SOperacionInv.FieldByName('FTI_FLETEORIGEN').Value :=	1;
      dmDAtos.SOperacionInv.FieldByName('FTI_BASEIMPONIBLE').Value :=	dmDatosVulcano.qrConsulta.FieldByName('BaseImpuesto').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_BASEIMPONIBLE2').Value :=	0;
      dmDAtos.SOperacionInv.FieldByName('FTI_IMPUESTO1PORCENT').Value := 16;
      dmDAtos.SOperacionInv.FieldByName('FTI_IMPUESTO1MONTO').Value :=	dmDatosVulcano.qrConsulta.FieldByName('IMPUESTO').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_IMPUESTO2PORCENT').Value := 0;
      dmDAtos.SOperacionInv.FieldByName('FTI_IMPUESTO2MONTO').Value := 0;
      dmDAtos.SOperacionInv.FieldByName('FTI_DESCUENTOCUADRE').Value :=	0;
      dmDAtos.SOperacionInv.FieldByName('FTI_TOTALNETO').Value :=	dmDatosVulcano.qrConsulta.FieldByName('TOTAL').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_FECHAVENCIDO').Value := dmDatosVulcano.qrConsulta.FieldByName('FECHAENTREGA').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_DIASVENCIMIENTO').Value :=	15;
      dmDAtos.SOperacionInv.FieldByName('FTI_NITCLIENTE').Value := dmDatosVulcano.qrConsulta.FieldByName('NITAUX').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_PERSONACONTACTO').Value :=		dmDatosVulcano.qrConsulta.FieldByName('NOMBRECLIENTE').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_TELEFONOCONTACTO').Value :=	 dmDatosVulcano.qrConsulta.FieldByName('TELCLIENTE').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_DIRECCIONDESPACHO').Value :=		dmDatosVulcano.qrConsulta.FieldByName('DIRCLIENTE').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_DETALLECOMENTARIO').Value :=	dmDatosVulcano.qrConsulta.FieldByName('OBSERVACION').AsString;
      dmDAtos.SOperacionInv.FieldByName('FTI_EXISTEPLANILLAIMPORTACION').Value :=	FALSE;
      dmDAtos.SOperacionInv.FieldByName('FTI_SALDOOPERACION').Value := dmDatosVulcano.qrConsulta.FieldByName('TOTAL').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_MONEDAPAGO').Value := 1;
      dmDAtos.SOperacionInv.FieldByName('FTI_TOTALPRECIO').Value :=	dmDatosVulcano.qrConsulta.FieldByName('TotalBruto').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_VUELTO').Value :=	0;
      dmDAtos.SOperacionInv.FieldByName('FTI_EXCENTO').Value :=		FALSE;
      dmDAtos.SOperacionInv.FieldByName('FTI_COSTODEVENTA').Value := dmDatosVulcano.qrConsulta.FieldByName('Costo').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_VENDEDORASIGNADO').Value := dmDatosVulcano.qrConsulta.FieldByName('VENDEDOR').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_ZONAVENTA').Value :=	'00001';
      dmDAtos.SOperacionInv.FieldByName('FTI_COBRADORASIGNADO').Value := dmDatosVulcano.qrConsulta.FieldByName('VENDEDOR').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_MULTIPLEVENDEDOR').Value := FALSE;
      dmDAtos.SOperacionInv.FieldByName('FTI_MULTIPLEDEPOSITO').Value := FALSE;
      dmDAtos.SOperacionInv.FieldByName('FTI_TIPOPRECIO').Value := 0;
      dmDAtos.SOperacionInv.FieldByName('FTI_MACHINENAME').Value :=	 dmDatosVulcano.qrConsulta.FieldByName('VENDEDOR').Value;
      dmDAtos.SOperacionInv.FieldByName('FTI_COMISIONVENTA').Value :=		0;
      dmDAtos.SOperacionInv.FieldByName('FTI_MONTOPAGADO').Value :=		0;
      dmDAtos.SOperacionInv.FieldByName('FTI_MONTOPERIODO').Value :=		0;
      dmDAtos.SOperacionInv.FieldByName('FTI_PORCENTPERIODO').Value :=		0;
      dmDAtos.SOperacionInv.FieldByName('FTI_HORA').Value :=	Now;
      dmDAtos.SOperacionInv.FieldByName('FTI_CTOCOSTO').Value :=	'';
      dmDAtos.SOperacionInv.FieldByName('FTI_COSTOACTUALNACIONAL').Value :=	'4000';
      dmDAtos.SOperacionInv.FieldByName('FTI_COSTOACTUALEX').Value := 0;
      dmDAtos.SOperacionInv.FieldByName('FTI_COSTOAJUSTADO').Value :=	0;
      dmDAtos.SOperacionInv.FieldByName('FTI_FECHALIBRO').Value := dmDatosVulcano.qrConsulta.FieldByName('FECHA').Value;

      dmDAtos.SOperacionInv.Post;

      while not dmDatosVulcano.qrConsulta.EOF
        and (Pedido = dmDatosVulcano.qrConsulta.FieldByName('PEDIDO').Value) do
      begin
        dmDatos.SDetalleVenta.Append;

        dmDatos.SDetalleVenta.FieldByName('FDI_TIPOOPERACION').Value := integer( toiPedidos);
        dmDatos.SDetalleVenta.FieldByName('FDI_CODIGO').Value :=  dmDatosVulcano.qrConsulta.FieldByName('CodProducto').Value ;
        dmDatos.SDetalleVenta.FieldByName('FDI_LINEA').Value := dmDatosVulcano.qrConsulta.FieldByName('Item').Value ;
        dmDatos.SDetalleVenta.FieldByName('FDI_DOCUMENTO').Value := Pedido;
        dmDatos.SDetalleVenta.FieldByName('FDI_CLIENTEPROVEEDOR').Value := dmDatosVulcano.qrConsulta.FieldByName('CLIENTE').Value ;
//        dmDatos.SDetalleVenta.FieldByName('FDI_DOCUMENTOORIGEN').Value :=
//       dmDatos.SDetalleVenta.FieldByName('FDI_LINEAORIGEN').Value :=
        dmDatos.SDetalleVenta.FieldByName('FDI_CLASIFICACION').Value := 0;
        dmDatos.SDetalleVenta.FieldByName('FDI_STATUS').Value := 4;
        dmDatos.SDetalleVenta.FieldByName('FDI_VISIBLE').Value :=  True;
        dmDatos.SDetalleVenta.FieldByName('FDI_COSTO').Value := dmDatosVulcano.qrConsulta.FieldByName('Costo').Value ;
        dmDatos.SDetalleVenta.FieldByName('FDI_CANTIDAD').Value := dmDatosVulcano.qrConsulta.FieldByName('Cant').Value ;
        dmDatos.SDetalleVenta.FieldByName('FDI_CANTIDADPENDIENTE').Value := dmDatosVulcano.qrConsulta.FieldByName('Cant').Value ;
//        dmDatos.SDetalleVenta.FieldByName('FDI_LOTE').Value :=
        dmDatos.SDetalleVenta.FieldByName('FDI_LOTERANDOM').Value := 0;
        dmDatos.SDetalleVenta.FieldByName('FDI_NEWLOTE').Value :=  False;
        dmDatos.SDetalleVenta.FieldByName('FDI_DEPOSITOSOURCE').Value := 1;
//        dmDatos.SDetalleVenta.FieldByName('FDI_DEPOSITOTARGET').Value :=
        dmDatos.SDetalleVenta.FieldByName('FDI_OPERACION_AUTOINCREMENT').Value := dmDatos.SOperacionInv.FieldByName('BASE_AUTOINCREMENT').Value;
        dmDatos.SDetalleVenta.FieldByName('FDI_DECIMALES').Value := False;
        dmDatos.SDetalleVenta.FieldByName('FDI_DECIMALESPEN').Value := False;
        Randomize;
        dmDatos.SDetalleVenta.FieldByName('FDI_SERIALNUMBER').Value := Random(674413959);
        dmDatos.SDetalleVenta.FieldByName('FDI_USASERIALES').Value := False;
        dmDatos.SDetalleVenta.FieldByName('FDI_USADEPOSITOS').Value := False;
        dmDatos.SDetalleVenta.FieldByName('FDI_COSTOOPERACION').Value := dmDatosVulcano.qrConsulta.FieldByName('CostoOperacion').Value ;
//        dmDatos.SDetalleVenta.FieldByName('FDI_MEMODETALLE').Value :=
        dmDatos.SDetalleVenta.FieldByName('FDI_MONEDA').Value := 1;
        dmDatos.SDetalleVenta.FieldByName('FDI_FACTORCAMBIO').Value := 1;
//        dmDatos.SDetalleVenta.FieldByName('FDI_DETALLECOSTOIMPORTACION').Value :=
//        dmDatos.SDetalleVenta.FieldByName('FDI_DETALLEPLANILLAIMPORTACION').Value :=
//        dmDatos.SDetalleVenta.FieldByName('FDI_EXISTEDETALLEIMPORTACION').Value :=
//        dmDatos.SDetalleVenta.FieldByName('FDI_EXISTEDETALLEDECOSTO').Value :=
        dmDatos.SDetalleVenta.FieldByName('FDI_ALICUOTAFLETEOTROS').Value := 0;
        dmDatos.SDetalleVenta.FieldByName('FDI_IMPUESTO1').Value := dmDatosVulcano.qrConsulta.FieldByName('Iva').Value ;
        dmDatos.SDetalleVenta.FieldByName('FDI_PORCENTIMPUESTO1').Value := True;
        dmDatos.SDetalleVenta.FieldByName('FDI_MONTOIMPUESTO1').Value := (dmDatosVulcano.qrConsulta.FieldByName('PrecioUnd').Value - dmDatosVulcano.qrConsulta.FieldByName('DescuentoReg').Value) *
                                                                          dmDatosVulcano.qrConsulta.FieldByName('Iva').Value / 100 ;
        dmDatos.SDetalleVenta.FieldByName('FDI_IMPUESTO2').Value := 0;
        dmDatos.SDetalleVenta.FieldByName('FDI_PORCENTIMPUESTO2').Value := false;
        dmDatos.SDetalleVenta.FieldByName('FDI_MONTOIMPUESTO2').Value := 0;
        dmDatos.SDetalleVenta.FieldByName('FDI_ORIGENPRICE').Value := 3;
        dmDatos.SDetalleVenta.FieldByName('FDI_PORCENTDESCPARCIAL').Value := dmDatosVulcano.qrConsulta.FieldByName('DescuentoReg').Value ;
        dmDatos.SDetalleVenta.FieldByName('FDI_DESCUENTOPARCIAL').Value := 0;
        dmDatos.SDetalleVenta.FieldByName('FDI_PRECIOSINDESCUENTO').Value := dmDatosVulcano.qrConsulta.FieldByName('PrecioUnd').Value;
        dmDatos.SDetalleVenta.FieldByName('FDI_PRECIOCONDESCUENTO').Value := dmDatosVulcano.qrConsulta.FieldByName('PrecioUnd').Value - dmDatosVulcano.qrConsulta.FieldByName('DescuentoReg').Value;
        dmDatos.SDetalleVenta.FieldByName('FDI_PRECIODEVENTA').Value := dmDatosVulcano.qrConsulta.FieldByName('PrecioUnd').Value;
        dmDatos.SDetalleVenta.FieldByName('FDI_ROUNDDESCTPARCIAL').Value := 0;
        dmDatos.SDetalleVenta.FieldByName('FDI_COMISIONFIJA').Value := 0;
        dmDatos.SDetalleVenta.FieldByName('FDI_COMISIONFIJAP').Value := False;
        dmDatos.SDetalleVenta.FieldByName('FDI_UNDDESCARGA').Value := 1;
        dmDatos.SDetalleVenta.FieldByName('FDI_UNDCAPACIDAD').Value := 1;
        dmDatos.SDetalleVenta.FieldByName('FDI_UNDDETALLADA').Value := False;
        dmDatos.SDetalleVenta.FieldByName('FDI_INDEXPRICES').Value := 1;
        dmDatos.SDetalleVenta.FieldByName('FDI_PARTESUSANSERIALES').Value := False;
        dmDatos.SDetalleVenta.FieldByName('FDI_COSTODEVENTAS').Value := dmDatosVulcano.qrConsulta.FieldByName('Costo').Value;
//        dmDatos.SDetalleVenta.FieldByName('FDI_DESCRIPCIONOFERTA').Value :=
        dmDatos.SDetalleVenta.FieldByName('FDI_VENDEDORASIGNADO').Value := dmDatosVulcano.qrConsulta.FieldByName('Vendedor').Value;
        dmDatos.SDetalleVenta.FieldByName('FDI_MONTOCOMISION').Value := 0;
        dmDatos.SDetalleVenta.FieldByName('FDI_PRECIOBASECOMISION').Value := dmDatos.SDetalleVenta.FieldByName('FDI_PRECIOCONDESCUENTO').Value;
        dmDatos.SDetalleVenta.FieldByName('FDI_COMISIONBLOQUEADA').Value := False;
        dmDatos.SDetalleVenta.FieldByName('FDI_COMISIONYAPAGADA').Value := False;
//        dmDatos.SDetalleVenta.FieldByName('FDI_DOCUMENTOLIBERADO').Value :=
        dmDatos.SDetalleVenta.FieldByName('FDI_TIPODECOMISION').Value := 0;
        dmDatos.SDetalleVenta.FieldByName('FDI_PRICEFORCOMISION').Value := 1;
        dmDatos.SDetalleVenta.FieldByName('FDI_FECHAOPERACION').Value := dmDatosVulcano.qrConsulta.FieldByName('Fecha').Value;
        dmDatos.SDetalleVenta.FieldByName('FDI_USER').Value := 1;
        dmDatos.SDetalleVenta.FieldByName('FDI_PORCENTDESCUENTO1').Value := 0;
        dmDatos.SDetalleVenta.FieldByName('FDI_PORCENTDESCUENTO2').Value := 0;
//        dmDatos.SDetalleVenta.FieldByName('FDI_COSTOUPDATE').Value :=
        dmDatos.SDetalleVenta.FieldByName('FDI_TOTALPESO').Value := 0;
//        dmDatos.SDetalleVenta.FieldByName('FDI_CTOCOSTO').Value :=
//        dmDatos.SDetalleVenta.FieldByName('FDI_AUTORIZADO').Value :=
//        dmDatos.SDetalleVenta.FieldByName('FDI_MARKPERIODO').Value :=
//        dmDatos.SDetalleVenta.FieldByName('FDI_CTOCOSTOSTR').Value :=
        dmDatos.SDetalleVenta.FieldByName('FDI_COSTOACTUALNACIONAL').Value := dmDatosVulcano.qrConsulta.FieldByName('Costo').Value;
        dmDatos.SDetalleVenta.FieldByName('FDI_COSTOACTUALEXT').Value := 0;
//        dmDatos.SDetalleVenta.FieldByName('FDI_PREFIXINVENTARIO').Value :=
        dmDatos.SDetalleVenta.FieldByName('FDI_COSTOAJUSTADO').Value := 0 ;
//        dmDatos.SDetalleVenta.FieldByName('FDI_FECHALIBRO').Value :=
//        dmDatos.SDetalleVenta.FieldByName('FDI_MONTOLIQUIDADO').Value :=
//        dmDatos.SDetalleVenta.FieldByName('FDI_TIPODOCUMENTOORIGEN').Value := 0;
//        dmDatos.SDetalleVenta.FieldByName('FDI_STATUSDOCUMENTOSORIGEN').Value := 0;

        dmDatos.SDetalleVenta.Post;

        dmDatosVulcano.MarcarPedidoEnviado(Pedido);

        dmDatosVulcano.qrConsulta.Next;
      end;
    end;


    Result.AddElement(TJSONObject.Create(
              TJSONPair.Create('resultado', 'Datos Sincronizados')));
  except on E: Exception do
     Result.AddElement(TJSONObject.Create(
              TJSONPair.Create('error', E.Message)));
  end;

  dmDatos.SDetalleVenta.Close;
  dmDatos.SOperacionInv.Close;
end;

function TServerMethods1.getElementoInventario(Campo: Integer;
  Valor: String): TJSONArray;
var
  jRecord, JPrecio : TJSONObject;
  JRecordCosto : TJSONArray;
  I, J: Integer;
begin

  dmDatos.ConsultarUnElementoInventario( Campo, Valor);
  Result := TJSonArray.Create;

  while not dmDatos.qrUnElementoInventario.EOF do
  begin
    jRecord := TJSONObject.Create;
    for I := 0 to dmDatos.qrUnElementoInventario.FieldCount - 1 do
    begin
      if dmDatos.qrUnElementoInventario.Fields[I].FieldName <> 'Costos'then
      begin
        jRecord.AddPair(
          dmDatos.qrUnElementoInventario.Fields[I].FieldName,
          TJSONString.Create (dmDatos.qrUnElementoInventario.Fields[I].AsString));
        Result.AddElement(jRecord);
      end
      else
      begin
        // Carga el costo de sfixed
        dmAdministrativo.CargarTablaCostos(TDBISAMTable(dmDatos.qrUnElementoInventario),
          TBlobField(dmDatos.qrUnElementoInventario.FieldByName('Costos')));

        // CArga los campos del costo
        dmAdministrativo.tbCostos.First;
        for J := 0 to dmAdministrativo.tbCostos.FieldCount -1 do
        begin
          jRecord.AddPair(
            dmAdministrativo.tbCostos.Fields[J].FieldName,
            TJSONString.Create (dmAdministrativo.tbCostos.Fields[J].AsString));
        end;

        // Cargo los campos de los precios
        JRecordCosto := TJSONArray.Create;

        dmAdministrativo.tbPrecios.First;
        while not dmAdministrativo.tbPrecios.Eof do
        begin

          // Genero el elemento precio
          JPrecio := TJSONObject.Create;
          for J := 0 to dmAdministrativo.tbPrecios.FieldCount -1 do
          begin
            JPrecio.AddPair(
                dmAdministrativo.tbPrecios.Fields[J].FieldName,
                TJSONString.Create (dmAdministrativo.tbPrecios.Fields[J].AsString));
          end;

          // Adiciono el elemento precio
          JRecordCosto.AddElement( JPrecio);

          dmAdministrativo.tbPrecios.Next;
        end;
      end;
    end;
    dmDatos.qrUnElementoInventario.Next;
  end;
  dmDatos.qrUnElementoInventario.Close;
end;

end.

