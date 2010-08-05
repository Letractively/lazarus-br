{LazAC

Copyright (C) 2010 Elson Junio elsonjunio@yahoo.com.br

This library is free software; you can redistribute it and/or modify it
under the terms of the GNU Library General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at your
option) any later version with the following modification:

As a special exception, the copyright holders of this library give you
permission to link this library with independent modules to produce an
executable, regardless of the license terms of these independent modules,and
to copy and distribute the resulting executable under terms of your choice,
provided that you also meet, for each linked independent module, the terms
and conditions of the license of that module. An independent module is a
module which is not derived from or based on this library. If you modify
this library, you may extend this exception to your version of the library,
but you are not obligated to do so. If you do not wish to do so, delete this
exception statement from your version.

This library is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
for more details.

You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
}
unit LazAC_AO;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ao;

type WStatus=(wPlay, wStop, wPause);
type EAOProcError = class(Exception);

//Eventos
type TReadHeaderEvent=function(): Boolean of object;
type TGetBufferEvent=procedure (var Buffer: PChar; var Size: DWord) of object;
type TGetTotalTimeEvent=procedure (var Time: Double) of object;
type TGetTimeEvent=procedure (var Time: Double) of object;
type TSeekTimeEvent=function (const Time: Double): Boolean of object;
type TResetAudioEvent=procedure of object;
type TOpenAOThreadEvent=function():Boolean of Object;

type


{ TPlayThread }
//Thread para reprodução do áudio
TPlayThread = class(TThread)
private
  FSize:Integer;
  FBuffer:PChar;
  FOwner: TObject;
  FOpenAOThreadEvent: TOpenAOThreadEvent;
  procedure GetBuffer;
  procedure OpenAO;
protected
  procedure Execute; override;
public
  property OpenAOThreadEvent: TOpenAOThreadEvent read FOpenAOThreadEvent write FOpenAOThreadEvent;
  constructor Create(CreateSuspended : boolean; TheOwner: TObject);
end;


{ TAOProc }

TAOProc = class
private
  FGetBufferEvent: TGetBufferEvent;
  FGetTotalTimeEvent: TGetTotalTimeEvent;
  FGetTimeEvent: TGetTimeEvent;
  FReadHeaderEvent: TReadHeaderEvent;
  FResetAudioEvent: TResetAudioEvent;
  FSeekTimeEvent: TSeekTimeEvent;
  procedure PlayThreadFinalize(Sender: TObject);
  function OpenAOThread: Boolean;
protected
  PlayThread: TPlayThread;
  FileStream: TFileStream;
  isPrepared: Boolean;
  FStatus: WStatus;
  DefaultDriver: longint;
  FileName:String;
  FileInfo:TStringList;
public
  Sample_Format: ao_sample_format;
  Device: Pao_Device;
  //--
  property OnGetBufferEvent: TGetBufferEvent read FGetBufferEvent write FGetBufferEvent;
  property OnGetTotalTimeEvent: TGetTotalTimeEvent read FGetTotalTimeEvent write FGetTotalTimeEvent;
  property OnGetTimeEvent: TGetTimeEvent read FGetTimeEvent write FGetTimeEvent;
  property OnReadHeaderEvent: TReadHeaderEvent read FReadHeaderEvent write FReadHeaderEvent;
  property OnResetAudioEvent: TResetAudioEvent read FResetAudioEvent write FResetAudioEvent;
  property OnSeekTimeEvent: TSeekTimeEvent read FSeekTimeEvent write FSeekTimeEvent;
  property Status:WStatus read FStatus;
  property Comments: TStringList read FileInfo;
  //--
  procedure Play;
  procedure Pause;
  procedure Stop;
  function Close:Boolean;
  procedure GetBuffer(var Buffer: PChar; var Size: Integer);
  procedure GetTotalTime(var Time: Double);
  procedure GetTime(var Time: Double);
  function SeekTime(const Time: Double): Boolean;
  function OpenFile(sFile:String):Boolean;
  constructor Create; virtual;
  destructor Destroy; override;
end;

var
  I:Integer=0;
implementation

{ TAOProc }

