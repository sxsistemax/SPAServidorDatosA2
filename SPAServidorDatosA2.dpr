program SPAServidorDatosA2;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uPrincipal in 'uPrincipal.pas' {fmPrincipal},
  ServerMethodsUnit1 in 'ServerMethodsUnit1.pas',
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  uDatos in 'uDatos.pas' {dmDatos: TDataModule},
  uBaseDatosA2 in '..\..\CompartidosA2\uBaseDatosA2.pas' {dmBasesDatos: TDataModule},
  uTablasConBlobAdministrativo in '..\..\CompartidosA2\uTablasConBlobAdministrativo.pas' {dmAdministrativo: TDataModule},
  uDatosVulcano in 'uDatosVulcano.pas' {dmDatosVulcano: TDataModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TdmBasesDatos, dmBasesDatos);
  Application.CreateForm(TdmAdministrativo, dmAdministrativo);
  Application.CreateForm(TdmDatos, dmDatos);
  Application.CreateForm(TfmPrincipal, fmPrincipal);
  Application.CreateForm(TdmDatosVulcano, dmDatosVulcano);
  Application.Run;
end.
