# -------------------------------------------------------------------------------------------------
#
# Name                  : CleanUp_Variables.ps1
# Description           : Establish what variables are currently present. This is to be used with
#                         CleanUp-Variables, which eradicates the variable delta between the baseline
#                         below and the current 'Get-Variable' call at the time of running
#                         CleanUp-Variables.
# Last Modified         : 03-05-2015
# Available Functions   : Establish-VariableBaseline
#                         CleanUp-Variables
#
# -------------------------------------------------------------------------------------------------





# -------------------------------------
# determine current session variables
# -------------------------------------

function Establish-VariableBaseline {    
  
  $VariableBaseline = @()
  New-Variable -Name "VariableBaseline" -Scope Global -Value (Get-Variable | % { $_.Name }) -Force

  }





# -------------------------------------
# remove current variables not contained
# in baseline array from above function
# -------------------------------------

function CleanUp-Variables {
  
  [cmdletbinding()]
  Param (
    [parameter(mandatory=$false)]
    [array]$VariableExceptions
    )
  
  if($VariableExceptions) { $VariableExceptions | % { $Global:VariableBaseline += $_ } }
  
  (Get-Variable).Name | ? { $VariableBaseline -notcontains $_ } |
                        % { Remove-Variable -Name $_ -Force -Scope Global -ErrorAction SilentlyContinue
                            if ((Get-Variable).Name -notcontains $_) { Write-Host "Removed: `$$_" -ForegroundColor DarkYellow }
                          }
  
  }





# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------