# ===== Console Setup =====
# Configure UTF-8 encoding for input/output
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# ===== Module Loading =====
# Async module imports for faster startup
$moduleLoading = @(
    @{ Name = 'Terminal-Icons' }
) | ForEach-Object {
    Start-Job -ScriptBlock { Import-Module $using:_.Name }
}

# ===== Shell Prompt =====
# Starship prompt configuration
# scoop install main/starship
function Invoke-Starship-TransientFunction {
    &starship module character
}
$ENV:STARSHIP_SHELL = "pwsh"
Invoke-Expression (&starship init powershell)

# Directory navigation with zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# ===== PSReadLine Setup =====
# Shell behavior and prediction settings
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History

# Navigation key bindings
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# ===== Custom Functions =====
# Modern ls replacements using eza
# scoop install main/eza
function ll { eza --long --header --icons --git $args }
function la { eza --long --header --icons --git --all $args }

# Directory navigation shortcuts
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function home { Set-Location ~ }

# ===== Aliases =====
# Navigation and common tools
# scoop install main/git
# scoop install main/zoxide
# scoop install main/bat
# scoop install main/neovim
$aliases = @{
    'cd'      = 'z'
    'pn'      = 'pnpm'
    'vim'     = 'nvim'
    'g'       = 'git'
    'cat'     = 'bat'
    'cc'      = 'cookiecutter'
    'grep'    = 'findstr'
    'py'      = 'python'
    'pip'     = 'pip3'
}

# Bulk alias creation
$aliases.GetEnumerator() | ForEach-Object {
    Set-Alias -Name $_.Key -Value $_.Value -Option AllScope
}

# ===== Environment & Tools =====
# Optional SSH configuration
# $ENV:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Complete async module loading
$moduleLoading | Wait-Job | Receive-Job

# Configure fuzzy finder
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Clean up conflicting aliases
Remove-Item Alias:ni -Force -ErrorAction Ignore

# Enable transient prompt (must be at the end)
# Enable-TransientPrompt
