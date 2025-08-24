# nvm-windows-UPDATE

A Node.js version management utility for Windows, forked from [coreybutler/nvm-windows](https://github.com/coreybutler/nvm-windows) and enhanced with additional features and fixes.

## Notable Features

- Manage multiple Node.js versions on Windows
- Install, switch, and remove Node.js versions via command line
- User mode support (run nvm commands as a regular user)
- Supports `.nvmrc` files (with improved whitespace handling)
- Handles spaces in file paths
- ARM64 architecture and improved version check logic
- Command aliases: `i` (install), `rm` (remove)

### Usage

```sh
nvm install <version>    # or: nvm i <version>
nvm use <version>
nvm remove <version>     # or: nvm rm <version>
nvm list
```

#### User Mode
You can now run `nvm` commands as a regular (non-admin) user. This allows for easier and safer Node.js version management in restricted environments.

#### .nvmrc Support
If a `.nvmrc` file is present in your project, `nvm use` and other related commands will automatically detect and use the version specified within, even if extra spaces are present.

#### Spaces in Paths
Installation and management now work even if your path (e.g., to `nvm` or Node.js) contains spaces.

### Architecture Support

- x86, x64, and ARM64

## What's New

- User mode support for non-admin environments
- Improved `.nvmrc` handling (trims whitespace)
- Support for spaces in all file paths
- New command aliases: `i` and `rm`

## License

[MIT](LICENSE)

---

> This project is a fork of [coreybutler/nvm-windows](https://github.com/coreybutler/nvm-windows) with additional enhancements.