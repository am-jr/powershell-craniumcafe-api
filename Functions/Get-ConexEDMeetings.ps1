function Get-ConexEDMeetings {
    [CmdletBinding()]
    param(
        [int]$Page = 1,
        [DateTime]$CurrentTime = ([datetime]::Now.ToUniversalTime()),
        [int]$days = 1,
        [parameter(Mandatory = $true)]
        [string]$apiusername,
        [parameter(Mandatory = $true)]
        [securestring]$apikey,
        [string]$url = 'https://api.craniumcafe.com'
    )

    Begin {
        $FormattedCurrentTime = Get-Date $CurrentTime -UFormat '%Y-%m-%d %X'
        $FormattedEarlierTime = Get-Date $CurrentTime.AddDays(-$days) -UFormat '%Y-%m-%d %X'

        $headers = @{
            'auth-key'     = $apiusername
            'auth-token'   = "$([Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($apikey)))"
            'Content-Type' = 'application/json'
        }

        $Results = @()
    }


    Process {
        while ($true) {

            $SearchParameters = @{
                start = $FormattedEarlierTime
                end   = $FormattedCurrentTime
                page  = $page
            }

            @($SearchParameters.keys) | ForEach-Object { if (-not $SearchParameters[$_]) { $SearchParameters.Remove($_) } }


            $uri = "$url/rest/v3/meetings"

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

            try {
                $QueryResponse = Invoke-RestMethod @queryArgs
            } catch {
                { break; }
            }

            #Validating that the array isn't adding the same users over and over.
            if ($null -ne $Results -and (@() + $Results.id).Contains($QueryResponse[0].id)) {
                break;
            }
            $Results += $QueryResponse
            $page++;

            #Breaking the loop when one of these three is true.
            if ($QueryResponse.lastPage -eq $true -or $null -eq $QueryResponse -or $QueryResponse.Length -eq 0) {
                break;
            }
        }
    }
    end {
        return $results
    }
}