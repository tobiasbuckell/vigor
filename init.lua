-- http://www.tobiasbuckell.com
-- VIGOR: one fiction writer's variation on Vim/eMacs style modal bindings
-- QWERTY EDITION

-- Project to do list:
-- * I need persistent banner alert in upper or lower part of screen saying 
-- you're in editing mode, the different color isn't enough, I keep 
-- forgetting I'm in the mode. 
-- * Delete by line would really be more useful if it was by sentence 
-- * How do I turn off trackpad. Right now, I can do it by hitting option 
-- five times in a row manually, but I can't quite get that working in Lua 
-- as an automatic triggered code when I go into editing mode. 
-- * hitting j and k at the same time to engage the editing mode, I cannot seem
-- to figure this out. It would be great. And hitting j and k together again to
-- come out of it would be better, as those are my strongest fingers.
-- * hitting caps lock again to turn off the mode would be dope, my fingers 
-- keep trying to do that, so maybe I shouldn't fight it.
-- *it would be really nice to tap shift or double tap it and then not have to
-- hold it down while selecting with the right hand keys.

--------------------------------------------------------------------------------
-- SPEED UP KEYSTRIKES
--------------------------------------------------------------------------------
-- I noticed that my preferred rapid repeating keys and fast keystrokes were 
-- gone when I installed these keybindings on hammerspoon. This code came from 
-- https://stackoverflow.com/questions/40986242/key-repeats-are-delayed-in-my-hammerspoon-script 
-- to put speed back in the letters popping up, I think it made a difference:

local fastKeyStroke = function(modifiers, character)
  local event = require("hs.eventtap").event
  event.newKeyEvent(modifiers, string.lower(character), true):post()
  event.newKeyEvent(modifiers, string.lower(character), false):post()
end

--------------------------------------------------------------------------------
-- DIM SCREEN WHEN EDITING MODE INVOKED
--------------------------------------------------------------------------------
-- Loads a function to let us dim the screen to indicate we've shifted modes

local ScreenDimmer = {}

function ScreenDimmer.dimScreen()
-- I snagged this code from (https://github.com/dbalatero/VimMode.spoon) 
-- these shifts from flux-like plugin at https://github.com/calvinwyoung/.dotfiles/blob/master/darwin/hammerspoon/flux.lua

  local whiteShift = {
    alpha = 1.0,
    red = 1.0,
    green = 0.95201559,
    blue = 0.90658983,
  }

  local blackShift = {
    alpha = 1.0,
    red = 0,
    green = 0,
    blue = 0,
  }

  hs.screen.primaryScreen():setGamma(whiteShift, blackShift)
end

function ScreenDimmer.restoreScreen()
  hs.screen.restoreGamma()
end

-- return ScreenDimmer --the original code that I snagged from Vimmode 
-- (https://github.com/dbalatero/VimMode.spoon) has this, but my Hammerspoon 
-- init load configuration complained.

--------------------------------------------------------------------------------
-- CODE TO INVOKE EDITING MODE
--------------------------------------------------------------------------------

-- this is a 'mode' or 'layer' for keybindings that allow us to do things other
-- than type with the keyboard. Keybindings are also known as 'shortcuts' like
-- "CONTROL + C" to copy text that's highlighted.

local normal = hs.hotkey.modal.new()

-- f18 - here we use the key f18 to enter Normal mode. 'Normal mode' is what 
-- VIM, a unix text editor, calls the new keyboard shortcuts for a certain 
-- collection of actions. The f18 key is triggered by capslock through 
-- downloading Karabiner Elements and using it to map capslock to f18.

enterNormal = hs.hotkey.bind({""}, "f18", function()
    normal:enter()
    ScreenDimmer.dimScreen()
    hs.alert.show('EDITING MODE')
end)

--------------------------------------------------------------------------------
-- CHARACTER, WORD, and LINE MOVEMENTS
--------------------------------------------------------------------------------
-- note: these keybindings are all for a COLEMAK-DH layout keyboard, not a
-- QWERTY layout.


-- h  - move left a character
function left() hs.eventtap.keyStroke({alt}, "Left") end
normal:bind({}, 'h', left, nil, left) 

-- this "left, nil, left" got in there from previous code and it works with it 
-- in there but I'm not sure what it is, maybe a better programmer than I could
-- map all this out, I'm not a programmer, just someone who wanted to see 
-- this happen.

-- ; - move right a character
function right() hs.eventtap.keyStroke({alt}, "Right") end
normal:bind({}, ';', right, nil, right)

-- i - move up 
function up() hs.eventtap.keyStroke({}, "Up") end
normal:bind({}, 'i', up, nil, up)

-- k - move down 
function down() hs.eventtap.keyStroke({}, "Down") end
normal:bind({}, 'k', down, nil, down)

-- l  - move right to next word 
function word() hs.eventtap.keyStroke({"alt"}, "Right") end
normal:bind({}, 'l', word, nil, word)

-- j  - move to previous word 
function back() hs.eventtap.keyStroke({"alt"}, "Left") end
normal:bind({}, 'j', back, nil, back)

-- u - move to beginning of line 
normal:bind({}, 'u', function()
    hs.eventtap.keyStroke({"ctrl"}, "Left")
end)

-- o - move to end of line 
normal:bind({""}, 'o', function()
    hs.eventtap.keyStroke({"ctrl"}, "Right")
end)

-- m - move to start of paragraph 
normal:bind({""}, 'm', function()
    hs.eventtap.keyStroke({"option"}, "Up")
end)

-- , - move to end of paragraph 
normal:bind({""}, ',', function()
    hs.eventtap.keyStroke({"option"}, "Down")
end)

--------------------------------------------------------------------------------
-- MOVEMENT WITH SHIFT TO SELECT
--------------------------------------------------------------------------------

-- shift + l - select right to next word
normal:bind({"shift"}, 'u', function()
    hs.eventtap.keyStroke({"option", "shift"}, "Right")
end)

-- shift + j - select left to next word
normal:bind({"shift"}, 'j', function()
    hs.eventtap.keyStroke({"option", "shift"}, "Left")
end)

-- shift + k - select downwards
function down() hs.eventtap.keyStroke({"shift"}, "Down") end
normal:bind({"shift"}, 'k', down, nil, down)

-- shift + i - select upwards
function up() hs.eventtap.keyStroke({"shift"}, "Up") end
normal:bind({"shift"}, 'i', up, nil, up)

-- shift + h  - move left a character 
function left() hs.eventtap.keyStroke({"shift"}, "Left") end
normal:bind({"shift"}, 'h', left, nil, left)

-- shift + ; - move right a character 
function right() hs.eventtap.keyStroke({"shift"}, "Right") end
normal:bind({"shift"}, ';', right, nil, right)

-- shift + u - move to beginning of line 
normal:bind({"shift"}, 'u', function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "Left")
end)

-- shift + o - move to end of line 
normal:bind({"shift"}, 'o', function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "Right")
end)

