# Disko Disk Configuration
#
# This declaratively defines your disk partitioning scheme.
# Disko will partition, format, and mount everything for you.
#
# This example assumes:
#   - Single NVMe drive (change /dev/nvme0n1 to /dev/sda for SATA)
#   - UEFI boot (GPT partition table)
#   - ext4 filesystem (simple, reliable)
#
# For other setups, see: https://github.com/nix-community/disko/tree/master/example

{ lib, ... }:

{
  disko.devices = {
    disk = {
      main = {
        # CHANGE THIS to match your target drive
        # Use `lsblk` to find your drive name
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition (ESP) - required for UEFI boot
            ESP = {
              size = "512M";
              type = "EF00";  # EFI system partition type
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            # Root partition - takes remaining space
            root = {
              size = "100%";  # Use all remaining space
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}

# =============================================================================
# ALTERNATIVE CONFIGURATIONS
# =============================================================================

# -----------------------------------------------------------------------------
# With swap partition:
# -----------------------------------------------------------------------------
#
# partitions = {
#   ESP = { ... };  # same as above
#
#   swap = {
#     size = "16G";  # Match your RAM for hibernation, or less for just swap
#     content = {
#       type = "swap";
#       resumeDevice = true;  # Enable hibernation to this device
#     };
#   };
#
#   root = {
#     size = "100%";
#     content = { ... };  # same as above
#   };
# };

# -----------------------------------------------------------------------------
# Btrfs with subvolumes (popular for NixOS - enables snapshots):
# -----------------------------------------------------------------------------
#
# root = {
#   size = "100%";
#   content = {
#     type = "btrfs";
#     extraArgs = [ "-f" ];  # Force overwrite
#     subvolumes = {
#       "/root" = {
#         mountpoint = "/";
#         mountOptions = [ "compress=zstd" "noatime" ];
#       };
#       "/home" = {
#         mountpoint = "/home";
#         mountOptions = [ "compress=zstd" "noatime" ];
#       };
#       "/nix" = {
#         mountpoint = "/nix";
#         mountOptions = [ "compress=zstd" "noatime" ];
#       };
#       "/snapshots" = {
#         mountpoint = "/.snapshots";
#         mountOptions = [ "compress=zstd" "noatime" ];
#       };
#     };
#   };
# };

# -----------------------------------------------------------------------------
# Legacy BIOS (MBR) instead of UEFI:
# -----------------------------------------------------------------------------
#
# content = {
#   type = "gpt";  # Can still use GPT with BIOS
#   partitions = {
#     boot = {
#       size = "1M";
#       type = "EF02";  # BIOS boot partition
#     };
#     root = {
#       size = "100%";
#       content = {
#         type = "filesystem";
#         format = "ext4";
#         mountpoint = "/";
#       };
#     };
#   };
# };

# -----------------------------------------------------------------------------
# SATA/HDD drive (just change the device path):
# -----------------------------------------------------------------------------
#
# device = "/dev/sda";  # instead of /dev/nvme0n1
