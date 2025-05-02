#!/bin/bash
# Script to prepare a USB drive for the macOS USB Executable Loader

# Exit on any error
set -e

# Check if running with elevated privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi

# Check arguments
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <device> [volume_name]"
  echo "Example: $0 /dev/disk2 MacToolKit"
  exit 1
fi

DEVICE=$1
VOLUME_NAME=${2:-"MacToolKit"}

# Confirm with user
echo "WARNING: This will erase all data on $DEVICE"
echo "The device will be formatted as a bootable macOS drive named '$VOLUME_NAME'"
read -p "Are you sure you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled"
  exit 1
fi

# Unmount device if mounted
diskutil unmountDisk $DEVICE || true

# Format the drive with GUID partition table
echo "Creating GUID partition table..."
diskutil partitionDisk $DEVICE GPT JHFS+ "$VOLUME_NAME" 100%

# Get the partition identifier
PARTITION=$(diskutil list $DEVICE | grep "$VOLUME_NAME" | awk '{print $NF}')
MOUNT_POINT="/Volumes/$VOLUME_NAME"

echo "Drive formatted. Partition: $PARTITION"
echo "Mount point: $MOUNT_POINT"

# Make the drive bootable for macOS (basic support)
echo "Setting up directory structure..."
mkdir -p "$MOUNT_POINT/executables"
mkdir -p "$MOUNT_POINT/config"
mkdir -p "$MOUNT_POINT/logs"

# Create a basic README file
cat > "$MOUNT_POINT/README.txt" << EOF
macOS USB Executable Loader
==========================

This USB drive contains a tool that allows you to run executables directly from the drive.

Usage:
1. Open Terminal
2. Navigate to this drive: cd "$MOUNT_POINT"
3. Run the loader: ./mac_usb_loader <executable_name>
4. Or list available executables: ./mac_usb_loader --list

See documentation for more details.
EOF

echo "Basic structure created"

# If the loader binary exists in the current directory, copy it
if [ -f "./mac_usb_loader" ]; then
  echo "Copying loader binary..."
  cp ./mac_usb_loader "$MOUNT_POINT/"
  chmod +x "$MOUNT_POINT/mac_usb_loader"
else
  echo "Warning: mac_usb_loader binary not found in current directory"
  echo "You'll need to build and copy it manually"
fi

# If config exists, copy it
if [ -f "./config/loader.conf" ]; then
  echo "Copying configuration..."
  cp ./config/loader.conf "$MOUNT_POINT/config/"
else
  echo "Creating default configuration..."
  mkdir -p "$MOUNT_POINT/config"
  cat > "$MOUNT_POINT/config/loader.conf" << EOF
# USB Executable Loader Configuration

# Directory where executables are stored (relative to USB root)
executable_dir = executables

# Log file path (relative to USB root)
log_path = logs/loader.log

# Whether to require macOS authorization before execution (true/false)
require_auth = true

# Allowed file extensions (up to 10)
allowed_ext1 = bin
allowed_ext2 = sh
allowed_ext3 = py
allowed_ext4 = app
allowed_ext5 = command
EOF
fi

# Create a sample script as a test
echo "Creating a sample script..."
cat > "$MOUNT_POINT/executables/hello.sh" << EOF
#!/bin/bash
echo "Hello from the USB drive!"
echo "Current directory: \$(pwd)"
echo "Running on \$(uname -a)"
EOF
chmod +x "$MOUNT_POINT/executables/hello.sh"

echo "Drive preparation complete!"
echo "Your USB drive is now ready to use with the macOS USB Executable Loader."
echo "You can find it mounted at: $MOUNT_POINT"
