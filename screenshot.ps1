# Take a screenshot
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$screenshot = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height

$graphics = [System.Drawing.Graphics]::FromImage($screenshot)
$graphics.CopyFromScreen($screen.X, $screen.Y, 0, 0, $screen.Size)

# Save the screenshot to the specified location
$saveLocation = "<PATH-TO>\<FILE-NAME>.png"
$screenshot.Save($saveLocation, [System.Drawing.Imaging.ImageFormat]::Png)

$graphics.Dispose()
$screenshot.Dispose()