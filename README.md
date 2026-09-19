This repo contains the source code for FlyFF v18. It does not contain any of the other assets or files for the game; those can be found from the original v18 source .zip.  


To build in VS:  
Open /Source/Source/all/all.sln  
Build all projects targetting Release, except for Neuz which is built targetting NoGameguard  

After building in VS, run the helper scripts:  
\- Move Compiles.bat  
/Server/Resource/- Merge.exe  
/Client/- Copy Client Files.bat  

To start the servers, run:  
/Server/- Start All Servers.bat  
Players can start their clients without the servers running, but they won't be able to connect until the World server is running (which takes about 30 seconds after it's launched).  
(Occasionally one of the servers will fail. Close them all and run the script again in that case.)  

To start a client, run:  
/Client/- Start Game.bat  

To stop the servers, run:  
/Server/- Stop All Servers.bat  


To register new accounts, run register_account.py after changing the username and password fields in the last line.


