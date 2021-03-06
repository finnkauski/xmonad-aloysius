-- | XMonad-Aloysius eventLog for polybar
-- | From: https://github.com/polybar/polybar/wiki/User-contributed-module

module Bus.LogHook
  ( logHooker
  )
where

import           Control.Monad                  ( forM_ )

import           XMonad
import qualified XMonad.StackSet               as W

import           Theme.ChosenTheme


-- Useful information for formatting
  -- %{T3} changes font to bold in polybar
  -- %{T-} resets it back to font-0
  -- this module then depends on +THEME+


-- have a look at https://hackage.haskell.org/package/xmonad-contrib-0.16/docs/XMonad-Util-Loggers.html
-- to see if we can use this for our own logging info



-- could this also support a pop up panel?
-- https://hackage.haskell.org/package/xmonad-contrib-0.16/docs/XMonad-Util-Loggers-NamedScratchpad.html


-- Supporting functions --------------------------------------------------------
mkLayoutStr :: String -> String -> String -> String
mkLayoutStr colour logo rep =
  concat ["%{T2}%{F", colour, "} ", logo, "%{T-}%{F", basefg, "} ", rep]


layoutParse :: String -> String
layoutParse s | s == "Three Columns"    = mkLayoutStr base13 "+|+" "TCM "
              | s == "Binary Partition" = mkLayoutStr base13 "||+" "BSP "
              | s == "Tall"             = mkLayoutStr base13 "|||" "Tall"
              | s == "Tabbed"           = mkLayoutStr base13 "___" "Tab "
              | s == "Float"            = mkLayoutStr base13 "+++" "FLT "
              | s == "Fullscreen"       = mkLayoutStr base13 "| |" "Full"
              | otherwise               = s -- fallback for changes in C.Layout


write :: (String, String) -> X ()
write (x, y) = io $ appendFile x y


fmt :: String -> String
fmt = mkLayoutStr base11 "\xf041"  -- map location marker


-- Hook ------------------------------------------------------------------------
logHooker :: X ()
logHooker = do
  -- FIXME: can this be less onerous?
  winset <- gets windowset

  -- workspaces
  let currWs = W.currentTag winset
  -- blocking named scratchpad appearing
  -- let wss = filter (/= "NSP") $ W.tag <$> W.workspaces winset
  let wsStr  = fmt currWs
  -- annoyingly for some themes it changes the colour of the initial string
  -- write another function which takes a workspace string and another
  -- string containing the desktop of the window seeking focus and then adjusts
  -- that string with the urgent notice and then a removal function as well

  -- layout
  let ltStr =
        layoutParse . description . W.layout . W.workspace . W.current $ winset

  -- pushing logs to pipes, note all files are FIFO specials
  -- done this way to 'future-proof' against any stupid ideas I have
  forM_
    [ ("/tmp/xmonad-wspace", wsStr ++ "\n")
    , ("/tmp/xmonad-layout", ltStr ++ "\n")
    ]
    write
