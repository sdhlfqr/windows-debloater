# Schedule .NET Framework tasks.
Get-ScheduledTask -TaskPath "\Microsoft\Windows\.NET Framework\" | Start-ScheduledTask

# Set PATH to .NET runtime directory to access ngen tool.
$env:PATH = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()

# Precompile .NET assemblies.
# Credits: https://stackoverflow.com/questions/59341482/powershell-steps-to-fix-slow-startup/59343705#59343705
[AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
    $path = $_.Location

    if ($path) {
        $name = Split-Path $path -Leaf
        Write-Host -ForegroundColor Yellow "`r`nRunning ngen on '$name'"
        ngen.exe install $path /nologo
    }
}
