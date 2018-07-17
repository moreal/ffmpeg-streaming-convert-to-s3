# Set-ExecutionPolicy Bypass -Scope Process -Force; ./install.ps1

function Command-Exists($cmd) 
{
    try 
    {
        iex $cmd
        return $true;
    } 
    catch [System.Management.Automation.CommandNotFoundException] 
    {
        return $false;
    }
}

if (Command-Exists aws) 
{
    Write-Host "[!] AWS CLI is already installed"
}
else 
{
    if (Command-Exists choco)
    {
        Write-Host "[!] choco is already installed"
    }
    else 
    {
        Write-Host "[+] Installing choco is started"
        Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Write-Host "[+] Complete installing choco"
    }

    Write-Host "[+] Installing AWS CLI is started"
    choco install awscli -y
    Write-Host "[+] Complete installing AWS CLI"

    Write-Host "[+] Configuring AWS CLI"
    aws configure
    Write-Host "[+] Complete configuring AWS CLI"
}

if ($env:Path.Split(';').Contains('C:\Users\dsm2017\Desktop\vr-player'))
{
    Write-Host "[!] PATH Setting is already installed"
}
else
{
    Write-Host "[+] Setting PATH is started"
    $Current = (Get-Location).Path
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$Current;", [System.EnvironmentVariableTarget]::Machine )
    Write-Host "[+] PATH Setting has completed"
}