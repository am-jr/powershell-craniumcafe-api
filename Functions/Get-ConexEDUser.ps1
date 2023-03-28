function Get-ConexEDUser {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$email,
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

    $uri = "$url/rest/v3/meetings/user"

    $SearchParameters = @{ email = $email }

    $HttpValueCollection = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    foreach ($Item in $SearchParameters.GetEnumerator()) {
        if ($Item.Value.Count -gt 0) {
            $HttpValueCollection.Add($Item.Key, $Item.Value)
        }
    }

    $QueryUri = [System.UriBuilder]($Uri)
    $QueryUri.Query = $HttpValueCollection.ToString()

    $queryArgs = @{
        'URI'     = "$($QueryUri.Uri.AbsoluteUri)"
        'Headers' = $headers
        'Method'  = 'GET'
    }

    $results = Invoke-RestMethod @queryArgs
    Return $results
}