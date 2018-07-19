<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '500,210'
$Form.text                       = "Form"
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
$folderLbl.text                  = "Select folder to burn to media"
$folderLbl.AutoSize              = $true
$folderLbl.width                 = 25
$folderLbl.height                = 10
$folderLbl.location              = New-Object System.Drawing.Point(15,80)
$folderLbl.Font                  = 'Microsoft Sans Serif,10,style=Bold'

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 250
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(15,95)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$optGroup                        = New-Object system.Windows.Forms.Groupbox
$optGroup.height                 = 175
$optGroup.width                  = 200
$optGroup.text                   = "Options for burning media"
$optGroup.location               = New-Object System.Drawing.Point(285,20)

$folderBtn                       = New-Object system.Windows.Forms.Button
$folderBtn.text                  = "Browse"
$folderBtn.width                 = 60
$folderBtn.height                = 30
$folderBtn.location              = New-Object System.Drawing.Point(30,145)
$folderBtn.Font                  = 'Microsoft Sans Serif,10,style=Bold'

$startBtn                        = New-Object system.Windows.Forms.Button
$startBtn.text                   = "Burn Media"
$startBtn.width                  = 125
$startBtn.height                 = 50
$startBtn.location               = New-Object System.Drawing.Point(125,135)
$startBtn.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$Form.controls.AddRange(@($trayCBox,$trayLbl,$folderLbl,$TextBox1,$optGroup,$folderBtn,$startBtn))

#region gui events {
#endregion events }

#endregion GUI }


#Write your logic code here

[void]$Form.ShowDialog()