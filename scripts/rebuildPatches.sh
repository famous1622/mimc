function cleanupPatches {
	pushd "$1"
	for patch in *.patch; do
		gitver=$(tail -n 2 $patch | grep -ve "^$" | tail -n 1)
		diffs=$(git diff --staged $patch | grep -E "^(\+|\-)" | grep -Ev "(From [a-z0-9]{32,}|\-\-\- a|\+\+\+ b|.index|Date\: )")

		testver=$(echo "$diffs" | tail -n 2 | grep -ve "^$" | tail -n 1 | grep "$gitver")
		if [ "x$testver" != "x" ]; then
			diffs=$(echo "$diffs" | tail -n +3)
		fi

		if [ "x$diffs" == "x" ] ; then
			git reset HEAD $patch >/dev/null
			git checkout -- $patch >/dev/null
		fi
	done
    popd
}

echo "Rebuilding patch files from current fork state..."
function savePatches {
	what=$1
	pushd $basedir/$what

	mkdir -p $basedir/patches/$2
	if [ -d ".git/rebase-apply" ]; then
		# in middle of a rebase, be smarter
		echo "REBASE DETECTED - PARTIAL SAVE"
		last=$(cat ".git/rebase-apply/last")
		next=$(cat ".git/rebase-apply/next")
		declare -a files=("$basedir/patches/$2/"*.patch)
		for i in $(seq -f "%04g" 1 1 $last)
		do
			if [ $i -lt $next ]; then
				rm "${files[`expr $i - 1`]}"
			fi
		done
	else
		rm $basedir/patches/$2/*.patch
	fi

	git format-patch --quiet -N -o $basedir/patches/$2 upstream/upstream
	popd
	git add -A $basedir/patches/$2
	cleanupPatches $basedir/patches/$2/
	echo "  Patches saved for $what to patches/$2"
}

basedir=$PWD
savePatches MIMCPaper/Paper-API api
savePatches MIMCPaper/Paper-Server server
savePatches MIMCWaterfall/Waterfall-Proxy proxy
