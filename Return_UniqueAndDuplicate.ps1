# -------------------------------------------------------------------------------------------------
#
# Name                  : Return_UniqueAndDuplicate.ps1
# Description           : Function returns unique and/or duplicate entries from a provided array.
# Last Modified         : 03-06-2015
# Available Functions   : Return-UniqueArrayElements
#
# -------------------------------------------------------------------------------------------------





function Return-UniqueAndDuplicate {
  
  [cmdletbinding()]
  Param (
    [parameter(mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [array]$InputArray,
    
    [parameter(mandatory=$false)]
    [switch]$Duplicates,
    
    [parameter(mandatory=$false)]
    [switch]$Uniques
    )
  

  $UniqueElements = @()
  $DuplicateElements = @()
  $ReturnArray = @{}
  
  # determine unique/duplicates
  foreach ($item in $InputArray) {      
    if ($UniqueElements -notcontains $item) { $UniqueElements += $item }
      else { $DuplicateElements += $item }             
    }
  
  # build hashtable
  $ReturnArray += @{"Uniques"=$UniqueElements;"Duplicates"=$DuplicateElements}

  if ($Duplicates) { return $ReturnArray.Duplicates }
    elseif ($Uniques) { return $ReturnArray.Uniques }
      else { return $ReturnArray }
  
  }





# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------