-- | Personal 'programs as functions' list
-- This is here so that I can change the programs behind things without worry
-- about propogating all the changes. All functions external to haskell should
-- be specified here.

module App.Alias where


audioSink :: String
audioSink =
  "pactl set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo-extra2"

gnomeSession :: String
gnomeSession = "gnome-session --disable-acceleration-check -f &"

panel :: String
panel = "~/.scripts/polybar/launch"

wallpaper :: String
wallpaper = "~/.fehbg"

compositor :: String
compositor = "systemctl --user start compton"

cursor :: String
cursor = "xsetroot -cursor_name left_ptr &"

lang :: String
lang = "export LANG=en_GB.UTF-8"

numlock :: String
numlock = "numlockx"

screensaver :: String
screensaver = "~/.scripts/lock"

suspend :: String
suspend = "~/.scripts/suspend"

energyStar :: String
energyStar = "echo '%{F#eceff4}\xf0eb%{F-}\n' > /tmp/caffeine"

xresource :: String
xresource =
  "[[ -f ~/.Xresources ]] && nohup xrdb -merge -I$HOME ~/.Xresources >/dev/null"

tty :: String
tty = "kitty"

scratch :: String
scratch = "kitty --name=scratchpad"

mail :: String
mail = "geary"

music :: String
music = "spotify"

code :: String
code = "emacs"

browser :: String
browser = "firefox"

keybase :: String
keybase = "keybase-gui"

touchEvents :: String
touchEvents = "echo \"\xf111\" > /tmp/xmonad-events"
