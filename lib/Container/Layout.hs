-- XMonad-Aloysius xmonad layouts

module Container.Layout where


-- Imports ----------------------------------------------------------------------
import XMonad
import XMonad.Hooks.ManageDocks

import XMonad.Layout.ResizableTile
import XMonad.Layout.Fullscreen
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders


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
  { u  = 44
  , d  = 20
  , x  = 20
  , x' = 20
  }


gapses     = gaps [(U, u gs), (R, x gs), (L, x gs), (D, d gs)]
spacingses = spacingRaw True (Border      0  (x' gs) (x' gs) (x' gs))
                        True (Border (x' gs) (x' gs) (x' gs) (x' gs))
                        True

-- customised layouts
full             = noBorders (fullscreenFull Full)
spacedPartitions = gapses
                 $ spacingses
                 $ (emptyBSP ||| ResizableTall 1 (2/100) (1/2) [])

-- layout --
layout = avoidStruts
       $ smartBorders
       $ full
     ||| spacedPartitions
