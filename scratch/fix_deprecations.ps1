
$files = Get-ChildItem -Path lib -Filter *.dart -Recurse

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $changed = $false

    # Replace surfaceVariant with surfaceContainerHighest
    if ($content -match 'surfaceVariant') {
        $content = $content -replace 'surfaceVariant', 'surfaceContainerHighest'
        $changed = $true
    }

    # Replace withOpacity with withValues(alpha: ...)
    if ($content -match '\.withOpacity\(') {
        $content = $content -replace '\.withOpacity\((.*?)\)', '.withValues(alpha: $1)'
        $changed = $true
    }

    # Replace background: in ColorScheme with surface:
    # This is a bit risky but let's try a regex for ColorScheme.dark/light or just background: inside BoxDecoration/Theme
    # Actually, the analysis specifically mentions background in ColorScheme.
    # Let's target ColorScheme specifically if possible, or just background: theme.colorScheme.background
    
    if ($content -match 'background: theme\.colorScheme\.background') {
        $content = $content -replace 'background: theme\.colorScheme\.background', 'surface: theme\.colorScheme\.surface'
        $changed = $true
    }

    if ($content -match 'onBackground: theme\.colorScheme\.onBackground') {
        $content = $content -replace 'onBackground: theme\.colorScheme\.onBackground', 'onSurface: theme\.colorScheme\.onSurface'
        $changed = $true
    }

    if ($changed) {
        Set-Content $file.FullName $content -NoNewline
        Write-Host "Updated $($file.FullName)"
    }
}
