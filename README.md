# Dev-shell patch for prusti

## Overview

This repo contains a dev-shell patch for [prusti](https://www.pm.inf.ethz.ch/research/prusti.html) and a small rust example which you can test with if prusti works correctly.

## How to run
After you've cloned the repo, go to the repo directory and run direnv allow. You can test if all dependencies are set up correctly by running `patch-prusti` in the terminal.  
If no error has ocurred you can open Visual Studio Code and download the extension `Prusti Assistant` . After opening the `main.rs` file through vscode you will see a button on the bottom left named `Prusti`. Pressing it will run the proof assistant which should underline the assert line in the main function.  

If errors have ocurred then you would need to fix the paths in the `shell.nix` file.  
One of the path is for the jdk which is needed for the prusti-server-driver. Rest of the paths that may need modifying are contained in the patch-prusti ShellScriptBin.