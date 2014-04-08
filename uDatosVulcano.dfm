object dmDatosVulcano: TdmDatosVulcano
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 313
  Width = 464
  object dbVulcano: TADOConnection
    ConnectionString = 
      'Provider=SQLNCLI11.1;Integrated Security=SSPI;Persist Security I' +
      'nfo=False;User ID="";Initial Catalog=Vulcano1;Data Source=.;Use ' +
      'Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Wor' +
      'kstation ID=SX-MACW;Initial File Name="";Use Encryption for Data' +
      '=False;Tag with column collation when possible=False;MARS Connec' +
      'tion=False;DataTypeCompatibility=0;Trust Server Certificate=Fals' +
      'e;Application Intent=READWRITE;'
    LoginPrompt = False
    Provider = 'SQLNCLI11.1'
    Left = 48
    Top = 24
  end
  object Clientesso: TADOTable
    Connection = dbVulcano
    CursorType = ctStatic
    TableName = 'Clientesso'
    Left = 152
    Top = 24
    object ClientessoNit: TWideStringField
      FieldName = 'Nit'
      Size = 30
    end
    object ClientessoSuc: TIntegerField
      FieldName = 'Suc'
    end
    object ClientessoNombre: TWideStringField
      FieldName = 'Nombre'
      Size = 50
    end
    object ClientessoContacto: TWideStringField
      FieldName = 'Contacto'
      Size = 50
    end
    object ClientessoDireccion: TWideStringField
      FieldName = 'Direccion'
      Size = 100
    end
    object ClientessoBarrio: TWideStringField
      FieldName = 'Barrio'
      Size = 50
    end
    object ClientessoCiudad: TWideStringField
      FieldName = 'Ciudad'
      Size = 50
    end
    object ClientessoPais: TWideStringField
      FieldName = 'Pais'
      Size = 50
    end
    object ClientessoTel1: TWideStringField
      FieldName = 'Tel1'
      Size = 30
    end
    object ClientessoCupo: TWideStringField
      FieldName = 'Cupo'
      Size = 50
    end
    object ClientessoVD: TWideStringField
      FieldName = 'VD'
      Size = 30
    end
    object ClientessoEstado: TWideStringField
      FieldName = 'Estado'
      Size = 3
    end
    object ClientessoTel2: TWideStringField
      FieldName = 'Tel2'
      Size = 30
    end
    object ClientessoTel3: TWideStringField
      FieldName = 'Tel3'
      Size = 30
    end
    object ClientessoTel4: TWideStringField
      FieldName = 'Tel4'
      Size = 30
    end
    object ClientessoFax: TWideStringField
      FieldName = 'Fax'
      Size = 30
    end
    object ClientessoMail: TWideStringField
      FieldName = 'Mail'
      Size = 50
    end
    object ClientessoCupoDisponible: TBCDField
      FieldName = 'CupoDisponible'
      Precision = 18
      Size = 0
    end
    object ClientessoObservaciones: TWideStringField
      FieldName = 'Observaciones'
      Size = 100
    end
    object ClientessoCumple: TWideStringField
      FieldName = 'Cumple'
      Size = 30
    end
    object ClientessoAutor: TWideStringField
      FieldName = 'Autor'
      Size = 30
    end
    object ClientessoBenreteiva: TWideStringField
      FieldName = 'Benreteiva'
      Size = 30
    end
    object ClientessoLP: TWideStringField
      FieldName = 'LP'
      Size = 30
    end
    object ClientessoUsuario: TIntegerField
      FieldName = 'Usuario'
    end
    object ClientessoNitAux: TWideStringField
      FieldName = 'NitAux'
      Size = 50
    end
  end
  object Productosso: TADOTable
    Connection = dbVulcano
    CursorType = ctStatic
    TableName = 'Productosso'
    Left = 240
    Top = 24
    object ProductossoProducto: TWideStringField
      FieldName = 'Producto'
      Size = 30
    end
    object ProductossoNombre: TWideStringField
      FieldName = 'Nombre'
      Size = 100
    end
    object ProductossoReferencia: TWideStringField
      FieldName = 'Referencia'
      Size = 30
    end
    object ProductossoPrecio1: TWideStringField
      FieldName = 'Precio1'
      Size = 30
    end
    object ProductossoPrecio2: TWideStringField
      FieldName = 'Precio2'
      Size = 30
    end
    object ProductossoPrecio3: TWideStringField
      FieldName = 'Precio3'
      Size = 30
    end
    object ProductossoPrecio4: TWideStringField
      FieldName = 'Precio4'
      Size = 30
    end
    object ProductossoPrecio5: TWideStringField
      FieldName = 'Precio5'
      Size = 30
    end
    object ProductossoPrecio6: TWideStringField
      FieldName = 'Precio6'
      Size = 30
    end
    object ProductossoPrecio7: TWideStringField
      FieldName = 'Precio7'
      Size = 30
    end
    object ProductossoPrecio8: TWideStringField
      FieldName = 'Precio8'
      Size = 30
    end
    object ProductossoPrecio9: TWideStringField
      FieldName = 'Precio9'
      Size = 30
    end
    object ProductossoPrecio10: TWideStringField
      FieldName = 'Precio10'
      Size = 30
    end
    object ProductossoPrecio11: TWideStringField
      FieldName = 'Precio11'
      Size = 30
    end
    object ProductossoPrecio12: TWideStringField
      FieldName = 'Precio12'
      Size = 30
    end
    object ProductossoCosto1: TWideStringField
      FieldName = 'Costo1'
      Size = 30
    end
    object ProductossoCosto2: TWideStringField
      FieldName = 'Costo2'
      Size = 30
    end
    object ProductossoCantidad: TWideStringField
      FieldName = 'Cantidad'
      Size = 30
    end
    object ProductossoValorInv: TWideStringField
      FieldName = 'ValorInv'
      Size = 30
    end
    object ProductossoIva: TWideStringField
      FieldName = 'Iva'
      Size = 30
    end
    object ProductossoUnitario: TWideStringField
      FieldName = 'Unitario'
      Size = 30
    end
    object ProductossoRet: TWideStringField
      FieldName = 'Ret'
      Size = 30
    end
    object ProductossoUn2: TWideStringField
      FieldName = 'Un2'
      Size = 30
    end
    object ProductossoDescripcion: TWideMemoField
      FieldName = 'Descripcion'
      BlobType = ftWideMemo
    end
  end
  object Cartera: TADOTable
    Connection = dbVulcano
    CursorType = ctStatic
    TableName = 'Cartera'
    Left = 320
    Top = 24
    object CarteraTipo: TWideStringField
      FieldName = 'Tipo'
      Size = 5
    end
    object CarteraDoc: TWideStringField
      FieldName = 'Doc'
      Size = 12
    end
    object CarteraDescripcion: TWideStringField
      FieldName = 'Descripcion'
      Size = 100
    end
    object CarteraNit: TWideStringField
      FieldName = 'Nit'
      Size = 30
    end
    object CarteraCodDoc: TWideStringField
      FieldName = 'CodDoc'
      Size = 30
    end
    object CarteraFechaDoc: TWideStringField
      FieldName = 'FechaDoc'
      Size = 10
    end
    object CarteraFechaVen: TWideStringField
      FieldName = 'FechaVen'
      Size = 10
    end
    object CarteraSaldo: TBCDField
      FieldName = 'Saldo'
      Precision = 18
      Size = 0
    end
    object CarteraCupo: TBCDField
      FieldName = 'Cupo'
      Precision = 18
      Size = 0
    end
    object CarteraSuc: TIntegerField
      FieldName = 'Suc'
    end
  end
  object qrConsulta: TADOQuery
    Connection = dbVulcano
    Parameters = <>
    Left = 152
    Top = 96
  end
  object cmVulcano: TADOCommand
    CommandText = 'update  Pedido set  Enviado = 1 '#13#10'Where Pedido = :Pedido'
    Connection = dbVulcano
    Parameters = <
      item
        Name = 'Pedido'
        Attributes = [paSigned, paNullable]
        DataType = ftBCD
        Precision = 18
        Size = 19
        Value = Null
      end>
    Left = 264
    Top = 104
  end
  object qrPedidos: TADOQuery
    Connection = dbVulcano
    Parameters = <>
    SQL.Strings = (
      'SELECT        TOP (100) PERCENT'
      #9'dbo.Pedido.Pedido,'
      #9'dbo.Pedido.Fecha,'
      
        #9'count(*) over (Partition by Pedido.Pedido Order by Pedido.Pedid' +
        'o) TotalItems,'
      
        #9'Sum( dbo.Detalle_Pedido.Cant * dbo.productosso.Costo1)  over (P' +
        'artition by Pedido.Pedido Order by Pedido.Pedido) TotalCosto,'
      #9'dbo.Pedido.Cliente,'
      #9'dbo.Pedido.SubTotal TotalBruto,'
      #9'dbo.Pedido.Descuento,'
      #9'dbo.Pedido.Vendedor,'
      #9'dbo.Pedido.SubTotal BaseImpuesto,'
      #9'dbo.Pedido.Impuesto,'
      '    dbo.Pedido.Total,'
      #9'dbo.Pedido.FechaEntrega,'
      #9'dbo.clientesso.[NitAux],'
      #9'dbo.clientesso.Nombre NombreCliente,'
      #9'dbo.clientesso.Tel1 TelCliente,'
      #9'dbo.clientesso.Direccion DirCliente,'
      #9'dbo.Pedido.Observacion,'
      ''
      #9'dbo.Detalle_Pedido.CodProducto,'
      #9'dbo.Detalle_Pedido.Cant,'
      #9'dbo.productosso.Costo1 Costo,'
      '  dbo.productosso.Iva,'
      
        #9'dbo.Detalle_Pedido.Cant * dbo.productosso.Costo1 CostoOperacion' +
        ','
      #9'dbo.Detalle_Pedido.DescuentoReg,'
      #9'dbo.Detalle_Pedido.SubtotalReg,'
      #9'dbo.Detalle_Pedido.PrecioUnd,'
      '    dbo.Detalle_Pedido.ValorDescuento,'
      #9'dbo.Detalle_Pedido.RefProducto,'
      
        #9'ROW_NUMBER() over (Partition by Pedido.Pedido Order by Pedido.P' +
        'edido) Item'
      #9#9'FROM dbo.Pedido INNER JOIN'
      
        #9#9#9'dbo.Detalle_Pedido ON dbo.Pedido.Pedido = dbo.Detalle_Pedido.' +
        'Pedido  Inner Join'
      
        #9#9#9'dbo.clientesso On dbo.Pedido.Cliente = dbo.clientesso.Nit Inn' +
        'er Join'
      
        #9#9#9'dbo.ProductosSO On  dbo.Detalle_Pedido.CodProducto = dbo.Prod' +
        'uctosSO.Producto'
      #9#9'WHERE        (dbo.Pedido.Enviado = 0)'
      #9#9'ORDER BY dbo.Pedido.Pedido')
    Left = 192
    Top = 208
  end
end
