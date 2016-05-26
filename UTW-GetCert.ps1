# This script installs the public certificate from www.underthewire.com
# Created by Suckit Trebeck

$webRequest = [Net.WebRequest]::Create("https://century.underthewire.tech:5986/wsman") 
        try { $webRequest.GetResponse() } catch {} 
        $cert = $webRequest.ServicePoint.Certificate 
        $store = New-Object System.Security.Cryptography.X509Certificates.X509Store -ArgumentList "Root", "CurrentUser" 
        $store.Open('ReadWrite') 
        $store.Add($cert) 
        $store.Close() 
        Test-WSMan -ComputerName century.underthewire.tech -UseSSL