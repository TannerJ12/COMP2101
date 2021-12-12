Get-CimInstance win32_computersystem |
    foreach {
        New-Object -TypeName psobject -Property @{
            "System Hardware Description" = $_.Description
        } 
        } |
        Format-List "System Hardware Description"

Get-CimInstance win32_operatingsystem | 
    foreach { 
        New-Object -TypeName psobject -Property @{
            "System Name" = $_.Name
            "Version Number" = $_.Version
        }
        }|
        Format-List "System Name" ,
                    "Version Number"

Get-CimInstance win32_processor |
    foreach { 
        New-Object -TypeName psobject -Property @{
            "Speed" = $_.MaxClockSpeed
            "Number Of Cores" = $_.NumberOfCores
            "Size of L1" = $_.L1Cachesize
            "Size of L2" = $_.L2CacheSize
            "Size of L3" = $_.L3CacheSize
            }
            }|
            Format-List "Speed" , 
                        "Number of Cores" ,
                        "Size of L1" ,
                        "Size of L2" ,
                        "Size of L3"

Get-CimInstance win32_physicalmemory |
    foreach {
        New-Object -TypeName psobject -Property @{
            "Vendor" = $_.SerialNumber
            "Description" = $_.Description
            "Size" = $_.Capacity
            "Bank Slot" = $_.BankLabel
            "Capacity" = $_.Capacity
        }
        }|
        Format-List "Vendor" ,
                    "Description" ,
                    "Size" ,
                    "Bank Slot" ,
                    "Capacity"

 $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }

  Get-CimInstance -class win32_networkadapterconfiguration | where-object ipenabled |
    foreach {
        New-Object -TypeName psobject -Property @{
            "Description" = $_.description
            "Index" = $_.index
            "IP Address" = $_.ipaddress
            "Subnet" = $_.ipsubnet
            "DNS Domain" = $_.dnsdomain
            "DNS Server" = $_.dnsserversearchorder
            }
            }|
            Format-List "Description" ,
                        "Index" ,
                        "IP Address" ,
                        "Subnet" ,
                        "DNS Domain" ,
                        "DNS Server"

Get-CimInstance win32_videocontroller |
    foreach {
        New-Object -TypeName psobject -Property @{
            Description = $_.Description
            "Vendor" = $_.DeviceID
            "Horizontal Resolution" = $_.CurrentHorizontalResolution
            "Vertical Resolution" = $_.CurrentVerticalResolution
        }
        $HoriReso = $_.CurrentHorizontalResolution
        $VertiReso = $_.CurrentVerticalResolution
        }|
        Format-List Description ,
                    "Vendor" ,
                    "Horizontal Resolution" ,
                    "Vertical Resolution"

"Current Resolution is $HoriReso x $VertiReso "