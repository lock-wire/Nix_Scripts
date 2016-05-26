param(
[Datetime]$PSdate
)

Function Convert-ToUnixDate ($PSdate) {
   #$epoch = [timezone]::CurrentTimeZone.ToUniversalTime([datetime]'1/1/1970 00:00:00')
   $epoch = New-Object System.DateTime (1970, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc)
   $date = $PSdate.ToUniversalTime()
   return (New-TimeSpan -Start $epoch -End $date).TotalSeconds
}

Convert-ToUnixDate $PSdate