procedure TAOProc.PlayThreadFinalize(Sender: TObject);
begin
{
Procedimento disparado ao finalizar a thread.
Este evento não é disparado sempre, por exemplo no evento Close,
esta procedure e desvinculada antes de pedir o encerramento da thread.
}
  //Verifica se a variável isPrepared é verdadeira
  if not(isPrepared) then
    begin
      //Verifica se FileStream já foi encerrado
      if (FileStream <> nil) then
        begin
          FileStream.Free; //Libera FileStream
          FileStream:=nil;
          ao_close(Device);//Fecha Dispositivo
          ao_shutdown;     //
        end;
    end
  else
    begin
      //Verifica se FileStream está carregada e execulta o evento
      //ResetAudio que posiciona FileStreeam no início dos dados
      if (FileStream <> nil) and Assigned(FResetAudioEvent) then
        FResetAudioEvent();
      FStatus:=wStop; //Define como Stop
      ao_close(Device); //Fecha Dispositivo
      ao_shutdown;      //
    end;
//Fechar o dispositivo de som ao Responder Stop/Close faz com que
//AO limpe o buffer de dados, que estariam esperando os próximos
//buffer para serem reproduzidos.
end;

function TAOProc.OpenAOThread: Boolean;
begin
{
Este procedimento Abre o dispositivo AO, é execultado sempre que a
thread é execultada.
}

Result:=False;
  //Inicializa AO
  ao_initialize;
  //Retorna Drive Padrão
  DefaultDriver:= ao_default_driver_id();
  if (DefaultDriver < 0) then
    raise EAOProcError.Create('No default driver was returned by AO.');
  //Abre o dispositivo para reprodução
  Device:= ao_open_live(DefaultDriver, @Sample_Format, nil);
  if (Device = nil)then
    raise EAOProcError.Create('No device was returned by AO.');
  //--
Result:=True;
end;

procedure TAOProc.Play;
begin
{
Procedimento para o Play
}
  //Verifica se esta preparado para reproduzir
  if not(isPrepared) or (FStatus=wPlay) then Exit;
  //-----
  //Verifica se esta no estado de Stop
  if (FStatus=wStop) then
    begin
      //Cria uma nova thread
      PlayThread:= TPlayThread.Create(True, Self);
      {$IFDEF WINDOWS}
      //No Windows é nescessário alterar a prioridade da thread
      //pois a thread usa Synchronize para receber o Buffer
      //o que pode causar picotes no áudio se o Formulário estiver
      //respondendo a outro processo.
      PlayThread.Priority:=tpHigher;
      {$ENDIF}
      //Vincula o procedimente PlayThreadFinalize ao evento OnTerminate
      PlayThread.OnTerminate:=@PlayThreadFinalize;
      //Vincula o procedimento OpenAOThread ao evento OpenAOThreadEvent
      PlayThread.OpenAOThreadEvent:=@OpenAOThread;
      //Define o estado como reprodução
      FStatus:=wPlay;
      //Libera a thread para executar
      PlayThread.Resume;
    end;
//Se o estado não for Stop provavelmente será Pause e
//é preciso somente trocar o Status de Stop para Play
//para que a thread volte a reproduzir o Áudio

FStatus:=wPlay;
end;

procedure TAOProc.Pause;
begin
{Apendas troca o Status para Pause, a thread continuará
em execução mas não executará o audio}
  if (FStatus= wPlay) then
  FStatus:=wPause;
end;

procedure TAOProc.Stop;
begin
{Alem de alterar o stado para Stop ele pede para a thread terminar
Ao terminar a thread executará o procedimento PlayThreadFinalize}
  if (FStatus = wStop) then Exit;
  PlayThread.Terminate;
end;

function TAOProc.Close: Boolean;
begin
Result:= False;
  //Verifica se está preparado
  if not(isPrepared) then Exit;
  if (FStatus<>wStop) then //Verifica se o estado e Stop
    begin
      //Execulta se o estado for Play ou Pause
      isPrepared:=False; //Define preparado como False
      PlayThread.Terminate; //Pede para thread terminar
    end
  else if (FileStream <> nil) then
    begin
      //Execulta se o estado for Stop
      FileStream.Free;//Libera FileStream
      FileStream:=nil;
    end;
Result:= True;
end;

