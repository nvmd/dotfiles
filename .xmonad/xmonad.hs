import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.ManageDocks
import XMonad.Actions.CopyWindow -- for kill1

-- main = do
--	xmonad $ defaultConfig
--		{ terminal = "urxvt"
--		}

-- The main function.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myManageHook = composeAll . concat $
           [[ className =? "Skype" --> doFloat ]
-- Float Firefox dialog windows
           ,[ (className =? "Firefox" <&&> resource =? "Dialog") --> doFloat ]
           ]

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">"
                , ppSep = " | "
                , ppTitle = xmobarColor "green" "" . shorten 85
                }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

terminalCmd = "urxvt"
dmenuRunCmd = "cmd=$(yeganesh --executables -- -b -f -i -p \"$ \") && exec $cmd"

-- Main configuration
--myConfig = defaultConfig { modMask = mod4Mask }
myConfig = defaultConfig {
             terminal = terminalCmd
--           , layoutHook = avoidStruts $ layoutHook defaultConfig
           , manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
           } `additionalKeys`
           [ ((mod4Mask, xK_l), spawn "xscreensaver-command -lock")
           , ((mod1Mask, xK_p), spawn dmenuRunCmd) -- overriding default command
--         , ((mod4Mask, xK_r), spawn dmenuRunCmd) -- additional, windows-like
--           , ((mod1Mask .|. shiftMask, xK_c), kill1) -- close the focused window
           ]

