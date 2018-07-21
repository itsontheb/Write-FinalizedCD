function Get-FilePrompt
{
    <#.
        .SYNOPSIS
            Displays a Prompt to select either a single or multiple files
        .DESCRIPTION
            Function displays a OpenFileDialog utilizing Windows WinForms. There are
            options for setting the title, directory to start in, filter, and if
            multiple files can be selected or just a single file.
        .EXAMPLE
            $fileDiagSplat = @{
                Title   = 'Sample Title'
                InitialDirectory    = 'c:\windows'
                Filter  = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
                MultiSelect = $true
            }
            Get-FilePrompt @fileDiagSplat
        .NOTES
            Common Filters:
                Image Files(*.BMP;*.JPG;*.GIF)|*.BMP;*.JPG;*.GIF|All files (*.*)|*.*
                Text files (*.txt)|*.txt|All files (*.*)|*.*
    .#>

    [cmdletbinding()]
    param (
        [string]$title,
        [string]$InitialDirectory,
        [string]$Filter,
        [switch]$MutliSelect
        
    )
    
    Add-Type -AssemblyName System.Windows.Forms

    # Setup Filter if specified, otherise default to all
    if ( -not ($Filter))
    {
        $Filter = 'All files (*.*)|*.*'
    }


    $fileBrowser                  = New-Object System.Windows.Forms.OpenFileDialog
    $fileBrowser.Title            = $Title        
    $fileBrowser.CheckPathExists  = $true
    $fileBrowser.InitialDirectory = $InitialDirectory
    $fileBrowser.Multiselect      = $MutliSelect
    $fileBrowser.Filter           = $Filter
    #$fileBrowser.ShowHelp         = $true

    # Show Form
    [void]$fileBrowser.ShowDialog()

    # Output selected files
    Write-Output $fileBrowser.FileNames

} # END Function Get-FilePrompt