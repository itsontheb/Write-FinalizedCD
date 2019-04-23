[cmdletbinding()]
param (

)

#region Functions
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

} # END Function Write-CD

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

Function Get-FolderPrompt
{
    [cmdletbinding()]
    param (
		[Parameter(Mandatory = $False,
					ValueFromPipeline = $True,
					ValueFromPipelineByPropertyName = $True,
					HelpMessage = 'Folder to start Dialog Prompt in')]
		[string]$Path,

		[Parameter(Mandatory = $False,
					ValueFromPipeline = $True,
					ValueFromPipelineByPropertyName = $True,
					HelpMessage = 'Description provided in Prompt')]
		[string]$Description
    )

    # Load Required Assembly
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    # Fill in some defaults if needed
    if ( -not ($Description))
    {
        $Description = 'Please select a folder.'

    }

    if ( -not ($Path))
    {
        $Path = 'MyComputer'
    }

    $FolderName = New-Object System.Windows.Forms.FolderBrowserDialog
    #$FolderName.RootFolder = 'MyComputer'
    #RootFolder can be any of the below:
    #[Enum]::GetNames([System.Environment+SpecialFolder])
    $FolderName.Description = $Description
    $FolderName.SelectedPath = $Path
    $FolderName.ShowNewFolderButton = $True

    if ($FolderName.ShowDialog() -eq 'OK')
    {
        $folder += $FolderName.SelectedPath
    }

    return $folder

} # END Function Get-FolderPrompt

