# Pwnagotchi Connection Script

This is a script to share your internet connection with your Pwnagotchi in Linux

## Original Script
The original version of this script can be found at [Linux Pwnagotchi Connection Share](https://sourceforge.net/projects/linux-pwnagotchi-conn-share/) on SourceForge. All credit for the original creation goes to [@xNigredo](https://sourceforge.net/u/xnigredo/profile/).

## Enhancements
The script has been modified to:
1. Prompt for the username for SSH connection.
2. Allow the user to choose a DNS IP address, suggesting popular choices.
3. Automatically scan for USB Ethernet Gadget interfaces and provide a selection for the user.
4. Scan for and allow the user to choose non-Ethernet gadget interfaces for the upstream connection.

Hopefully this makes it easier for people.

## Usage
To use this script:
1. Download the script to your local machine.
2. Make the script executable:
   ```bash
   chmod +x gotchi_connshare.sh
   ```
4. Run the script in your terminal:
   ```bash
   sudo ./gotchi_connshare.sh
   ```
5. Accept the new key
6. Connect to your Pwnagotching:
   ```bash
   ssh USERNAME@10.0.0.2
   ```
