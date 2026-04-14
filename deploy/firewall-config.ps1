# firewall-config.ps1 — Opens required firewall ports for portainer.
# Run as Administrator.

param(
    [switch]$Remove   # Pass -Remove to delete the rules instead of adding them
)

$rules = @(
    @{ Name = "Portainer - UI"; Port = 9000 }
)

if ($Remove) {
    Write-Host "`n[*] Removing firewall rules..." -ForegroundColor Cyan
    foreach ($rule in $rules) {
        Remove-NetFirewallRule -DisplayName $rule.Name -ErrorAction SilentlyContinue
        Write-Host "  [removed] $($rule.Name) (port $($rule.Port))"
    }
    Write-Host "`n[ok] All firewall rules removed.`n" -ForegroundColor Green
} else {
    Write-Host "`n[*] Adding firewall rules..." -ForegroundColor Cyan
    foreach ($rule in $rules) {
        Remove-NetFirewallRule -DisplayName $rule.Name -ErrorAction SilentlyContinue
        New-NetFirewallRule `
            -DisplayName $rule.Name `
            -Direction   Inbound `
            -Action      Allow `
            -Protocol    TCP `
            -LocalPort   $rule.Port | Out-Null
        Write-Host "  [added] $($rule.Name) (port $($rule.Port))"
    }
    Write-Host "`n[ok] All firewall rules added.`n" -ForegroundColor Green

    Write-Host "Current rules:" -ForegroundColor Cyan
    Get-NetFirewallRule -DisplayName "Portainer*" |
        Select-Object DisplayName, Enabled, Action |
        Format-Table -AutoSize
}
