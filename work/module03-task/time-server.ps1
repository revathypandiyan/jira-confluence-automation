function Send-JsonRpcResponse {
    param(
        [object]$Id,
        [object]$Result
    )

    $response = [ordered]@{
        jsonrpc = '2.0'
        id = $Id
        result = $Result
    } | ConvertTo-Json -Depth 20 -Compress

    [Console]::Out.WriteLine($response)
}

function Send-JsonRpcError {
    param(
        [object]$Id,
        [int]$Code,
        [string]$Message
    )

    $response = [ordered]@{
        jsonrpc = '2.0'
        id = $Id
        error = [ordered]@{
            code = $Code
            message = $Message
        }
    } | ConvertTo-Json -Depth 20 -Compress

    [Console]::Out.WriteLine($response)
}

while ($null -ne ($line = [Console]::In.ReadLine())) {
    try {
        $request = $line | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Send-JsonRpcError -Id $null -Code -32700 -Message 'Parse error'
        continue
    }

    $method = $request.method
    $id = $request.id

    if ($method -eq 'initialize') {
        Send-JsonRpcResponse -Id $id -Result ([ordered]@{
            protocolVersion = $request.params.protocolVersion
            capabilities = [ordered]@{
                tools = [ordered]@{}
            }
            serverInfo = [ordered]@{
                name = 'time-server'
                version = '1.0.0'
            }
        })
    }
    elseif ($method -eq 'notifications/initialized') {
        continue
    }
    elseif ($method -eq 'tools/list') {
        Send-JsonRpcResponse -Id $id -Result ([ordered]@{
            tools = @(
                [ordered]@{
                    name = 'get_current_time'
                    description = 'Return the current date and time.'
                    inputSchema = [ordered]@{
                        type = 'object'
                        properties = [ordered]@{}
                    }
                }
            )
        })
    }
    elseif ($method -eq 'tools/call') {
        $toolName = $request.params.name
        if ($toolName -ne 'get_current_time' -and $toolName -ne 'get_time' -and $toolName -ne 'time') {
            Send-JsonRpcError -Id $id -Code -32602 -Message "Unknown tool: $toolName"
            continue
        }

        $currentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Send-JsonRpcResponse -Id $id -Result ([ordered]@{
            content = @(
                [ordered]@{
                    type = 'text'
                    text = $currentTime
                }
            )
        })
    }
    elseif ($null -ne $id) {
        Send-JsonRpcError -Id $id -Code -32601 -Message 'Method not found'
    }
}