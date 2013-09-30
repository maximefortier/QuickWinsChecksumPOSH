###############################################################
#
#    Maxime Fortier QuickWins - A PowerShell Code Snippet
#    ChecksumPOSH.ps1
#    
#
#    By Maxime Fortier
#
#    I was tired of looking online for some free checksum
#    tools. To be truly honest, I do not trust any of them.
#    I thought it would be easier to build one. Performance 
#    is not too bad either. 
#
#    Simply run ChecksumPOSH.ps1
#
###############################################################



function Select-FileDialog
{
    # Select-FileDialog Function by Hugo Peeters http://www.peetersonline.nl #
	param([string]$Title,[string]$Directory,[string]$Filter="All Files (*.*)|*.*")
	[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
	$objForm = New-Object System.Windows.Forms.OpenFileDialog
	$objForm.InitialDirectory = $Directory
	$objForm.Filter = $Filter
	$objForm.Title = $Title
	$Show = $objForm.ShowDialog()
	If ($Show -eq "OK")
	{
		Return $objForm.FileName
	}
	Else
	{
		Write-Error "Operation cancelled by user."
	}
}
$file = Select-FileDialog -Title "Select a file" -Directory "C:\" -Filter "All Files (*.*)|*.*"
If ($file){    Write-Host "Selected file:"
    Write-Host $file
    $ExpectedHash = Read-Host "Copy here the expected MD5 Checksum"
    Write-Host "Calculated MD5 Checksum:"
    $md5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::Open("$file",[System.IO.Filemode]::Open, [System.IO.FileAccess]::Read)))
    $hash = $hash -replace '-',''
    Write-Host $hash
    If ($hash -eq $ExpectedHash)
    {
	    Write-Host "File is valid."
    }
    Else
    {
	    Write-Warning "File is not valid. Do not trust content."
    }}