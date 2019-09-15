#!/usr/bin/env bash

case "$1" in
    "rb" | "rbp" | "rebuild")
        scripts/rebuildPatches.sh
    ;;
    "p" | "patch" ) 
        scripts/applyPatches.sh
    ;;
    "setup" )
        scripts/setup.sh
    ;;
    * ) 
        echo "MIMC build tool command."
        echo ""
        echo "Commands:"
        echo "  * rb, rbp, rebuild | Rebuilds the patches"
        echo "  * p, patch         | Applies all the patches to PaperMC projects."
        echo "  * setup            | Sets up the repo"
esac