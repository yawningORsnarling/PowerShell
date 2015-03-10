# -------------------------------------------------------------------------------------------------
#
# Name                  : Determine_FileSystemChanges.ps1
# Description           : Function accepts two sets of filesystem data (Get-ChildItem), one set a
#                         previous version of itself. The function returns whether the file/directory
#                         has been added, removed, or modified.
# Last Modified         : 03-07-2015
# Available Functions   : Determine-FileSystemChanges
#
# -------------------------------------------------------------------------------------------------





function Determine-FileSystemChanges {
  
  [cmdletbinding()]
  Param (
    [parameter(mandatory=$true)]
    [array]$ReferenceData,
    
    [parameter(mandatory=$true)]
    [array]$DifferenceData,
    
    [parameter(mandatory=$false)]
    [string]$Key
    )
  
  # -----------------------------------
  # ensure the provided key is valid
  # -----------------------------------
  
  $Results = @()
  #$PropertyExceptions = @("LastWriteTime")
  $PropertyNames = $ReferenceData[0].PSObject.Properties.Name | ? { $PropertyExceptions -notcontains $_ }
  $PropertyCount = $PropertyNames.Count

  if (!$Key) { $Key = "FullName"; Write-Host "`nNOTICE: unique identifier defaulting to 'FullName'" -ForegroundColor Yellow }
  if ($PropertyNames -notcontains $Key) { Write-Host "`nERROR: $Key is not a valid property" -ForegroundColor Red; break }


  # -----------------------------------
  # determine NEW and MODIFIED elements
  # -----------------------------------

  foreach ($object in $DifferenceData) {
    
    $Changes = @()
    $KeyFound = $false
    $ObjectIdentifier = $object.$Key
    $NewObject = New-Object PSObject

    foreach ($prop in (Get-Member -InputObject $object -MemberType NoteProperty)) {
      if ($PropertyExceptions -notcontains $prop.Name) {
        $NewObject | Add-Member -Type NoteProperty -Name $prop.Name -Value $object.$($prop.Name)
        }
      }

    if ($ReferenceData.$Key -notcontains $ObjectIdentifier) { $Changes = "NEW" }
      else {
        for ($x=0; $x -lt $ReferenceData.Count -and !$KeyFound; $x++) {
          if ($ObjectIdentifier -eq $ReferenceData[$x].$Key) {
            
            $KeyFound = $true

            for ($p=0; $p -lt $PropertyCount; $p++) {
              $CurrentProperty = $PropertyNames[$p]
              if ($object.$CurrentProperty -ne $ReferenceData[$x].$CurrentProperty) { [array]$Changes += $CurrentProperty }
              }

            } # end if

          } # end for
       
       } # end else
    
    if (!$Changes) { $Changes = "NONE" }
                                                
    $NewObject | Add-Member -Type NoteProperty -Name Changes -Value $($Changes -join ',')

    [array]$Results += $NewObject
    
    } # end foreach


  # -----------------------------------
  # determine REMOVED elements
  # -----------------------------------

  foreach ($object in $ReferenceData) {
    
    $KeyFound = $false
    $ObjectIdentifier = $object.$Key
    $NewObject = New-Object PSObject

    foreach ($prop in (Get-Member -InputObject $object -MemberType NoteProperty)) {
      if ($PropertyExceptions -notcontains $prop.Name) {
        $NewObject | Add-Member -Type NoteProperty -Name $prop.Name -Value $object.$($prop.Name)
        }
      }

    if ($DifferenceData.$Key -notcontains $ObjectIdentifier) {
      $Changes = "REMOVED"
      $NewObject | Add-Member -Type NoteProperty -Name Changes -Value $($Changes)
      [array]$Results += $NewObject
      }

    } # end foreach

  [array]$Results = $Results | Sort-Object -Property Name

  return $Results
  }


     


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------