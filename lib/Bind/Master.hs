-- |

module Bind.Master where

import           System.Exit

import           XMonad
import           XMonad.Actions.CopyWindow      ( kill1 )
import           XMonad.Actions.WindowBringer
import           XMonad.Actions.WithAll
import           XMonad.Hooks.ManageDocks       ( ToggleStruts(..) )

import           XMonad.Layout.AvoidFloats

import           XMonad.Prompt.XMonad

import           XMonad.Util.Scratchpad
import           XMonad.Util.Ungrab

import qualified Data.Map                      as M
import qualified XMonad.Actions.FlexibleManipulate
                                               as F
import qualified XMonad.Actions.Search         as S
import qualified XMonad.StackSet               as W

-- local
import           App.Alias
import           App.Launcher
import           Bind.Util  -- replaces EZConfig, adds <S>
import           Config.Options
import           Theme.ChosenTheme


-- Keymaps ----------------------------------------------------------------------

-- TODO: investigate minimize:
-- https://hackage.haskell.org/package/xmonad-contrib-0.16/docs/XMonad-Actions-Minimize.html
-- not interested in maximise

-- see about windowmenu
-- https://hackage.haskell.org/package/xmonad-contrib-0.16/docs/XMonad-Actions-WindowMenu.html




-- @start keys
defaultKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
defaultKeys c =
  mkKeymap c
    $  [ -- GENERAL --
         ("<S> <Return>", spawn (term options))
       , ("<S> <Space>" , sendMessage NextLayout)
       , ("<S> <Tab>"   , windows W.focusDown)
       , ("<S> S-<Tab>" , windows W.focusUp)
       , ("<S> p"       , spawn appLauncher)
       , ( "<S> `"      , scratchpadSpawnActionCustom scratch)
         -- APPLICATIONS --
       , ("<S> a q", kill1)
       , ("<S> a f", spawn browser)
       , ( "<S> a e", spawn code)
         -- WINDOWS --
       , ("<S> w g", gotoMenuArgs $ dmenuTheme base10 "Go to window:  ")
       , ("<S> w b", bringMenuArgs $ dmenuTheme base15 "Bring window:  ")
       , ("<S> w h"      , sendMessage Shrink)
       , ("<S> w l"      , sendMessage Expand)
       , ("<S> w ."      , sendMessage $ IncMasterN 1)
       , ("<S> w ,"      , sendMessage $ IncMasterN (-1))
       , ("<S> w m"      , windows W.focusMaster)
       , ("<S> w <Left>" , windows $ W.swapUp . W.focusUp)
       , ("<S> w <Right>", windows $ W.swapDown . W.focusDown)
       , ("<S> w s"      , withFocused $ windows . W.sink)
       , ("<S> w S"      , sinkAll)
       , ("<S> w f"      , sendMessage AvoidFloatToggle)
       , ( "<S> w t"     , sendMessage ToggleStruts)
         -- SESSION --
       , ("<S> q l", spawn screensaver)
       , ("<S> q r", broadcastMessage ReleaseResources >> restart "xmonad" True)
       , ("<S> q q", io exitSuccess)
       , ( "<S> q m", unGrab >> powerMenu)
         -- SEARCHING --
       , ( "<S> / /", xmonadPromptC actions promptConfig)
       -- TODO: replace this ^, with X.A.Commands
       -- https://hackage.haskell.org/package/xmonad-contrib-0.16/docs/XMonad-Actions-Commands.html
         -- MEDIA --
       , ("<XF86AudioPlay>"       , spawn "playerctl play-pause")
       , ("<XF86AudioStop>"       , spawn "playerctl stop")
       , ("<XF86AudioNext>"       , spawn "playerctl next")
       , ("<XF86AudioPrev>"       , spawn "playerctl previous")
       , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume 0 -5%")
       , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume 0 +5%")
       , ("<XF86AudioMute>"       , spawn "pactl set-sink-mute 0 toggle")
       ]
    ++
         -- SEARCHES --
       [ ("<S> / s " ++ k, S.selectSearch f) | (k, f) <- searchList ]
    ++ [ ("<S> / p " ++ k, S.promptSearch promptConfig f)
       | (k, f) <- searchList
       ]
    ++
         -- NAVIGATION
       [ (m ++ k, windows $ f w)
       | (w, k) <- zip (XMonad.workspaces c) (spaces options)
       , (m, f) <- [("<S> ", W.greedyView), ("<S> S-", W.shift)]
       ]
-- @end keys

-- Menu for less common actions or those without media keys
actions :: [(String, X ())]
actions =
  [ ("inc-win", sendMessage (IncMasterN 1))
  , ("dec-win", sendMessage (IncMasterN (-1)))
  , ("struts" , sendMessage ToggleStruts)
  , ("lock"   , spawn screensaver)
  , ("kill"   , kill1)
  , ("mplay"  , spawn "playerctl play-pause")
  , ("mpause" , spawn "playerctl play-pause")
  , ("mstop"  , spawn "playerctl stop")
  , ("mnext"  , spawn "playerctl next")
  , ("mprev"  , spawn "playerctl previous")
  , ("mdown"  , spawn "pactl set-sink-volume 0 -5%")
  , ("mup"    , spawn "pactl set-sink-volume 0 +5%")
  , ("mmute", spawn "pactl set-sink-mute 0 toggle")
  ]


-- search engine submap
searchList :: [(String, S.SearchEngine)]
searchList = [("g", S.duckduckgo), ("h", S.hoogle), ("w", S.wikipedia)]


-- Non-numeric num pad keys, sorted by number
numPadKeys :: [KeySym]
numPadKeys =
  [ xK_KP_End
  , xK_KP_Down
  , xK_KP_Page_Down -- 1, 2, 3
  , xK_KP_Left
  , xK_KP_Begin
  , xK_KP_Right     -- 4, 5, 6
  , xK_KP_Home
  , xK_KP_Up
  , xK_KP_Page_Up   -- 7, 8, 9
  , xK_KP_Insert
  ]


------------------------------------------------------------------------

-- Mouse bindings: default actions bound to mouse events
mouseBindings' :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ())
mouseBindings' XConfig { XMonad.modMask = modm } = M.fromList
    -- mod-button1, flexible linear scale
  [ ( (modm, button1)
    , \w -> focus w >> F.mouseWindow F.discrete w
    )
    -- mod-button4, Raise the window to the top of the stack
  , ( (modm, button4)
    , \w -> focus w >> windows W.shiftMaster
    )
    -- mod-button3, Set the window to floating mode and resize by dragging
  , ( (modm, button3)
    , \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster
    )
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    -- and middle click (button3)
  ]
