Function Eject-CDTray
{
    # Figure out the type needed for $tray to work with $trays
    <#.
        .SYNOPSIS
            Burns the contents of a folder to a CD
        .DESCRIPTION
            This function retrieves the contents of a specified folder path and burns
            a CD with the specified title. There is the option to select the CD/DVD-ROM
            Drive to utilize for the burn by providing the DeviceID. There is also a
            switch to finalize the media so it cannot be written to again.
        .EXAMPLE
            PS> Write-CD -Path 'C:\Folder' -CDTitle 'SAMPLE TITLE' -Finalize
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