Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '500,250'
$Form.text                       = "Powershell: Write-FinalizedCD"
$Form.TopMost                    = $false

$trayCBox                        = New-Object system.Windows.Forms.ComboBox
$trayCBox.text                   = "$FILLER"
$trayCBox.width                  = 250
$trayCBox.height                 = 25
$trayCBox.location               = New-Object System.Drawing.Point(15,85)
$trayCBox.Font                   = 'Microsoft Sans Serif,10'

$trayLbl                         = New-Object system.Windows.Forms.Label
$trayLbl.text                    = "Utilize which CD-Tray to burn media?"
$trayLbl.AutoSize                = $true
$trayLbl.width                   = 25
$trayLbl.height                  = 10
$trayLbl.location                = New-Object System.Drawing.Point(15,65)
$trayLbl.Font                    = 'Microsoft Sans Serif,10,style=Bold'

$folderLbl                       = New-Object system.Windows.Forms.Label
$folderLbl.text                  = "Select folder to burn to media"
$folderLbl.AutoSize              = $true
$folderLbl.width                 = 25
$folderLbl.height                = 10
$folderLbl.location              = New-Object System.Drawing.Point(14,130)
$folderLbl.Font                  = 'Microsoft Sans Serif,10,style=Bold'

$folderTxtBox                    = New-Object system.Windows.Forms.TextBox
$folderTxtBox.multiline          = $false
$folderTxtBox.width              = 250
$folderTxtBox.height             = 20
$folderTxtBox.location           = New-Object System.Drawing.Point(14,150)
$folderTxtBox.Font               = 'Microsoft Sans Serif,10'

$optGroup                        = New-Object system.Windows.Forms.Groupbox
$optGroup.height                 = 220
$optGroup.width                  = 200
$optGroup.text                   = "Options for burning media"
$optGroup.location               = New-Object System.Drawing.Point(285,20)

$folderBtn                       = New-Object system.Windows.Forms.Button
$folderBtn.text                  = "Browse"
$folderBtn.width                 = 60
$folderBtn.height                = 30
$folderBtn.location              = New-Object System.Drawing.Point(31,195)
$folderBtn.Font                  = 'Microsoft Sans Serif,10,style=Bold'

$startBtn                        = New-Object system.Windows.Forms.Button
$startBtn.text                   = "Burn Media"
$startBtn.width                  = 125
$startBtn.height                 = 50
$startBtn.location               = New-Object System.Drawing.Point(125,185)
$startBtn.Font                   = 'Microsoft Sans Serif,10,style=Bold'

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

$Form.controls.AddRange(@($trayCBox,$trayLbl,$folderLbl,$folderTxtBox,$optGroup,$folderBtn,$startBtn))
$optGroup.controls.AddRange(@($FinalizeChBox,$ejectChBox,$notifyChBox))

#region gui events {
#endregion events }

#endregion GUI }


#Write your logic code here

[void]$Form.ShowDialog()