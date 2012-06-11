import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig(additionalKeys)

-- main = do
--	xmonad $ defaultConfig
--		{ terminal = "urxvt"
--		}

-- The main function.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

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
dmenuRunCmd = "dmenu_run -b -f -i -p \"$ \""

-- Main configuration
--myConfig = defaultConfig { modMask = mod4Mask }
myConfig = defaultConfig { terminal = terminalCmd }
           `additionalKeys`
           [ ((mod4Mask, xK_l), spawn "xscreensaver-command -lock")
           , ((mod1Mask, xK_p), spawn dmenuRunCmd) -- overriding default command
--         , ((mod4Mask, xK_r), spawn dmenuRunCmd) ] -- additional, windows-like
           ]

