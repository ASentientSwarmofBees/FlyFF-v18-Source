This repo contains the source code for FlyFF v18. It does not contain any of the other assets or files for the game; those can be found from the original v18 source .zip.

To build in VS:
Open /Source/Source/all/all.sln
Build all projects targetting Release, except for Neuz which is built targetting NoGameguard

After building in VS, run the helper scripts:
- Move Compiles.bat
/Server/Resource/- Merge.exe
/Client/- Copy Client Files.bat

To start the servers, run:
/Server/- Start All Servers.bat

To start a client, run:
/Client/- Start Game.bat