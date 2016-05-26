param(
[string]$EpochDate
)

#First possible Function. Potential for one command line.
Function Get-DateFromEpoch ($EpochDate) {
return [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($EpochDate))
}

#Second possible Function.
Function FromUtcEpocTime ($EpochDate) {
    $epoch = New-Object System.DateTime (1970, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc)
    $PSDate = $epoch.AddSeconds($EpochDate)
    return $PSDate.ToLocalTime()
}

Get-DateFromEpoch ($EpochDate)
FromUtcEpocTime ($EpochDate)