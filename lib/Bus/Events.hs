-- | XMonad-Aloysius eventLog for polybar
-- | From: https://github.com/polybar/polybar/wiki/User-contributed-module

module Bus.Events where

import Data.List (sortBy, isInfixOf)
import Data.Function (on)
import Control.Monad (join)

import XMonad
import qualified XMonad.StackSet as W

import Theme.Nord


logHook' :: X ()
logHook' = do
  -- curLayout <- gets (description . W.layout . W.workspace . W.current $ windowset)
  -- curSpaces <- gets (description . W.workspaces . W.currentTag $ windowset)
  winset <- gets windowset

  -- workspaces
  let currWs = W.currentTag winset
  -- blocking named scratchpad appearing
  let wss = filter (/= "NSP") $ map W.tag $ W.workspaces winset
  let wsStr = join $ map (fmt currWs) $ sort' wss

  -- layout
  let currLt = description . W.layout . W.workspace . W.current $ winset
  let ltStr  = layoutParse currLt

  -- fifo
  io $ appendFile "/tmp/xmonad-ws"     (wsStr ++ "\n")
  io $ appendFile "/tmp/xmonad-layout" (ltStr ++ "\n")
  where
    fmt currWs ws
      -- %{T3} changes font to bold in polybar
      -- %{T-} resets it back to font-0
      -- NOTE: Foreground colours also edited here
      -- this block then depends on +THEME+
      | currWs == ws = " %{F"  ++ base00 ++ "}%{T3}[" ++ ws ++ "]%{T-}%{F-} "
      | otherwise    = "  %{F" ++ base10 ++ "}%{T4}"  ++ ws ++ "%{T-}%{F-}  "

    sort' = sortBy (compare `on` (!! 0))
    layoutParse s  -- 'pretty' printing
      | "ThreeCol"      `isInfixOf` s = "%{T2}+|+%{T-} TCM "
      | "BSP"           `isInfixOf` s = "%{T2}||+%{T-} BSP "
      | "ResizableTall" `isInfixOf` s = "%{T2}|||%{T-} Tall"
      | s == "Full"                   = "%{T2}___%{T-} Full"
      | s == "SimplestFloat"          = "%{T2}+++%{T-} FLT "
      | otherwise                     = s -- fallback for changes in C.Layout
