# Download Power BI Desktop
Invoke-WebRequest -Uri "https://www.microsoft.com/en-us/download/details.aspx?id=58494" -OutFile "C:\Temp\PowerBIDesktopSetup_x64.exe"

# Install Power BI Desktop silently
Start-Process -FilePath "C:\Temp\PowerBIDesktopSetup_x64.exe" -ArgumentList "/quiet" -Wait
