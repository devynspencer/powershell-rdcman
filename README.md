# RDCMan

Tools for streamlining [Remote Desktop Configuration Manager](https://learn.microsoft.com/en-us/sysinternals/downloads/rdcman) tasks, including:

- [ ] Import RDCMan configuration (servers, groups, and settings) from JSON, CSV, XML, PSD1, and Active Directory.
- [ ] Import RDCMan credentials from credential objects, secure strings, `Microsoft.PowerShell.SecretStore`, and [KeePass](https://keepass.info/).
- [ ] Export RDCMan configuration to JSON, CSV, XML, PSD1.
- [ ] Generate new RDCMan configuration.
- [ ] Validate RDCMan configuration format.
- [ ] Compare RDCMan groups to Active Directory OUs, containers, and groups.
- [ ] Update RDCMan configuration from JSON, CSV, XML, PSD1, and Active Directory.
- [ ] Backup RDCMan configuration.
- [ ] Set RDCMan [policies](https://learn.microsoft.com/en-us/sysinternals/downloads/rdcman#policies)
- [ ] Encrypt RDCMan credentials using [CryptProtectData](https://docs.microsoft.com/en-us/windows/win32/api/dpapi/nf-dpapi-cryptprotectdata) or an [x509 certificate](https://learn.microsoft.com/en-us/sysinternals/downloads/rdcman#encryption-settings).
- [ ] Start RDCMan with a specific configuration and/or immediately connect to a list of servers.

## Install

Install from GitHub source:

```powershell
git clone 'https://github.com/devynspencer/powershell-rdcman'
cd .\powershell-rdcman
```

## Environment

This module looks for the following environment variables:

```
RDCMAN_BACKUP_PATH=C:\path\to\rdcman-backup.rdg
RDCMAN_BACKUP_COUNT=5
RDCMAN_CONFIG_PATH=C:\path\to\rdcman.rdg
RDCMAN_PATH=C:\path\to\RDCMan.exe
RDCMAN_EXPORT_FORMAT=JSON
```

Alternatively, these can be added to a local secret store using `Microsoft.PowerShell.SecretStore`:

```powershell
Set-Secret -Name 'RDCMAN_BACKUP_PATH' -Secret 'C:\path\to\rdcman-backup.rdg'
Set-Secret -Name 'RDCMAN_BACKUP_COUNT' -Secret 5

# ...
```

## Examples

Get an RDCMan configuration as a PowerShell object:

```powershell
Get-RDCManConfiguration -Path 'C:\path\to\rdcman.rdg'
```
