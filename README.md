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
