Function Eject-CDTray
{
    # Figure out the type needed for $tray to work with $trays
    # Go through comment to ensure instances for $tray type is added
    <#.
        .SYNOPSIS
            Opens the Local Machine's CD Tray.
        .DESCRIPTION
            This function ejects all CD Trays on the Local Machine. If the 
            $Tray parameter is utilized it will only eject that drive.
        .EXAMPLE
            PS> Eject-CDTray -Tray ''
        .Parameter Tray
            Name of the tray to eject. If not specified all trays are ejected.
            Required name of tray can be found from:

        .NOTES
            Minor Modifications from the below:
            https://www.adamtheautomator.com/use-powershell-to-automate-burning-cds/
    .#>
    [cmdletbinding()]
    param (
		[Parameter(Mandatory = $True,
					ValueFromPipeline = $True,
					ValueFromPipelineByPropertyName = $True,
					HelpMessage = 'What CD Tray would you like to eject')]
		[string]$Tray   
    )

    begin
    {
        Write-Verbose -Message 'Initialize Shell.Application'
        $action = New-Object -ComObject "Shell.Application"
    }

    process
    {
        Write-Verbose -Message 'Find CD Drives'
        $Trays = $action.Namespace(17).Items() | Where { $_.Type -eq 'CD Drive' }

        if ($Tray)
        {
            
        }
    }

    end
    {

    }


} # END Function Eject-CDTray