@echo off
echo Cleaning Laravel Mix build artifacts...

REM Remove mix-manifest.json
if exist "public\mix-manifest.json" (
    del "public\mix-manifest.json"
    echo Removed public\mix-manifest.json
)

REM Remove Laravel Mix generated JS files (keeping core files that might be needed)
cd public\js
if exist "app.js" del "app.js"
if exist "manifest.js" del "manifest.js"
if exist "vendor.js" del "vendor.js"
if exist "vendor-vue.js" del "vendor-vue.js"
if exist "*.LICENSE.txt" del "*.LICENSE.txt"

REM Remove numbered chunk files (these are Laravel Mix specific)
for %%f in (*.js) do (
    echo %%f | findstr /r "^[0-9][0-9]*\.js$" >nul
    if not errorlevel 1 (
        del "%%f"
        echo Removed %%f
    )
)

cd ..\..\

REM Remove Laravel Mix generated CSS files
cd public\css
if exist "app.css" del "app.css"
if exist "store.css" del "store.css"
cd ..\..\

echo Laravel Mix cleanup completed!
echo Note: Run 'npm run build' to generate fresh Vite assets
