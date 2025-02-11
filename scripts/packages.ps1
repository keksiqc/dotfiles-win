# Ensure scoop is installed
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

# Ensure scoop is in the PATH
if (-not ($env:PATH -split ';' | Where-Object { $_ -eq "$env:SCOOP\shims" })) {
    $env:PATH += ";$env:SCOOP\shims"
}

# Ensure scoop is up-to-date
scoop update

# Install git
scoop install main/git

# Add buckets
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add versions
scoop bucket add nonportable
scoop bucket add dorado https://github.com/chawyehsu/dorado

# Define scoop packages by bucket
$packages = @{
    "dorado"     = @("chatwise", "hok", "trash")
    "extras"     = @("brave", "bulk-crap-uninstaller", "filezilla", "micaforeveryone", "spotify", "termius", "vesktop", "vlc", "vscode")
    "main"       = @("1password-cli", "adb", "eza", "fastfetch", "ffmpeg", "fzf", "gh", "gow", "nodejs", "powertoys", "scoop-search", "starship", "sudo", "zoxide")
    "nerd-fonts" = @("0xProto-NF", "CascadiaCode-NF", "CommitMono-NF", "FiraCode-NF", "GeistMono-NF", "Hack-NF", "Hasklig-NF", "IBMPlexMono-NF", "Iosevka-NF", "IosevkaTerm-NF", "JetBrainsMono-NF", "JetBrainsMono-NF-Mono", "Lilex-NF", "ZedMono-NF")
    "nonportable"= @("notepads-np")
    "versions"   = @("vscode-insiders", "zed-nightly")
}

# Install scoop packages grouped by bucket
foreach ($bucket in $packages.Keys) {
    foreach ($pkg in $packages[$bucket] | Sort-Object) {
        scoop install "$bucket/$pkg"
    }
}

# Winget installations
$wingetApps = @(
    "Microsoft.WindowsTerminal",
    "Microsoft.PowerShell",
    "AgileBits.1Password",
    "Cryptomator.Cryptomator",
    "Notion.Notion",
    "Notion.NotionCalendar",
    "Zen-Team.Zen-Browser"
) | Sort-Object

foreach ($app in $wingetApps) {
    winget install -e --id $app
}
