object dmDatos: TdmDatos
  OldCreateOrder = False
  Height = 290
  Width = 429
  object qrClientes: TDBISAMQuery
    DatabaseName = 'dbA2'
    EngineVersion = '4.31 Build 3'
    SQL.Strings = (
      'SELECT '
      ' *'
      'FROM'
      ' Sclientes'
      'Where FC_Status = 1')
    Params = <>
    Left = 96
    Top = 48
  end
  object qrUnCliente: TDBISAMQuery
    DatabaseName = 'dbA2'
    EngineVersion = '4.31 Build 3'
    Params = <>
    Left = 176
    Top = 48
  end
  object qrInventario: TDBISAMQuery
    DatabaseName = 'dbA2'
    EngineVersion = '4.31 Build 3'
    SQL.Strings = (
      'SELECT '
      '  Sinventario.*,  SFixed.FX_COSTOS AS Costos'
      'FROM'
      ' Sinventario'
      ' INNER JOIN SFixed ON (Sinventario.FI_CODIGO=SFixed.FX_CODIGO)'
      'WHERE'
      '  (SFixed.FX_TIPO = '#39'B'#39')'
      'and (SInventario.FI_Status = 1)'
      'order by SInventario.FI_CODIGO')
    Params = <>
    Left = 256
    Top = 48
  end
  object qrUnElementoInventario: TDBISAMQuery
    DatabaseName = 'dbA2'
    EngineVersion = '4.31 Build 3'
    Params = <>
    Left = 184
    Top = 120
  end
  object qrConsulta: TDBISAMQuery
    DatabaseName = 'dbA2'
    EngineVersion = '4.31 Build 3'
    Params = <>
    Left = 64
    Top = 200
  end
  object SOperacionInv: TDBISAMTable
    DatabaseName = 'dbA2'
    EngineVersion = '4.31 Build 3'
    TableName = 'SOperacionInv'
    Left = 192
    Top = 200
  end
  object SDetalleVenta: TDBISAMTable
    DatabaseName = 'dbA2'
    EngineVersion = '4.31 Build 3'
    TableName = 'SDetalleVenta'
    Left = 304
    Top = 192
  end
end