-- shift + m - move to start of paragraph 
normal:bind({"shift"}, 'm', function()
    hs.eventtap.keyStroke({"option", "shift"}, "Up")
end)

-- shift + , - move to end of paragraph 
normal:bind({"shift"}, ',', function()
    hs.eventtap.keyStroke({"option", "shift"}, "Down")
end)

--------------------------------------------------------------------------------
-- JUMP TO END, BEGINNING, PG UP & DOWN MOVEMENTS 
--------------------------------------------------------------------------------

-- shift + 8 - move to beginning of text 
normal:bind({"shift"}, '8', function()
    hs.eventtap.keyStroke({"cmd"}, "Up")
end)

-- shift + space - move to end of text 
normal:bind({"shift"}, 'space', function()
    hs.eventtap.keyStroke({"cmd"}, "Down")
end)

-- 8 - scroll up a page 
normal:bind({""}, '8', function()
    hs.eventtap.keyStroke({""}, "pageup")
end)

-- 9 - scroll up a page 
normal:bind({""}, '9', function()
    hs.eventtap.keyStroke({""}, "pageup")
end)

-- space - scroll down a page 
normal:bind({""}, 'space', function()
    hs.eventtap.keyStroke({""}, "pagedown")
end)

--------------------------------------------------------------------------------
-- TURN OFF ACCIDENTAL KEYSTRIKES
--------------------------------------------------------------------------------
-- I would like to add in a way for keys that aren't bound to my custom combos 
-- here to be ignored, haven't figured out how to do that yet.


--------------------------------------------------------------------------------
-- LEAVING EDITING MODE & ALSO DETERMINING WHERE THE CURSOR IS PLACED
--------------------------------------------------------------------------------

-- hit return - insert at cursor 
normal:bind({}, 'return', function()
    normal:exit()
    hs.alert.show('Exiting edit mode')
    ScreenDimmer.restoreScreen()
end)

