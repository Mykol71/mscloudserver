# Basic setup information
url --url="http://tfrhelrepo.centralus.cloudapp.azure.com/rhel-7-server-rpms/"
keyboard us
selinux --permissive
firewall --disabled
skipx
timezone  America/Chicago
network --bootproto=dhcp --activate --onboot=on
shutdown
bootloader --disable
lang en_US
firstboot --disable
logging --level=info
auth  --useshadow --passalgo=sha512

#users
rootpw --iscrypted $6$G/P1TGIsGMWZ9aak$Sm/HZ1fcdfdmTdy4k2BTMv9Sw.mQOhrgtvMD5e8oo7t3uCtX2T005e/afw46a6TkODKkP8b9SrUgSAnjKxxfi1
user --groups=wheel,rti --name=tfsupport --password=$6$G/P1TGIsGMWZ9aak$Sm/HZ1fcdfdmTdy4k2BTMv9Sw.mQOhrgtvMD5e8oo7t3uCtX2T005e/afw46a6TkODKkP8b9SrUgSAnjKxxfi1 --iscrypted --gecos="tfsupport"
user --groups=rti --name=odbc --password=$6$G/P1TGIsGMWZ9aak$Sm/HZ1fcdfdmTdy4k2BTMv9Sw.mQOhrgtvMD5e8oo7t3uCtX2T005e/afw46a6TkODKkP8b9SrUgSAnjKxxfi1 --iscrypted --gecos="odbc"
user --groups=rti --name=rti --password=$6$G/P1TGIsGMWZ9aak$Sm/HZ1fcdfdmTdy4k2BTMv9Sw.mQOhrgtvMD5e8oo7t3uCtX2T005e/afw46a6TkODKkP8b9SrUgSAnjKxxfi1 --iscrypted --gecos="rti"
user --groups=rti --name=delivery --password=$6$G/P1TGIsGMWZ9aak$Sm/HZ1fcdfdmTdy4k2BTMv9Sw.mQOhrgtvMD5e8oo7t3uCtX2T005e/afw46a6TkODKkP8b9SrUgSAnjKxxfi1 --iscrypted --gecos="delivery"

# Disk setup
zerombr
clearpart --all --initlabel
part / --asprimary --fstype="ext4" --size=10000

%addon org_fedora_oscap
content-type = scap-security-guide
profile = pci-dss
%end

# Package setup
%packages --excludedocs --instLangs=en --nocore
@Base
bind-utils
bash
yum
vim-minimal
centos-release
less
iputils
iproute
systemd
initscripts
rootfiles
tar
passwd
yum-utils
yum-plugin-ovl
firewalld
java
samba
cups
minicom
elinks
telnet
mc
glibc
mutt
samba-client
slang
curl
sendmail
glibc.i686
strace
dvd+rw-tools
dialog
firstboot
mtools
cdrecord
fetchmail
net-snmp
vlock
sysstat
ntp
procps
e2fsprogs
audit
expect
ksh
nmap
uuid
libuuid
screen
dos2unix
unix2dos
yum-presto
ncurses-term
boost
biosdevname
iptables-services
perl-Digest
perl-Digest-MD5
deltarpm
openssh-server
openssl
%end
%post --log=/anaconda-post.log

sed -i "s/enabled=1/enabled=0/g" /etc/yum/pluginconf.d/subscription-manager.conf

# container customizations inside the chroot
#rpm -e kernel

echo 'container' > /etc/dnf/vars/infra

#Generate installtime file record
/bin/date +%Y%m%d_%H%M > /etc/BUILDTIME

# Limit languages to help reduce size.
LANG="en_US:UTF-8"
echo "%_install_langs $LANG" > /etc/rpm/macros.image-language-conf

# systemd fixes
:> /etc/machine-id
umount /run
systemd-tmpfiles --create --boot
# mask mounts and login bits
#systemctl mask systemd-logind.service getty.target console-getty.service sys-fs-fuse-connections.mount systemd-remount-fs.service dev-hugepages.mount

# Remove things we don't need
rm -f /etc/udev/hwdb.bin
rm -rf /usr/lib/udev/hwdb.d/
rm -rf /boot
rm -rf /var/lib/dnf/history.*

rm /var/run/nologin

ln -s /usr/bin/sh /bin/sh

cd /bin
curl -O http://rhel8repo.centralus.cloudapp.azure.com/ostools-1.17/updateos updateos
chmod +x /bin/updateos
systemctl start sendmail
systemctl start smb
systemctl start cups
systemctl start iptables
systemctl start sshd
systemctl start rhsm
systemctl enable sendmail
systemctl enable rhsm
systemctl enable sshd
systemctl enable smb
systemctl enable cups
systemctl enable iptables
%end