Function Show-MessageBox
{
    <#.
        .SYNOPSIS
            Displays a MessageBox via the Windows WinForms
        .Description
            Function displays a customizable Message Box utilizing Windows WinForms. There are options to set
            the button combinations, icon, message and title. It will default to no icon and just 'OK' button.
            There is also an option to have the message box push itself to the front.
        .Example
            $msgBoxSplat = @{
                Message = 'Sample Message'
                Title   = 'Sample Title'
                Icon    = 'Informational'
                Button  = 'OkCancel'
                TopMost = $true
            }
            Show-MessageBox @msgBoxSplat
        .NOTES
            Get the button types:
                $t=[System.Windows.Forms.Messagebox]::Show("This is the Message text")
                [system.enum]::getValues($t.GetType())
            Get Icon Types:
                [system.enum]::getNames([System.Windows.Forms.MessageBoxIcon]) |
                    foreach{[console]::Writeline("{0,20} {1,-40:D}",$_,[System.Windows.Forms.MessageBoxIcon]::$_.value__)
    .#>
    [cmdletbinding()]
    param (
        [String]$Message,

        [String]$Title,

        [ValidateSet(
            'None',          # 0
            'Error',         # 16
            'Exclamation',   # 48
            'Informational', # 64
            'Question'       # 32
        )]
        $Icon,

        [ValidateSet(
            'Ok',
            'OkCancel',
            'AbortRetryIgnore',
            'YesNoCancel',
            'YesNo',
            'RetryCancel' 
        )]
        $Buttons,

        [switch]
        $TopMost
    )

    # Load the Assembly without any console output
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    If ($TopMost)
    {
        # Create Form to use as a parent
        $Frm = New-Object System.Windows.Forms.Form
        $Frm.TopMost = $true

        $Result = [System.Windows.Forms.MessageBox]::Show( $Frm, $Message, $Title, $Icon, $Buttons )

        # Cleanup
        $Frm.Close()
        $Frm.Dispose()
    }
    else
    {
        $Result = [System.Windows.Forms.MessageBox]::Show( $Message, $Title, $Icon, $Buttons )
    }

    # Return the button that was pressed
    Return $Result
} # END Function Show-MessageBox

#endregion Functions

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
$folderNameList = @()

#region begin GUI{ 

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '500,250'
$Form.text                       = "Powershell: Write-FinalizedCD on $env:COMPUTERNAME"
$Form.TopMost                    = $false

$trayCBox                        = New-Object system.Windows.Forms.ComboBox
$trayCBox.text                   = "$FILLER"
$trayCBox.width                  = 250
$trayCBox.height                 = 25
$trayCBox.location               = New-Object System.Drawing.Point(15,40)
$trayCBox.Font                   = 'Microsoft Sans Serif,10'

$trayLbl                         = New-Object system.Windows.Forms.Label
$trayLbl.text                    = "Utilize which CD-Tray to burn media?"
$trayLbl.AutoSize                = $true
$trayLbl.width                   = 25
$trayLbl.height                  = 10
$trayLbl.location                = New-Object System.Drawing.Point(15,20)
$trayLbl.Font                    = 'Microsoft Sans Serif,10,style=Bold'

$folderLbl                       = New-Object system.Windows.Forms.Label
$folderLbl.text                  = "Folders/Files to be burned"
$folderLbl.AutoSize              = $true
$folderLbl.width                 = 25
$folderLbl.height                = 10
$folderLbl.location              = New-Object System.Drawing.Point(15,65)
$folderLbl.Font                  = 'Microsoft Sans Serif,10,style=Bold'

$folderTxtBox                    = New-Object system.Windows.Forms.TextBox
$folderTxtBox.multiline          = $false
$folderTxtBox.width              = 250
$folderTxtBox.height             = 150
$folderTxtBox.location           = New-Object System.Drawing.Point(15,85)
$folderTxtBox.Font               = 'Microsoft Sans Serif,10'
$folderTxtBox.Text               = ''
$folderTxtBox.MultiLine          = $true
$folderTxtBox.ScrollBars         = 'Vertical'

$optGroup                        = New-Object system.Windows.Forms.Groupbox
$optGroup.height                 = 150
$optGroup.width                  = 200
$optGroup.text                   = "Options for burning media"
$optGroup.location               = New-Object System.Drawing.Point(285,20)

$folderBtn                       = New-Object system.Windows.Forms.Button
$folderBtn.text                  = "Browse"
$folderBtn.width                 = 60
$folderBtn.height                = 30
$folderBtn.location              = New-Object System.Drawing.Point(295,195)
$folderBtn.Font                  = 'Microsoft Sans Serif,10,style=Bold'

$FinalizeChBox                   = New-Object system.Windows.Forms.CheckBox
$FinalizeChBox.text              = "Finalize Media"
$FinalizeChBox.AutoSize          = $false
$FinalizeChBox.width             = 95
$FinalizeChBox.height            = 20
$FinalizeChBox.location          = New-Object System.Drawing.Point(30,20)
$FinalizeChBox.Font              = 'Microsoft Sans Serif,10'

$ejectChBox                      = New-Object system.Windows.Forms.CheckBox
$ejectChBox.text                 = "Eject Tray"
$ejectChBox.AutoSize             = $false
$ejectChBox.width                = 95
$ejectChBox.height               = 20
$ejectChBox.location             = New-Object System.Drawing.Point(30,45)
$ejectChBox.Font                 = 'Microsoft Sans Serif,10'

$notifyChBox                     = New-Object system.Windows.Forms.CheckBox
$notifyChBox.text                = "Completion Notification"
$notifyChBox.AutoSize            = $false
$notifyChBox.width               = 95
$notifyChBox.height              = 20
$notifyChBox.location            = New-Object System.Drawing.Point(30,70)
$notifyChBox.Font                = 'Microsoft Sans Serif,10'

$cTrayChBox                      = New-Object system.Windows.Forms.CheckBox
$cTrayChBox.text                 = "Close Tray After: "
$cTrayChBox.AutoSize             = $false
$cTrayChBox.width                = 95
$cTrayChBox.height               = 20
$cTrayChBox.location             = New-Object System.Drawing.Point(30,95)
$cTrayChBox.Font                 = 'Microsoft Sans Serif,10'

$startBtn                        = New-Object system.Windows.Forms.Button
$startBtn.text                   = "&Burn Media"
$startBtn.width                  = 125
$startBtn.height                 = 50
$startBtn.location               = New-Object System.Drawing.Point(365,185)
$startBtn.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$Form.controls.AddRange(@($trayCBox,$trayLbl,$folderLbl,$folderTxtBox,$optGroup,$folderBtn,$startBtn))
$optGroup.controls.AddRange(@($FinalizeChBox,$ejectChBox,$notifyChBox,$cTrayChBox))

#region gui events {
$folderBtn.Add_Click({
    $burnFolder = "$(Get-FolderPrompt)`r`n"
    $folderTxtBox.Text += $burnFolder
    
})

$startBtn.Add_Click({ 

    
    # Get Folder size from $folderTxtBox.Text
    Write-Host "$($folderTxtBox.Text)"

    $folderList = @()

    Foreach ($folder in $($folderTxtBox.Text))
    {
        $folderList += Get-ChildItem -Path $folder -Recurse
    }

    Write-Host "$folderList"

    # Get Size of files/folders
        $totalSize = @()
        Foreach ($folder in $burnfolderList)
        {
            $foldersize = (Get-ChildItem -Path  $($folder) -Recurse | Measure-Object -Property Length -Sum).Sum
            $totalSize += $totalSize + $foldersize
            $message = '( ' + $foldersize + " ) $folder"
            Write-Host $message
        }
    # Get size of CD

    # Compare

    # Notify too much

    # else write cd
    if ($placeholder)
    {
        #Write-CD -Path -DiskDrive -CDTitle -Finalize
    }
    else
    {
        # too much
    }

    if ($ejectChBox.Checked)
    {
        Eject-CDTray -Tray $($trayCBox.SelectedItem)
    }

    if ($notifyChBox.Checked)
    {
        
    }

    if ($cTrayChBox.Checked)
    {
        Close-CDTray -Tray $($trayCBox.SelectedItem)
    }
})

#endregion events }

#endregion GUI }


[void]$Form.ShowDialog()