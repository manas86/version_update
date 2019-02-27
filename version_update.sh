#!/usr/bin/env bash

__REGEX="^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)"

PROG=version_update.sh

USAGE="\
Automates version tag creation.

Usage:
Commands: patch|minor|major|current 'commit message'

Example:
==========
Show current version:   ./$PROG current
Patch version:          ./$PROG patch 'Fix typo'
Minor version:          ./$PROG minor 'Add filters'
Major version:          ./$PROG major 'Module Chane'
==========
"

function error() {
    echo -e "$1" >&2
    exit 1
}

function showHelp() {
    error "$USAGE"
}

function showSuccess() {
    echo
	echo "Tag v$major.$minor.$patch was created in local repository."
	echo
	echo "Push it:"
	echo
	echo "    git push origin v$major.$minor.$patch"
	echo
	echo "Delete tag:"
	echo
	echo "    git tag -d v$major.$minor.$patch"
	echo
}

function execute() {
    cmd=("$@")
	echo
    echo "Executing ${cmd[*]} ..."
	echo
    # execute the command:
    "${cmd[@]}"
}

function confirm() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}


function getMessage() {
	echo $@
}


latest_tag=$(git describe --tags --long 2>/dev/null)

# latest_tag=2.3.0

if [[ -z ${latest_tag} ]];
then
    latest_tag='0.0.0'
fi

tag_2_update=${latest_tag%%-*}

if [[ "$tag_2_update" =~ $__REGEX ]]; then

    major=${BASH_REMATCH[1]}
    minor=${BASH_REMATCH[2]}
    patch=${BASH_REMATCH[3]}

    parts=(\"$major\" \"$minor\" \"$patch\")
fi

#echo ${parts[0]} # major
#echo ${parts[1]} # minor
#echo ${parts[2]} # patch

last="$major.$minor.$patch"
mode=''
force=false

while [ -n "$1" ]
do
    if [[ -z "$2" ]]
	then
		echo "No commit message provided. You must provide a commit message";
		exit 1;
	else
        case "$1"
        in
            -f|--force)
                force=true;;
            -h|--help)
                showHelp
                exit 0;;
            patch)
                patch=$((patch + 1))
                msg=$(getMessage $2)
                shift 1
                mode='patch';;
            minor)
                minor=$((minor + 1))
                patch=0
                msg=$(getMessage $2)
                shift 1
                mode='minor';;
            major)
                major=$((major + 1))
                minor=0
                patch=0
                msg=$(getMessage $2)
                shift 1
                mode='major';;
            current)
                echo "Current version: ${last}"
                exit 0;;
            help)
                showHelp;;
            *)
                echo "$1 option is not valid"
                exit 1;;
        esac
        shift 1;
    fi
done

if [[ -z "$mode" ]]
then
	showHelp;
	exit 0;
fi

echo "Current version : $last"
echo "New tag         : $major.$minor.$patch"
echo "Commit Message  : $msg"

if [[ "$force" = true ]]; then
	execute git tag -a "$major.$minor.$patch" -m "$msg ($mode version)"
	execute git push origin "$major.$minor.$patch"
	echo
	echo "Version tag created and pushed"
	exit 0;
fi

if [[ "yes" == $(confirm "Do you agree?") ]]
then
	execute git tag -a "$major.$minor.$patch" -m "$msg ($mode version)"

	showSuccess;

	if [[ "yes" == $(confirm "Do you want to push this tag right now?") ]]
	then
		execute git push origin "$major.$minor.$patch"
	fi
else
    echo "No tag was created."
    exit 0
fi

exit 0
