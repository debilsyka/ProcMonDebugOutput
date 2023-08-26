# ProcMonDebugOutput
## See Your Trace Statements in Process Monitor!

**How it's work**

```
uses
  ..., ProcMonLogger;

procedure SomeProcedure;
begin
  OpenProcessMonitorLogger;
  try
    if not ProcMonDebugOutput('Начало процедуры') then
      WriteLn('Ошибка логирования: ', GetLastError);
    
    // Здесь какой-то ваш код
    
    if not ProcMonDebugOutput('Конец процедуры') then
      WriteLn('Ошибка логирования: ', GetLastError);
  finally
    CloseProcessMonitorLogger;
  end;
end;
```
![Procmon](https://github.com/lartsev1337/ProcMonDebugOutput/blob/main/procmon.png?raw=true)

# Example
[CobaltParser/mainwindow.pas](https://github.com/lartsev1337/CobaltParser/blob/main/mainwindow.pas)
