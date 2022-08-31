#!/bin/sh

# set -e

which butler

echo "Checking application versions..."
echo "-----------------------------"
cat ~/.local/share/godot/templates/3.3.stable/version.txt
godot --version
butler -V
echo "-----------------------------"

mkdir build/
mkdir build/linux/
mkdir build/osx/
mkdir build/win/

echo "EXPORTING FOR LINUX"
echo "-----------------------------"
godot --export "Linux/X11" build/linux/space-survivor.x86_64 -v
# echo "EXPORTING FOR OSX"
# echo "-----------------------------"
# godot --export "Mac OSX" build/osx/space-survivor.dmg -v
echo "EXPORTING FOR WINDOZE"
echo "-----------------------------"
godot --export-debug "Windows Desktop" build/win/space-survivor.exe -v
echo "-----------------------------"

# echo "CHANGING FILETYPE AND CHMOD EXECUTABLE FOR OSX"
# echo "-----------------------------"
# cd build/osx/
# mv space-survivor.dmg space-survivor-osx-alpha.zip
# unzip space-survivor-osx-alpha.zip
# rm space-survivor-osx-alpha.zip
# chmod +x space-survivor.app/Contents/MacOS/space-survivor
# zip -r space-survivor-osx-alpha.zip space-survivor.app
# rm -rf space-survivor.app
# cd ../../

ls -al
ls -al build/
ls -al build/linux/
ls -al build/osx/
ls -al build/win/

echo "ZIPPING FOR WINDOZE"
echo "-----------------------------"
cd build/win/
zip -r space-survivor-win-alpha.zip space-survivor.exe space-survivor.pck
rm -r space-survivor.exe space-survivor.pck
cd ../../

echo "ZIPPING FOR LINUX"
echo "-----------------------------"
cd build/linux/
zip -r space-survivor-linux-alpha.zip space-survivor.x86_64 space-survivor.pck
rm -r space-survivor.x86_64 space-survivor.pck
cd ../../

echo "Logging in to Butler"
echo "-----------------------------"
butler login

echo "Pushing builds with Butler"
echo "-----------------------------"
butler push build/linux/ synsugarstudio/space-survivor:linux-alpha
# butler push build/osx/ synsugarstudio/space-survivor:osx-alpha
butler push build/win/ synsugarstudio/space-survivor:win-alpha
