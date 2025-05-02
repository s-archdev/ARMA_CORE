# macOS USB Executable Loader

A portable, configurable system for running executables from a USB drive on macOS systems.

## Overview

The macOS USB Executable Loader provides a secure and flexible framework for creating portable executable environments that function on macOS systems. It allows for running applications directly from a USB drive without installation, making it ideal for portable toolkits, diagnostic utilities, and deployment scenarios.

![USB Executable Loader](https://via.placeholder.com/800x400?text=macOS+USB+Executable+Loader)

## Features

- **Portable Execution**: Run applications directly from a USB drive without installation
- **Secure Authentication**: Integrates with macOS security frameworks for proper authorization
- **Configurable Environment**: Easy-to-modify settings without recompilation
- **Extension Controls**: Restrict which types of executables can be run
- **Activity Logging**: Comprehensive logging of all execution activity
- **Simple Interface**: Command-line interface with straightforward options

## Requirements

- macOS 10.13 (High Sierra) or later
- USB drive with at least 1GB of free space
- Administrative privileges (for initial setup)
- Xcode Command Line Tools (for building from source)

## Getting Started

### Building from Source

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/mac-usb-loader.git
   cd mac-usb-loader
   ```

2. Build the loader:
   ```
   make
   ```

### Preparing a USB Drive

1. Run the USB preparation script (replace `/dev/diskX` with your USB device):
   ```
   sudo ./prepare_usb.sh /dev/diskX MacToolKit
   ```
   
   > ⚠️ **WARNING**: This will erase all data on the specified drive!

2. Install the loader to the USB drive:
   ```
   make install
   ```

### Using the Loader

1. Connect the USB drive to a Mac
2. Open Terminal and navigate to the drive:
   ```
   cd /Volumes/MacToolKit
   ```

3. List available executables:
   ```
   ./mac_usb_loader --list
   ```

4. Run an executable:
   ```
   ./mac_usb_loader <executable_name> [args...]
   ```

## Directory Structure

The USB drive follows this structure:

```
/
├── mac_usb_loader        # Main loader executable
├── executables/          # Directory for portable executables
│   └── hello.sh          # Example script
├── config/               # Configuration files
│   └── loader.conf       # Main configuration
└── logs/                 # Execution logs
    └── loader.log        # Activity log file
```

## Configuration

The behavior of the loader can be modified by editing `config/loader.conf`:

```ini
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
```

## Security Considerations

The macOS USB Executable Loader includes several security features:

- **Authentication**: Uses macOS security frameworks to request appropriate permissions
- **Extension Whitelist**: Only allows execution of files with approved extensions
- **Executable Permission Checks**: Verifies execution permissions before running programs
- **Activity Logging**: Maintains detailed logs of all execution attempts

However, be aware of these limitations:

- The loader does not perform code signing verification beyond what macOS enforces
- Elevated privileges may be required for certain operations
- The security of executables depends on the security of the USB drive itself

## Development and Customization

### Adding Your Own Executables

Place your executables in the `executables/` directory on the USB drive. Make sure they have the correct permissions:

```
chmod +x /Volumes/MacToolKit/executables/your_program
```

### Creating a Custom Distribution

You can create a disk image for distribution:

```
make disk_image
```

This will create `build/MacUSBLoader.dmg` which can be distributed and used to prepare USB drives.

### Extending the Loader

The loader can be extended in several ways:

1. **Adding new allowed extensions**: Edit `config/loader.conf`
2. **Implementing a GUI wrapper**: Create a macOS application that calls the loader
3. **Custom authentication**: Modify the `request_authorization()` function
4. **Plugin system**: Implement a plugin architecture for extending functionality

## Troubleshooting

### Common Issues

1. **"Operation not permitted" errors**
   - Ensure the loader has execution permissions
   - Check System Integrity Protection settings

2. **Executable not found**
   - Verify the executable is in the correct directory
   - Check file permissions

3. **USB drive not bootable**
   - Ensure the preparation script completed successfully
   - Some Mac models may have additional security restrictions

### Logs

Check the log file for detailed information about execution attempts:

```
cat /Volumes/MacToolKit/logs/loader.log
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Future Development

Planned features for future releases:

- GUI interface for easier navigation and execution
- Code signing implementation for enhanced security
- Update mechanism for keeping executables current
- Custom EFI bootloader for true boot-time execution
- Cross-platform support for Windows and Linux systems

## Acknowledgments

- Apple's Security and CoreFoundation frameworks
- The open-source community for inspiration and guidance
- All contributors who have helped shape this project
