# nvm-windows-UPDATE

A Node.js version management utility for Windows — a fork of [coreybutler/nvm-windows](https://github.com/coreybutler/nvm-windows) based on upstream v1.1.12, with additional fixes and enhancements.

## Notable features

- Manage multiple Node.js versions on Windows
- Install, switch, and remove Node.js versions from the command line
- User-mode support (run nvm commands as a regular user)
- Supports `.nvmrc` files (compatible with nvm-sh; trims whitespace)
- Handles spaces in installation and nvm paths
- ARM64 architecture support and improved version-check logic
- Command aliases: `i` (install) and `rm` (remove)
- Streamlined build / no-install packaging

### Usage

```sh
nvm install <version>    # or: nvm i <version>
nvm use <version>
nvm remove <version>     # or: nvm rm <version>
nvm list
```

#### User mode
You can run `nvm` commands as a regular (non-admin) user. This makes Node.js version management easier and safer in restricted environments.

#### .nvmrc support
If a `.nvmrc` file is present in your project, `nvm use` and related commands will detect and use the version specified. The parser is more compatible with `nvm-sh` and trims leading/trailing whitespace.

#### Spaces in paths
Installation and management work even if your `nvm` or Node.js paths contain spaces.

### Architecture support

- x86, x64, ARM64

## What's new

- User-mode support for non-admin environments
- Improved `.nvmrc` handling (compatible with nvm-sh and trims whitespace)
- Support for spaces in file paths
- New command aliases: `i` and `rm`
- ARM64 support and improved version checks
- Updated build and packaging process

## License

[MIT](LICENSE)

---

> This project is a fork of [coreybutler/nvm-windows](https://github.com/coreybutler/nvm-windows) based on upstream v1.1.12, with additional enhancements.
