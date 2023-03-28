function Get-ConexEDMeetingInfo {

    [CmdletBinding()]
    param(
        [int]$meeting_id,
        [parameter(Mandatory = $true)]
        [string]$apiusername,
        [parameter(Mandatory = $true)]
        [securestring]$apikey,
        [string]$url = 'https://api.craniumcafe.com'
    )

    $headers = @{
        'auth-key'     = $apiusername
        'auth-token'   = "$([Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($apikey)))"
        'Content-Type' = 'application/json'
    }

    $uri = "$url/rest/v3/meetings/$meeting_id"

    $restArgs = @{
        'URI'     = $uri
        'Headers' = $headers
        'Method'  = 'GET'
    }

    $results = Invoke-RestMethod @restArgs | ConvertTo-Json -Depth 100
    Return $results
}