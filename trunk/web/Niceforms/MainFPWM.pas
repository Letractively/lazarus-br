// See: http://www.emblematiq.com/lab/niceforms/

unit MainFPWM;

{$mode objfpc}{$H+}

interface

uses
  HTTPDefs, fpHTTP, fpWeb;

type

  { TMainFPWebModule }

  TMainFPWebModule = class(TFPWebModule)
    procedure DataModuleRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  end;

var
  MainFPWebModule: TMainFPWebModule;

implementation

{$R *.lfm}

{ TMainFPWebModule }

procedure TMainFPWebModule.DataModuleRequest(Sender: TObject;
  ARequest: TRequest; AResponse: TResponse; var Handled: Boolean);
begin
  Handled := True;
  AResponse.Content :=
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + LineEnding +
    '<html xmlns="http://www.w3.org/1999/xhtml">' + LineEnding +
    '<head>' + LineEnding +
    '<title>CGI and Niceforms</title>' + LineEnding +
    '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' + LineEnding +
    '<script language="javascript" type="text/javascript" src="/niceforms/niceforms.js"></script>' + LineEnding +
    '<style type="text/css" media="screen">@import url(/niceforms/niceforms-default.css);</style>' + LineEnding +
    '</head>' + LineEnding +
    '<body>' + LineEnding +
    '<div id="container">' + LineEnding +
    '<form action="vars.php" method="post" class="niceform" target="_blank">' + LineEnding +
    '	<select size="1" id="mySelect1" name="mySelect1" class="width_320"> <!-- class="width_320" sets a width of 320px -->' + LineEnding +
    '		<option selected="selected" value="Test area no.1">Test area no.1</option>' + LineEnding +
    '		<option value="Another test option">Another test option</option>' + LineEnding +
    '		<option value="And another one">And another one</option>' + LineEnding +
    '		<option value="One last option for me">One last option for me</option>' + LineEnding +
    '		<option value="This is one really really long option right here just to test it out">This is one really really long option right here just to test it out</option>' + LineEnding +
    '	</select>' + LineEnding +
    '	<br />' + LineEnding +
    '	<select size="1" id="mySelect2" name="mySelect2" class="width_160">' + LineEnding +
    '		<option value="Test area no.2">Test area no.2</option>' + LineEnding +
    '		<option value="Another test">Another test</option>' + LineEnding +
    '		<option selected="selected" value="And another one">And another one</option>' + LineEnding +
    '		<option value="And yet another one">And yet another one</option>' + LineEnding +
    '		<option value="One last option for me">One last option for me</option>' + LineEnding +
    '	</select>' + LineEnding +
    '	<br />' + LineEnding +
    '	<input type="radio" name="radioSet" id="option1" value="foo" checked="checked" /><label for="option1">foo</label><br />' + LineEnding +
    '	<input type="radio" name="radioSet" id="option2" value="bar" /><label for="option2">bar</label><br />' + LineEnding +
    '	<input type="radio" name="radioSet" id="option3" value="another option" /><label for="option3">another option</label><br />' + LineEnding +
    '	<br />' + LineEnding +
    '	<input type="checkbox" name="checkSet1" id="check1" value="foo" /><label for="check1">foo</label><br />' + LineEnding +
    '	<input type="checkbox" name="checkSet2" id="check2" value="bar" checked="checked" /><label for="check2">bar</label><br />' + LineEnding +
    '	<input type="checkbox" name="checkSet3" id="check3" value="another option" /><label for="check3">another option</label><br />' + LineEnding +
    '	<br />' + LineEnding +
    '	<label for="textinput">Username:</label><br />' + LineEnding +
    '	<input type="text" id="textinput" name="textinput" size="12" /><br />' + LineEnding +
    '	<label for="passwordinput">Password:</label><br />' + LineEnding +
    '	<input type="password" id="passwordinput" name="passwordinput" size="20" /><br />' + LineEnding +
    '	<br />' + LineEnding +
    '	<label for="textareainput">Comments:</label><br />' + LineEnding +
    '	<textarea id="textareainput" name="textareainput" rows="10" cols="30"></textarea><br />' + LineEnding +
    '	<br />' + LineEnding +
    '	<input type="submit" value="Submit this form" />' + LineEnding +
    '</form>' + LineEnding +
    '</div>' + LineEnding +
    '</body>' + LineEnding +
    '</html>';
end;

initialization
  RegisterHTTPModule('TMainFPWebModule', TMainFPWebModule);

end.

