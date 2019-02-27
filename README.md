# version_update

Bash command to automate tag semantic versioning in a git repository.

## Commands

`help` - Shows a help
`current` - Shows the last version tag found. If there is none it defaults to `0.0.0`  
`patch` - Increases patch version: `1.0.0 -> 1.0.1`  
`minor` - Increases minor version (and resets patch): `1.0.5 -> 1.1.0`  
`major` - Increases major version (and resets minor and patch): `1.3.4 -> 2.0.0`  

## Options
`-f|--force` - Script won't ask for confirmation.

## Installation

* Copy the script to the place you want. Best in your $PATH.
* Make it executable if needed.


## Known limitations

You should update your master before running `version_update` in order to get the latests tags from the remote repo. 

## Basic usage

```
./version_update.sh patch|minor|major 'Tag message'
```

The command will show current and updated version and will prompt you to create the tag in the local version.

After that, it will prompt you to push the tag to remote repository.

That's all.

This is an example of the full interaction to tag the first version of version tag (sort of auto-referencing)

```bash
➜  version_update git:(master) ./version_update.sh major "First usable version"

Current version : 0.0.0
New tag         : 1.0.0
Do you agree? ([y]es or [N]o): y

Executing git tag -a v1.0.0 -m First usable version (major version) ...


Tag 1.0.0 was created in local repository.

Push it:

    git push origin 1.0.0

Delete tag:

    git tag -d 1.0.0

Do you want to push this tag right now? ([y]es or [N]o): y

Executing git push origin 1.0.0 ...

Counting objects: 1, done.
Writing objects: 100% (1/1), 179 bytes | 179.00 KiB/s, done.
Total 1 (delta 0), reused 0 (delta 0)
To https://github.com/franiglesias/versiontag
 * [new tag]         1.0.0 -> 1.0.0
```

## Examples

Show current version

```bash
./version_update.sh current
```

Patch version

```bash
./version_update.sh patch 'cosmetic change'
```

Force patch version

```bash
./version_update.sh patch 'Fix Database view' --force
```

Minor version

```bash
./version_update.sh minor 'Add Customer '
```

Major version

```bash
./version_update.sh major ' module Change'
```
