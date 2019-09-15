#!/usr/bin/env bash
gpgsign="$(git config commit.gpgsign || echo "false")"

function applyPatch {
	what=$1
	what_name=$(basename $what)
	target=$2
	branch=$3
	patch_folder=$4
    
	pushd $what
	git fetch --all
	git branch -f upstream "$branch"
    
    popd
    if [ ! -d  "./$target" ]; then
    	mkdir -p "$target"
		pushd "$target"
		git init
		# git remote add origin $5
	    popd
	fi
    pushd $target

    git config commit.gpgsign false

    echo "Resetting $target to $what_name..."
    git remote rm upstream
    git remote add upstream $what
    git checkout master || git checkout -b master
    git fetch upstream
    git reset --hard upstream/upstream
    echo "  Applying patches to $target..."
    git am --abort >/dev/null 
    echo "$patch_folder/"*.patch
    git am --3way --ignore-whitespace "$patch_folder/"*.patch
    # git apply --ignore-space-change --ignore-whitespace "$patch_folder/"*.patch
    # for patch in "$patch_folder/"*.patch; do echo $patch; git apply --ignore-space-change --ignore-whitespace $patch; done
    if [ "$?" != "0" ]; then
		echo "  Something did not apply cleanly to $target."
		echo "  Please review above details and finish the apply then"
		echo "  save the changes with rebuildPatches.sh"
		exit 1
	else
		echo "  Patches applied cleanly to $target"
	fi
    popd
}

echo "[MIMC] Applying Paper API Patches..."
applyPatch $PWD/Paper/Paper-API MIMCPaper/Paper-API HEAD $PWD/paper-api-patches 

echo "[MIMC] Applying Paper Server Patches..."
applyPatch $PWD/Paper/Paper-Server MIMCPaper/Paper-Server HEAD $PWD/paper-patches 

echo "[MIMC] Applying Waterfall Patches..."
applyPatch $PWD/Waterfall/Waterfall-Proxy MIMCWaterfall/Waterfall-Proxy HEAD $PWD/waterfall-patches 