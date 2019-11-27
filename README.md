# batch-easy-WS-updater
Easily update your add-ons with drag&amp;drop

# Requirements
Windows

# How to install
1. Put all of those files into a single seperated folder
2. Remove the content of `addon_data.bat` and insert your already existing add-on folders + IDs (keep the syntax: `SET [foldername]=[WorkshopID]`). New uploaded add-ons (with this tool) will be inserted automatically.
3. Change `update_addon.bat:48` (line 48 / https://github.com/Alf21/batch-easy-WS-updater/blob/7f26783a5075c3fc4f169a77655df5761c4788f2/update_addon.bat#L48) to match the path to gmod's bin folder on your system
4. Change `upload_addon.bat:117` (line 117 / https://github.com/Alf21/batch-easy-WS-updater/blob/7f26783a5075c3fc4f169a77655df5761c4788f2/upload_addon.bat#L117) to match the path to gmod's bin folder on your system

# How to register shortcuts for the right-click menu
1. Modify `update_addon.reg` (ll. 13, 20, 27 / https://github.com/Alf21/batch-easy-WS-updater/blob/master/update_addon.reg) to match the path of the new created folder in `How to install - step 1`
2. Run (click on) `update_addon.reg`. Now you can right-click on a folder and upload / update it directly

# FAQ
### Q: Nothing happens
#### A: Keep sure to be logged into steam with your steam account. If you modified the path or moved your folder with these files, keep sure to repeat `How to install`.

### Q: How do I update or add an image to my add-on?
#### A: Just insert a gmod image (https://wiki.garrysmod.com/page/Workshop_Addon_Creation) with the exact name of the folder into the folder.
