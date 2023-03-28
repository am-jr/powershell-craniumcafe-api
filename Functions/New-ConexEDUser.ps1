function New-ConexEDUser {
    <#
    .SYNOPSIS
        Creates a new user in CraniumCafe.
    .DESCRIPTION
        By default this creates a user and sets them to the America/LosAngeles Pacific TimeZone.
    #>
    param (
        [parameter(Mandatory = $true)]
        [string]$sis_id,
        [parameter(Mandatory = $true)]
        [string]$sso_userid,
        [parameter(Mandatory = $true)]
        [string]$email,
        [parameter(Mandatory = $true)]
        [string]$fullname,
        [parameter(Mandatory = $true)]
        [securestring]$password,
        [string]$timezone = 'America/los_angeles',
        [parameter(Mandatory = $true)]
        [string]$apiusername,
        [parameter(Mandatory = $true)]
        [securestring]$apikey,
        [parameter(Mandatory = $true)]
        [string]$institutionCode,
        $url = 'https://api.craniumcafe.com'
    )

    $headers = @{
        'auth-key'     = $apiusername
        'auth-token'   = "$([Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($apikey)))"
        'Content-Type' = 'application/json'
    }

    $body = @{
        'users' = @(
            @{
                'sis_id'          = $sis_id
                'sso_userid'      = $sso_userid
                'email'           = $email
                'fullname'        = $fullname
                'password'        = "$([Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)))"
                'timezone'        = $timezone
                'institutionCode' = "$institutionCode"
            }
        )
    }

    $restArgs = @{
        'URI'     = "$url/rest/v3/users"
        'Headers' = $headers
        'Body'    = ConvertTo-Json -InputObject $body -Depth 10
        'Method'  = 'POST'
    }

    Invoke-RestMethod @restArgs
}