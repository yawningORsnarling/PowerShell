﻿# -------------------------------------------------------------------------------------------------
#
# Name                  : Get_WindowFocus.ps1
# Description           : Function accepts a Windows process, process ID, or the window title which
#                         is used to bring its corresponding window into the foreground.
# Last Modified         : 03-01-2015
# Available Functions   : Get-WindowFocus
#
# -------------------------------------------------------------------------------------------------





function Get-WindowFocus {
  
  [cmdletbinding()]
  Param (
    [parameter(mandatory=$false)]
    [string]$ProcessName,
    
    [parameter(mandatory=$false)]
    [string]$ProcessID,
    
    [parameter(mandatory=$false)]
    [string]$WindowTitle
    )
  
  Add-Type -Assembly "Microsoft.VisualBasic"
  [void] [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")

  if ($ProcessName) { $Handle = (Get-Process -Name $ProcessName -ErrorAction SilentlyContinue).Id }
    elseif ($ProcessID) { [int]$Handle = $ProcessID }
      elseif ($WindowTitle) { $Handle = $WindowTitle }
  
  [Microsoft.VisualBasic.Interaction]::AppActivate($Handle)  
  
  }





# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------