# Download Power BI Desktop
Invoke-WebRequest -Uri "https://download.microsoft.com/download/0/1/2/01234567-89AB-CDEF-0123-456789ABCDEF/PowerBIDesktopSetup_x64.exe" -OutFile "C:\Temp\PowerBIDesktopSetup_x64.exe"

# Install Power BI Desktop silently
Start-Process -FilePath "C:\Temp\PowerBIDesktopSetup_x64.exe" -ArgumentList "/quiet" -Wait