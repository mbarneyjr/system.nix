# NixOS Installation Guide (with Disko)

Complete walkthrough from boot to running system.

## Prerequisites

- USB drive with NixOS installer (download from nixos.org)
- Target machine (UEFI, x86_64)
- Network connection (ethernet easiest, wifi works)
- Your config repo URL (or you can clone after setup)

---

## Step 1: Boot the Installer

1. Boot from USB (F12, F2, or Del during POST for boot menu)
2. Select the NixOS installer
3. You'll land at a root shell (or login as `nixos` with empty password if graphical)

---

## Step 2: Connect to Network

**Ethernet**: Should auto-connect. Test with:
```bash
ping -c 3 google.com
```

**WiFi**:
```bash
# Interactive wifi setup
nmtui

# Or command line:
nmcli device wifi list
nmcli device wifi connect "YourSSID" password "YourPassword"
```

---

## Step 3: Identify Your Target Disk

```bash
lsblk
```

Output looks like:
```
NAME        SIZE TYPE
nvme0n1     500G disk      <-- NVMe drive (use this name)
sda         500G disk      <-- SATA drive alternative
```

**Remember your disk name** - you'll need it for disko config.

⚠️ **WARNING**: The next step will ERASE this disk completely!

---

## Step 4: Clone Your Config Repo

```bash
# Create a temp working directory
cd /tmp

# Clone your repo
git clone https://github.com/YOUR_USER/YOUR_REPO nixos-config
cd nixos-config

# Or if your repo is private, you can also just create the files manually
```

---

## Step 5: Update disk-config.nix with Your Disk

Edit `disk-config.nix` and set the correct device:

```bash
nano disk-config.nix   # or vim
```

Find this line and update it:
```nix
device = "/dev/nvme0n1";  # Change to match your disk from lsblk
```

Save and exit.

---

## Step 6: Run Disko (Partition & Format)

This is the point of no return - disko will wipe and partition the disk:

```bash
# Run disko in "disko" mode (partition + format + mount)
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko \
  ./disk-config.nix
```

This will:
1. Create GPT partition table
2. Create ESP partition (512MB, FAT32)
3. Create root partition (remaining space, ext4)
4. Mount everything at `/mnt`

Verify it worked:
```bash
lsblk
# Should show partitions under your disk

mount | grep /mnt
# Should show /mnt and /mnt/boot mounted
```

---

## Step 7: Generate Hardware Configuration

```bash
# Generate hardware config (kernel modules, CPU detection, etc.)
# --no-filesystems because disko handles mounts
nixos-generate-config --root /mnt --no-filesystems
```

This creates `/mnt/etc/nixos/hardware-configuration.nix` with:
- Detected kernel modules for your hardware
- CPU microcode settings
- Any hardware-specific quirks

You can inspect it:
```bash
cat /mnt/etc/nixos/hardware-configuration.nix
```

---

## Step 8: Install NixOS

```bash
# Install using your flake config
sudo nixos-install --flake /tmp/nixos-config#default
```

This will:
1. Build your full system configuration
2. Install everything to /mnt
3. Prompt you to set the root password

**Set the root password when prompted** (you'll need it if something goes wrong).

The install takes a while - it's downloading and building your entire system.

---

## Step 9: Set Your User Password

Before rebooting, set your user password:

```bash
# Chroot into the installed system
nixos-enter --root /mnt

# Set password for your user
passwd mbarney

# Exit chroot
exit
```

---

## Step 10: Reboot

```bash
reboot
```

Remove the USB drive when prompted (or immediately).

---

## Step 11: First Boot

1. GRUB/systemd-boot will appear - select NixOS
2. SDDM login screen appears (KDE)
3. Login with `mbarney` and the password you set

---

## Post-Install: Clone Your Repo Permanently

Your config is currently in `/tmp` on the installer (now gone). Clone it to your home:

```bash
cd ~
git clone https://github.com/YOUR_USER/YOUR_REPO system.nix
```

Future updates:
```bash
cd ~/system.nix
git pull
sudo nixos-rebuild switch --flake .#default
```

---

## Troubleshooting

### Can't boot after install
- Boot back into installer USB
- Mount your partitions manually:
  ```bash
  mount /dev/nvme0n1p2 /mnt
  mount /dev/nvme0n1p1 /mnt/boot
  ```
- Chroot and fix: `nixos-enter --root /mnt`

### WiFi not working after install
- NetworkManager should be running. Check: `systemctl status NetworkManager`
- Connect via: `nmtui` or `nmcli`

### Wrong disk device name
- NVMe: `/dev/nvme0n1` (partitions: `nvme0n1p1`, `nvme0n1p2`)
- SATA: `/dev/sda` (partitions: `sda1`, `sda2`)
- Use `lsblk` to verify

### "experimental features" error
- Add `--extra-experimental-features "nix-command flakes"` to commands

### Permission denied
- Most install commands need `sudo`

---

## Quick Reference Commands

```bash
# Connect wifi
nmtui

# List disks
lsblk

# Run disko
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disk-config.nix

# Generate hardware config
nixos-generate-config --root /mnt --no-filesystems

# Install
sudo nixos-install --flake .#default

# Set user password (from installer)
nixos-enter --root /mnt -c 'passwd mbarney'

# Rebuild after changes (post-install)
sudo nixos-rebuild switch --flake ~/system.nix#default
```
