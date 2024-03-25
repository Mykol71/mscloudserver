msposapp
--------
msposapp manages containers that are full linux installs with the RTI POS system installed and configured.
it can manage multiple vpns from each container to a different home location.

03/24/2024  8:21 PM - 2.6
┏━━━━━━━━
┃ @ Mike's Store
┃ )~ Containers
┃━
┃ Shopcode : 12345678
┃ OS Vers  : rocky9
┃ Status   : running
┃ IP Addr  : 192.168.11.103 
┃
┃-Containers
┃ 1. Status
┃ 2. Start/Stop
┃ 3. Connect
┃
┃-VPNs
┃ 4. Status
┃ 5. Start/Stop
┃ 6. Create
┃ 7. Delete
┃
┃-System
┃ s. Shopcode
┃ i. Install
┃ p. Purge
┃ r. Readme
┃ x. Exit
┗━
Enter selection: 

Status area -
- Shopcode
current set shop identifier is displayed in the status area at the top of the menu.
- OS Vers -
Flavor and version of the container.
- Status -
Container running status.
- IP Addr -
Local network IP Address.

Containers -
- Status
displays the detailed status info for all running containers (shops) on the server.

- Start/Stop
if the current shop identifier has a container running, it stops it. if not, it starts one.
if the current shop identifier has a tfrsync.pl cloud backup on this server, it will ask if you want to restore data from it.

- Connect
connects to the current shop identifier's container.

VPNs -
- Status
displays detailed status of all VPNs running on the current shop identifiers container.

- Start/Stop
if the currennt shop identifier's vpn service is not running, it starts it. if it is, it stops it.

- Create
adds a VPN to a remote location. (must stop/start VPNs after.)

- Delete
removes a VPN connection from the current shop identifier's container. (must stop/start VPNs after.)

System -
- Shopcode
Allows you to set the current working shop identifier.

- Install
Installs the required packages and make needed config changes for msposapp if not already done.
Ask for a shop identifier, name, and os version, if not already set.
Ask if want to Build/rebuild the base image.
Check for OS updates every time it is ran, after the initial installation.

- Purge
Stops all containers, wipes all container images, all podman cache, and any shop-specific, or image data. (clean slate.)

- Exit
Previous menu.

---
mgreen@teleflora.com
