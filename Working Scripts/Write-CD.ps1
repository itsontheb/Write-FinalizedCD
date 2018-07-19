Function Write-CD
{
    # ADD POWERSHELL ONELINER
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
        .Parameter Path
            The folder path containing the files you'd like to burn to the CD.
            Required Parameter.
        .Parameter DiskDrive
            The DeviceID of the the drive to burn with. This can be found in
            Device Manager or a powershell one-liner. (TO BE ADDED)
        .Parameter CDTitle
            The title of the CD that you'd like to show up in Windows Explorer.
        .Parameter Finalize
            If specified the CD will finalized and cannot be written to in any other sessions.
        .NOTES
            Minor Modifications from the below:
            https://www.adamtheautomator.com/use-powershell-to-automate-burning-cds/
    .#>

    [CmdletBinding()]
    Param (
		[Parameter(Mandatory = $True,
					ValueFromPipeline = $True,
					ValueFromPipelineByPropertyName = $True,
					HelpMessage = 'What is the folder path you would like to burn?')]
		[string]$Path,

 		[Parameter(Mandatory = $False,
					ValueFromPipeline = $True,
					ValueFromPipelineByPropertyName = $True,
					HelpMessage = 'Which Disk Drive to you want to burn with? (Default is 0)')]
		[string]$DiskDrive,
			
		[Parameter(Mandatory = $False,
					ValueFromPipeline = $False,
					ValueFromPipelineByPropertyName = $True,
					HelpMessage = 'What is the name of the CD?')]
		[string]$CDTitle,

		[Parameter(Mandatory = $False,
					ValueFromPipeline = $False,
					ValueFromPipelineByPropertyName = $True,
					HelpMessage = 'Do you want the CD to be finalized?')]
		[string]$Finalize    
    )

    begin
    {
        try
        {
            Write-Verbose -Message 'Creating COM Objects'

            $DiskMaster = New-Object -ComObject IMAPI2.MsftDiscMaster2
            $DiscRecorder = New-Object -ComObject IMAPI2.MsftDiscRecorder2
            $FileSystemImage = New-Object -ComObject IMAPI2.MsftFileSystemImage
            $DiscFormatData = New-Object -ComObject IMAPI2.MsftDiscFormatData
        }
        Catch
        {
            Write-Verbose -Message 'Caught an Error'

            $caughtError = $Error[0]
            Write-Error $caughtError
            return
        }
    }

    process
    {
        Write-Verbose -Message 'Initializing Disc Recorder'
        if ($DiskDrive)
        {
            $burnDrive = $DiskMaster -match $DiskDrive
        }
        
        if ( -not ($burnDrive))
        {
            $burnDrive = $DiskMaster.Item(0)
        }
        $DiscRecorder.InitializeDiscRecorder($burnDrive)

        Write-Verbose -Message 'Assigning recorder.'
		$dir = $FileSystemImage.Root
		$DiscFormatData.Recorder = $DiscRecorder
		$DiscFormatData.ClientName = 'PowerShell Burner'
        if ($Finalize)
        {
            $DiscFormatData.ForceMediaToBeClosed = $True
        }

        Write-Verbose -Message 'MultiSession?'
        if ( -not ($DiscFormatData.MediaHeuristicallyBlank))
        {
            try
            {
                $FileSystemImage.MultiSessionInterfaces = $DiscFormatData.MultiSessionInterfaces
                
                Write-Verbose -Message 'Importing existing session.'
                $FileSystemImage.ImportFileSystem() | Out-Null
            }
            catch
            {
                Write-Verbose -Message 'Caught an Error'

                $caughtError = $Error[0]
                Write-Error $caughtError
                return
            }
        }
        else
        {
            Write-Verbose -Message 'Empty Medium.'
            $FileSystemImage.ChooseImageDefaults($DiscRecorder)
            $FileSystemImage.VolumeName = $CdTitle
        }

        Write-Verbose -Message "Adding directory tree ($Path)."
        $dir.AddTree($Path, $False)

        Write-Verbose -Message 'Creating image.'
		$result = $FileSystemImage.CreateResultImage()
		$stream = $result.ImageStream

        Write-Verbose -Message 'Burning.'
        $DiscFormatData.Write($stream)

        Write-Verbose 'Done.'
    }

    end
    {

    }

}