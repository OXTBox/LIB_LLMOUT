script "SonnetLauncher"
######################################################################################
## SONNET LAUNCHER  (Sonnet 5.5, 21 Nov 2026)
## A small launcher for the cards in LIB_LLMOUT/Sonnet/cards, written beside the Game_Player's own
## GL.Open (LIB_DEV/livecode/game_launch.livecodescript), which only looks in LIB_GAMES. This one
## takes the same steps (engine library, player script, card script on a new stack "Play <name>")
## but reads the card from this folder. It changes nothing in LIB_GAMES or LIB_DEV.
##
## From the Message Box of any LiveCode / OXT-Beyond that can reach the files:
##   start using stack "//wsl$/Ubuntu/home/igame3d/projects/LIB_LLMOUT/Sonnet/sonnet_launcher.livecodescript"
##   Sonnet.Open "SonnetArcade"            -- the menu with all five games
##   Sonnet.Open "SonnetRuntime"           -- one game alone (also SonnetRain, SonnetPassword,
##                                            SonnetGlaze, SonnetSquad)
## Sonnet.Open returns empty, or why it could not.
######################################################################################

constant kProjects = "//wsl$/Ubuntu/home/igame3d/projects"
constant kCardsRel = "LIB_LLMOUT/Sonnet/cards"
constant kGameLaunchRel = "LIB_DEV/livecode/game_launch.livecodescript"
constant kEngineRel = "xt3D_Raylib_Livecode_Bridge/testbench/vibe_engine_xt3d.livecodescript"
constant kPlayerRel = "LIB_DEV/livecode/game_player.livecodescript"

function Sonnet.Projects
   local tPath
   put the effective filename of stack "SonnetLauncher" into tPath
   replace "\" with "/" in tPath
   set the itemDel to "/"
   repeat while the number of items of tPath > 1
      delete item -1 of tPath
      if there is a folder (tPath & "/LIB_LLMOUT") then return tPath
   end repeat
   return kProjects
end Sonnet.Projects

function Sonnet.Open pName, pTitleWho
   local tP, tFile, tScript, tStack, tPlayer, tEngine, tErr
   put Sonnet.Projects() into tP
   if pTitleWho is empty then put "FOR OWNER" into pTitleWho
   -- the shared helpers (GL.ReadText, GL.WindowRect, GL.GameNotes) come from the Game_Player's library
   try
      if not ("GameLaunch" is among the lines of the stacksInUse) then start using stack (tP & "/" & kGameLaunchRel)
   catch tErr
      return "GameLaunch did not load:" && tErr
   end try
   put tP & "/" & kCardsRel & "/Vibecode3D_Play_" & pName & ".livecodescript" into tFile
   put GL.ReadText(tFile) into tScript
   if tScript is empty then return "No card script:" && tFile
   put tP & "/" & kEngineRel into tEngine
   if there is not a file tEngine then return "No engine library:" && tEngine
   put GL.ReadText(tP & "/" & kPlayerRel) into tPlayer
   if tPlayer is empty then return "No player script:" && kPlayerRel
   try
      if not ("VibeEngineXt3d" is among the lines of the stacksInUse) then start using stack tEngine
   catch tErr
      return "The engine library did not load:" && tErr
   end try
   GL.GameNotes tP
   put "Play" && pName into tStack
   if there is a stack tStack then close stack tStack
   lock messages
   create invisible stack tStack
   unlock messages
   set the defaultStack to tStack
   set the script of stack tStack to tPlayer
   if the result is not empty then
      put the result into tErr
      delete stack tStack
      return "The player script does not compile:" && tErr
   end if
   set the name of card 1 of stack tStack to "Play." & pName
   set the script of card 1 of stack tStack to tScript
   if the result is not empty then
      put the result into tErr
      delete stack tStack
      return pName && "does not compile:" && tErr
   end if
   set the uGame of stack tStack to pName
   set the uScriptFile of stack tStack to tFile
   set the uPrefix of stack tStack to empty
   set the uLevels of stack tStack to 0
   set the uQuitOnClose of stack tStack to false
   set the backgroundColor of stack tStack to "0,0,0"
   set the resizable of stack tStack to false
   set the destroyStack of stack tStack to true
   set the title of stack tStack to pTitleWho && "|" && pName && "| Escape pauses, M is the menu"
   set the rect of stack tStack to GL.WindowRect()
   try
      show stack tStack
      go stack tStack
   catch tErr
      return "The window did not open:" && line 1 of tErr
   end try
   send "Player.Start" to stack tStack in 50 milliseconds
   return empty
end Sonnet.Open
