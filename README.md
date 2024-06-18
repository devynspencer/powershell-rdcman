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

## Install

Install from GitHub source:

```powershell
git clone 'https://github.com/devynspencer/powershell-rdcman'
cd .\powershell-rdcman
```

## Examples

Get an RDCMan configuration as a PowerShell object:

```powershell
Get-RDCManConfiguration -Path 'C:\path\to\rdcman.rdg'
```
