$ErrorActionPreference = "Continue"

$cyan  = "$([char]27)[96m"
$green = "$([char]27)[92m"
$red   = "$([char]27)[91m"
$reset = "$([char]27)[0m"

# ─── i18n ──────────────────────────────────────────────
Write-Host "${cyan}=== Generating i18n ===${reset}"
dart run slang

# ─── Clean ─────────────────────────────────────────────
Write-Host "${cyan}=== Cleaning build cache ===${reset}"
flutter clean

# ─── Build ─────────────────────────────────────────────
Write-Host "${cyan}=== Building Flutter Web ===${reset}"
flutter build web --release --no-wasm-dry-run --base-href /harvest/

if ($LASTEXITCODE -ne 0) {
    Write-Host "${red}Build failed! Aborting.${reset}"
    exit 1
}

# ─── Deploy ────────────────────────────────────────────
Write-Host "${cyan}=== Deploying to GitHub Pages ===${reset}"
Push-Location "build\web"

git init -b gh-pages 2>$null
git add . 2>$null
git commit -m "deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 2>$null
git remote remove origin 2>$null
git remote add origin https://github.com/guilhermeeng99/harvest.git
git push -f origin gh-pages

if ($LASTEXITCODE -ne 0) {
    Write-Host "${red}Push failed!${reset}"
    Pop-Location
    exit 1
}

Pop-Location
Write-Host "${green}=== Deploy complete! ===${reset}"
Write-Host "${green}Site: https://guilhermeeng99.github.io/harvest/${reset}"
