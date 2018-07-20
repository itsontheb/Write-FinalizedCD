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