procedure TAOProc.GetBuffer(var Buffer: PChar; var Size: Integer);
begin
  //Verifica se FGetBufferEvent foi inicializado
  //este procedimento é responsável por receber o
  //o buffer de audio.
  //
  //
  // THREAD -> GetBuffer -> FGetBufferEvent(Classes Filhas-leitura do Buffer)
  //
  if Assigned(FGetBufferEvent) then FGetBufferEvent(Buffer, Size);
end;

procedure TAOProc.GetTotalTime(var Time: Double);
begin
  //Retorna o tempo total do arquivo
  //Evento que deve ser respondido pelas classes filhas
  Time:= 0;
  if Assigned(FGetTotalTimeEvent) then FGetTotalTimeEvent(Time);
end;

procedure TAOProc.GetTime(var Time: Double);
begin
  //Retorna o tempo de execução
  //Evento que deve ser respondido pelas classes filhas
  Time:= 0;
  if Assigned(FGetTimeEvent) then FGetTimeEvent(Time);
end;

function TAOProc.SeekTime(const Time: Double): Boolean;
begin
  //Posiciona a reprodução em um tempo
  //Evento que deve ser respondido pelas classes filhas
  Result:=False;
  if Assigned(FSeekTimeEvent) then Result:= FSeekTimeEvent(Time);
end;

function TAOProc.OpenFile(sFile: String): Boolean;
begin
Result:=False;
  {Procedimento de abertura de um arquivo}
  //Se já estiver com um arquivo aberto ele sai
  if isPrepared then Exit;
  //Define o Status como Stop
  FStatus:=wStop;
  if not(FileExists(sFile)) then Exit;
  if (FileStream <> nil) then FileStream.Free;
  FileStream:=TFileStream.Create(SFile ,fmOpenRead);
  //--
  //Vaz o recohnecimento do arquiv
  //Evento que deve ser respondido pelas classes filhas
  if Assigned(FReadHeaderEvent) then
    begin
      if not(FReadHeaderEvent()) then
        begin
          //Libera FileStream se o arquivo não é válido
          FileStream.Free;
          FileStream:= nil;
          Exit;
        end;
    end
  else
     begin
       //Libera FileStream se FReadHeaderEvent não foi inicializado
       FileStream.Free;
       FileStream:= nil;
       Exit;
     end;
//--------
  //Marca o Nome do arquivo
  FileName:= sFile; //>>Obs: Pode ser desnecessário
  isPrepared:= True;//Marca como preparado
Result:= True;
end;

constructor TAOProc.Create;
begin
  InitHandleAO; //Executa procedimento para carga da biblioteca OA
  Device:=nil;  //Inicializa algumas variáveis
  PlayThread:= nil;
  FStatus:= wStop;
  isPrepared:= False;
  FileInfo:=TStringList.Create;
end;

destructor TAOProc.Destroy;
begin
  if (FStatus<>wStop) then
    begin
      //Somente é execultado se o Status é Play/Pause
      //Retira o vinculo do evento OnTerminate e PlayThreadFinalize
      PlayThread.OnTerminate:=nil;
      //Pede para a thread Finalizar
      PlayThread.Terminate;
      //Este tempo pode ser menor, mas para uma faixa de segurança
      //mantive 300, isso evita um erro no Linux.
      Sleep(300);
      //Fecha o dispositivo de áudio de AO.
      ao_close(Device);
      ao_shutdown;
    end;
      //--
  if (FileStream <> nil) then
    begin
      //Libera FileStream
      FileStream.Free;
      FileStream:=nil;
    end;
  //--
  //Libera FileInfo
  FileInfo.Free;
  inherited Destroy;
end;


{ TWavThread }

procedure TPlayThread.Execute;
procedure FreeBuffer;
begin
//Libera o Buffer, o mesmo é inicializado
//em GetBuffer na Classe filha e finalizado aqui.
  if (FBuffer <> nil) then
    begin
      FreeMem(FBuffer);
      FBuffer:=nil;
    end;
end;

