open System.Data
open System.Data.Odbc

let log = printf
let logn = printfn

[<EntryPoint>]
let main _ =
    let connStr = @"DSN=fdbsql;UID=test;PWD=test"
    log "opening connection .... "
    use conn = new OdbcConnection(connStr)
    conn.Open()
    logn "done."
    log "Executing command...."
    let stmt = "SELECT VERSION()"
    let cmd = conn.CreateCommand()
    cmd.CommandText <- stmt
    let res = cmd.ExecuteScalar()
    logn "done"
    logn "Result: %A" res
    log "closing connection .... "
    conn.Close()
    logn "done."
    conn.Dispose()
    0

