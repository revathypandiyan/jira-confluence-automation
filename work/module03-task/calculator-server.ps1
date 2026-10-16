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
                name = 'calculator'
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
                    name = 'calculate'
                    description = 'Performs arithmetic operations: add, subtract, multiply, and divide.'
                    inputSchema = [ordered]@{
                        type = 'object'
                        properties = [ordered]@{
                            operation = [ordered]@{
                                type = 'string'
                                enum = @('add', 'subtract', 'multiply', 'divide')
                                description = 'The arithmetic operation to perform.'
                            }
                            a = [ordered]@{
                                type = 'number'
                                description = 'The first number.'
                            }
                            b = [ordered]@{
                                type = 'number'
                                description = 'The second number.'
                            }
                        }
                        required = @('operation', 'a', 'b')
                    }
                }
            )
        })
    }
    elseif ($method -eq 'tools/call') {
        $toolName = $request.params.name
        if ($toolName -ne 'calculate') {
            Send-JsonRpcError -Id $id -Code -32602 -Message "Unknown tool: $toolName"
            continue
        }

        $args = $request.params.arguments
        $op = [string]$args.operation
        $a = [double]$args.a
        $b = [double]$args.b

        $calcResult = 0
        $isError = $false
        $errorMsg = ''

        switch ($op.ToLower()) {
            'add' {
                $calcResult = $a + $b
            }
            'subtract' {
                $calcResult = $a - $b
            }
            'multiply' {
                $calcResult = $a * $b
            }
            'divide' {
                if ($b -eq 0) {
                    $isError = $true
                    $errorMsg = 'Division by zero is not allowed.'
                }
                else {
                    $calcResult = $a / $b
                }
            }
            default {
                $isError = $true
                $errorMsg = "Unsupported operation: $op. Supported operations: add, subtract, multiply, divide."
            }
        }

        if ($isError) {
            Send-JsonRpcResponse -Id $id -Result ([ordered]@{
                isError = $true
                content = @(
                    [ordered]@{
                        type = 'text'
                        text = $errorMsg
                    }
                )
            })
        }
        else {
            Send-JsonRpcResponse -Id $id -Result ([ordered]@{
                content = @(
                    [ordered]@{
                        type = 'text'
                        text = [string]$calcResult
                    }
                )
            })
        }
    }
    elseif ($null -ne $id) {
        Send-JsonRpcError -Id $id -Code -32601 -Message 'Method not found'
    }
}