var
  Owner:TAOProc;
{$IFDEF WINDOWS}
  //Se for Windows cria estas variáveis
  Sec:Integer;
  CalcSleep:Integer=0;
  BufferRead:Int64=0;
{$ENDIF}
begin
  //Owner é do tipo TAOProc, é Usado para a thread ter acesso aos dados
  //no TAOProc dono da Thread.
  Owner:=TAOProc(FOwner);
  if not(Owner.isPrepared) then Exit; //verifica se está preparado
  Synchronize(@OpenAO); //Sincroniza a inicialização do dispositivo AO

  //Laço responsável pela reprodução de áudio
  //enquanto estiver preparado|não estiver em stop e não for marcado para terminar e
  //filestream diferente de nil
  While (Owner.isPrepared) and (Owner.Status<>wStop) and not(Terminated) and
        (Owner.FileStream <> nil) do
    begin
      FSize:=0;
      //Se o estado for igula a play
      //Se o estado for pause ele continua dentro do laço, mas não le e reproduz
      //os dados
      if (Owner.Status=wPlay) then
        begin
            //Sincroniza o recebimento do buffer de áudio
            //Sincronizar evita erros.
            Synchronize(@GetBuffer);
            //FSize é passado como parâmetro na requisição de buffer
            //retorna quantos bytes estão na variável buffer
            if (FSize > 0) then
              begin
                //Antes de iniciar a reprodução verifica se o status não
                //mudou enquanto ele recebia os dados
                //isso evita que AO esteja fechado enquanto ele tenta reproduzir
                //os dados.
                if Terminated or (Owner.Status = wStop) then
                  begin
                    //Libera Buffer
                    FreeBuffer;
                    Exit;
                  end;
{$IFDEF WINDOWS}
//A forma de reprodução entre Windows e Linux é difere,
//no Windows a função ao_play é imediatamente liberada apos
//o recebimento dos dados no buffer.
//No Linux a função ao_play não é liberada até
//que os dados tenham sido reproduzido.
//Este é o motivo de um delay no Windows, pois ele acumula os
//dados em um buffer proprio e libera o programa para
//continuar acumulando dados.
//Para tentar corrigir isso, essa parte cria um delay
//com o tempo aproximado de reprodução dos dados
                    Inc(BufferRead, FSize); //Faz  BufferRead := BufferRead + FSize
                    //Sec o tamanho que FSize teria que ter para haver uma
                    //reprodução de áudio de um segundo
                    Sec:=(Owner.Sample_Format.bits div 8 * Owner.Sample_Format.channels * Owner.Sample_Format.rate);
                    //so começa a produzir o delay depois que
                    //for lido dados para reprodução de 1/2 segundo(500ms)
                    if ((BufferRead) > (Int64(Sec) div 2)) then
                      begin
                        //Isso faz um acúmulo em calcSleep
                        //Inclui o deley que seria preciso
                        //por alguns valores serem pequenos demais
                        //os valores são acumulados em CalcSleep
                        Inc(CalcSleep, ((FSize * 1000) div Sec) div Owner.Sample_Format.channels);
                        //Verifica se o valor acumulado em CalcSleep
                        //é maior que 100
                        if (CalcSleep > 100) then
                          begin
                            Sleep(CalcSleep);//Executa Sleep no tempo indicado
                                             //por CalcSleep
                            CalcSleep:=0;    //Zera CalcSleep
                          end;
                      end;
{$ENDIF}
                //Chama ao_play para execultar o buffer de áudio
                ao_play(Owner.Device, FBuffer, FSize);
                FreeBuffer;//Libera Bufffer
              end
            else
              Break;//Se FSize for menor ou igual a zero finaliza a thread
        end;
      //Se o status estiver em Pause
      //Faz um sleep de 500ms isso evita um loop estressante
      if (Owner.Status=wPause) then Sleep(500);
    end;
    //Libera o buffer
    FreeBuffer;
end;

procedure TPlayThread.GetBuffer;
begin
  //Pede buffer
  TAOProc(FOwner).GetBuffer(FBuffer, FSize);
end;

procedure TPlayThread.OpenAO;
var
  Ret:Boolean;
begin
  //Abre o dispositivo AO
  if Assigned(FOpenAOThreadEvent) then Ret:= FOpenAOThreadEvent();
  if not(Ret) then Terminate;
end;

constructor TPlayThread.Create(CreateSuspended: boolean; TheOwner: TObject);
begin
  //Liberar a thread apos terminar
  FreeOnTerminate:= True;
  //Cria a thread de forma suspensa
  inherited Create(CreateSuspended);
  //Define FOwner
  FOwner:=TheOwner;
  FSize:=0;
end;

end.

