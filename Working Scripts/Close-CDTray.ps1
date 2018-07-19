Function Close-CDTray
{
    # Figure out the type needed for $tray to work with $trays
    # Go through comment to ensure instances for $tray type is added
    <#.
        .SYNOPSIS
            Closes open CD Trays.
        .DESCRIPTION
            This function closes all CD Trays on the Local Machine. If the 
            $Tray parameter is utilized it will only close that drive.
        .EXAMPLE
            PS> Close-CDTray -Tray ''
        .Parameter Tray
            Name of the tray to close. If not specified all trays are closed.
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
        $DiskMaster = New-Object -ComObject IMAPI2.MsftDiscMaster2
        $DiscRecorder = New-Object -ComObject IMAPI2.MsftDiscRecorder2
        
        if ($Tray)
        {
            # Missing Action
        }
        if ( -not ( $id))
        {
            $id = $DiskMaster.Item(0)
        }
    }

    process
    {
        $DiscRecorder.InitializeDiscRecorder($id)
        $DiscRecorder.CloseTray()
    }

    end
    {

    }

} # END Function Close CDTray