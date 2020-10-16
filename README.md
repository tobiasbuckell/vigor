# VIGOR
*a VIM-like keybinding system in Lua code for Hammerspoon with Colemak-DH keyboard layout*

## How to use:

Download the following two free apps:

1) Karabiner-Elements: https://karabiner-elements.pqrs.org
2) Hammerspoon: https://www.hammerspoon.org

When you install Karabiner and Hammerspoon they will ask for access to your
accessibility features of OS-X. Approve them.

Go to OS-X System Preferences, then Keyboard, and then click on the tab that
says 'modifier keys.' There you can turn off the CAPS LOCK key. Set it to
'do nothing.'

In Karabiner go to the tab that says "Simple Modifications" and choose
CAPS LOCK and set to trigger f18. This disables CAPS and makes it more
useful to us.

Now start up Hammerspoon. There will be a small hammer in the upper right hand
corner, in the menu bar. Choose 'open config' and paste the code from the
file called 'init.lua' here. Save it, then choose 'reload config' from the
Hammerspoon menu icon.

Now hitting CAPS LOCK puts you into 'editing mode' and 'enter' pops you back.

Alternatively, you can navigate to your user directory (/username) where your
documents folder and what not are. Hold down cmd + shift + . and OS-X hidden
files will appear. Look for ./hammerspoon and find the init.lua file to open
in a text editor of your choice.

Enjoy!

Please remember, this uses a custom keyboard layout that isn't QWERTY, it uses
a COLEMAK-DH mod layout right now until further development to either
add an easy switch to QWERTY or the project gets forked. For now, you would need
to remap your own keys from these keys:

![COLEMAK-DH](https://github.com/tobiasbuckell/vigor/blob/main/colemak%20cheatsheet.png)
