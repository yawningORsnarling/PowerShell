﻿# -------------------------------------------------------------------------------------------------
#
# Name           : Get-WindowFocus
# Description    : Function accepts a Windows process which is use to bring its corresponding
#                  window into the foreground.
# Last Modified  : 03-01-2015
# Comments       : 
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

  if ($ProcessName) { $Handle = (Get-Process $ProcessName -ErrorAction SilentlyContinue).Id }
    elseif ($WindowTitle) { $Handle = $WindowTitle }

  [Microsoft.VisualBasic.Interaction]::AppActivate($Handle)  
  
  }