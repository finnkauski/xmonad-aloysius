-- | XMonad-Aloysius setup

module Config.Options where

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.CopyWindow
import XMonad.Layout.WindowNavigation
import XMonad.Actions.WindowNavigation
import XMonad.Layout.Combo
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Actions.FloatKeys
import XMonad.Util.Replace
import XMonad.Layout.LayoutScreens
import XMonad.Layout.Grid
import XMonad.Layout.TwoPane
import XMonad.Layout.Master
import XMonad.Layout.Dishes
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Column
import XMonad.Actions.UpdatePointer
import XMonad.Actions.Submap
import XMonad.Actions.ShowText
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Layout.LayoutCombinators hiding ( (|||) )
import XMonad.Layout.AvoidFloats
import System.IO (hClose, hFlush, Handle)
import Data.Maybe (fromMaybe, fromJust)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- import Theme.Dracula
import App.Alias
import Theme.Nord

-- personal preferences for use
data Options = Options
  { term   :: String
  , ffm    :: Bool
  , mask   :: KeyMask
  , spaces :: [String]
  , events :: Event  -> X All
  , logs   :: X ()
  , starts :: X ()
  }

options = Options
  { term   = "urxvt"
  , ffm    = True
  , mask   = mod4Mask
  , spaces = map show [1..6]
  , events = ewmhDesktopsEventHook
  , logs   = updatePointer (0.5, 0.5) (0, 0)
           >> takeTopFocus
           -- TODO: figure out a better way to do this.
           >> spawn logger
  , starts = ewmhDesktopsStartup
             >> setWMName "XMonad"
             -- apps from alias
             >> spawnOnce panel
             >> spawnOnce wallpaper
             >> spawnOnce compositor
             >> spawnOnce cursor
             >> spawnOnce lang
             >> spawnOnce notifications
             >> spawnOnce xresource
             <+> docksStartupHook
             -- return ()
  }

