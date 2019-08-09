-- XMonad-Aloysius xmonad layouts

module Container.Layout where


-- Imports ----------------------------------------------------------------------
import XMonad
import XMonad.Hooks.ManageDocks

import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.IfMax
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

import Config.Projects
import Theme.Nord
------------------------------------------------------------------------
--
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
data Gaps' = Gaps'
  { u  :: Int
  , d  :: Int
  , x  :: Int
  , x' :: Integer
  }

gs :: Gaps'
gs = Gaps'
  { u  = 20
  , d  = 20
  , x  = 20
  , x' = 20
  }


tabTheme :: XMonad.Layout.Tabbed.Theme
tabTheme = def { activeColor = basebg
               , activeBorderColor = basebg
               , activeTextColor = base06
               , inactiveColor = basebg
               , inactiveBorderColor = basebg
               , inactiveTextColor = base03
               , urgentColor = basebg
               , urgentBorderColor = basebg
               , urgentTextColor = base12
               , fontName = "xft:Fira Sans:pixelsize=14"
               , decoHeight = 52
               }


gapses :: l a -> ModifiedLayout Gaps l a
gapses     = gaps [(U, u gs), (R, x gs), (L, x gs), (D, d gs)]

spacingses :: l a -> ModifiedLayout Spacing l a
spacingses = spacingRaw True (Border      0  (x' gs) (x' gs) (x' gs))
                        True (Border (x' gs) (x' gs) (x' gs) (x' gs))
                        True

-- customised layouts
full             = noBorders (fullscreenFull Full)

spacedPartitions = IfMax 1 full
                 $ gapses
                 . spacingses
                 $ emptyBSP
                 ||| ResizableTall 1 (2/100) (1/2) []

tcm              = IfMax 1 full
                 $ gapses
                 . spacingses
                 $ ThreeColMid 1 (1/10) (1/2)

-- layout --
layout           = avoidStruts
                 . smartBorders
                 . onWorkspace wsScratch simplestFloat
                 $ full
                 ||| spacedPartitions
                 ||| tcm
                 ||| tabbedBottom shrinkText tabTheme
