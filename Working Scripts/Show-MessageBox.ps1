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