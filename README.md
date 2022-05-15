# w3d-vgui
An easy 3D vgui creation library in Garry's Mod.  
⚒ **Warning:** This is still in phase of development, please don't use this for a public usage yet. ⚒

### Installation
1. Download the repo and copy the **w3d_vgui.lua** file into the **/lua/client/** folder of your addon/gamemode.  
2. Restart your server and have fun.  

*Don't forget to **include** the file clientside if you are using a custom loader!* ⚠️

### Usage
You can see multiple cases of usages in the **examples/** folder of the repo.  
The usage is pretty easy - anyway no documentation has been made yet.

### VGUI Elements types
At the moment, only theses exact types are available in the library:
- ``DButton`` - A simple button, copying the idea of the DButton vgui element.

Feel free to add your own elements and make a PR!

### How does it work ?
This is actually pretty simple to understand.  
To make a long story short, we can check that a player is hovering a button by getting his "line of sight" direction.  
If at any moment this direction passes through a plane (= the button shape), we know that he's hovering the button.  
 
Afterwards - with some math calculations - we can determine what is the current mouse position of the player based on where he's aiming at and if this position is into the button drawn on the screen.  
All that's left to do is simply make a callback system and so on...