-- shift + return - insert at start of line 
normal:bind({"shift"}, 'return', function()
    hs.eventtap.keyStroke({"cmd"}, "Left")
    normal:exit()
    hs.alert.show('Exiting edit mode to start of line')
    ScreenDimmer.restoreScreen()
end)

-- command + return - insert at end of line 
normal:bind({"cmd"}, 'return', function()
    hs.eventtap.keyStroke({"cmd"}, "Right")
    normal:exit()
    hs.alert.show('Exiting edit mode to end of line')
    ScreenDimmer.restoreScreen()    
end)


--------------------------------------------------------------------------------
-- DELETIONS
--------------------------------------------------------------------------------

-- d - select back a word, copy, then delete it
normal:bind({""}, 'd', function()
    hs.eventtap.keyStroke({"option", "shift"}, "Left")
    hs.eventtap.keyStroke({"command"}, "c")  
    hs.eventtap.keyStroke({""}, "delete")          
end)

-- f - select right to next word, copy, then delete it
normal:bind({""}, 'f', function()
    hs.eventtap.keyStroke({"option", "shift"}, "Right")
    hs.eventtap.keyStroke({"command"}, "c")  
    hs.eventtap.keyStroke({""}, "delete")          
end)

-- shift + d - select back a character and delete
normal:bind({"shift"}, 'd', function()
    hs.eventtap.keyStroke({""}, "delete")    
end)

-- shift + f - select forward a character and delete
normal:bind({"shift"}, 'f', function()
    hs.eventtap.keyStroke({""}, "forwarddelete")    
end)

-- a - select back a paragraph, copy, and delete
normal:bind({""}, 'a', function()
    hs.eventtap.keyStroke({"option", "shift"}, "Up")
    hs.eventtap.keyStroke({"command"}, "c")  
    hs.eventtap.keyStroke({""}, "delete")        
end)

-- shift + s - select forward a paragraph, copy, and delete
normal:bind({"shift"}, 's', function()
    hs.eventtap.keyStroke({"ctrl", "shift"}, "Right")
    hs.eventtap.keyStroke({"command"}, "c")  
    hs.eventtap.keyStroke({""}, "delete")         
end)


-- shift + a - select back a paragraph, copy, and delete
normal:bind({"shift"}, 'a', function()
    hs.eventtap.keyStroke({"ctrl" , "shift"}, "Left")
    hs.eventtap.keyStroke({"command"}, "c")  
    hs.eventtap.keyStroke({""}, "delete")        
end)

-- s - select forward a paragraph, copy, and delete
normal:bind({""}, 's', function()
    hs.eventtap.keyStroke({"option", "shift"}, "Down")
    hs.eventtap.keyStroke({"command"}, "c")  
    hs.eventtap.keyStroke({""}, "delete")         
end)


--------------------------------------------------------------------------------
-- DELETIONS, COPY, PASTE
--------------------------------------------------------------------------------

-- z - undo 
normal:bind({""}, 'z', function()
    hs.eventtap.keyStroke({"command"}, "z")
end)

-- <c-r> - redo 
normal:bind({"command"}, 'r', function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "z")
end)

-- c - yank (copy) 
normal:bind({}, 'c', function()
    hs.eventtap.keyStroke({"cmd"}, "c")
end)

-- v - paste 
normal:bind({}, 'v', function()
    hs.eventtap.keyStroke({"cmd"}, "v")
end)

-- I have some variations to the pasting because I use CopyClip 2 for a 
-- pasteboard. Cmd shift V is usually what we use for a clipboard history app, 
-- so I'm keeping that.

-- r - paste 
normal:bind({}, 'r', function()
    hs.eventtap.keyStroke({"cmd" , "shift"}, "v")
end)

--------------------------------------------------------------------------------
-- FILTER OUT PROGRAMS YOU DON'T WANT THIS LAYER IN:
--------------------------------------------------------------------------------

hs.window.filter.new('Terminal')-- 
    :subscribe(hs.window.filter.windowFocused,function()
        normal:exit()
        enterNormal:disable()
    end)
    :subscribe(hs.window.filter.windowUnfocused,function()
        enterNormal:enable()
    end)
    
--------------------------------------------------------------------------------
-- Watcher/autoreloader for changes of init.lua
--------------------------------------------------------------------------------

    function reloadConfig(files)
      doReload = false
      for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
          doReload = true
        end
      end
      if doReload then
        hs.reload()
      end
    end

    local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
    hs.alert("Hammerspoon config reloaded")
    
--------------------------------------------------------------------------------
-- experiments
--------------------------------------------------------------------------------

-- Window Management
-- (to come)
