import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.ManageDocks
import XMonad.Util.WorkspaceCompare	-- for getSortByXineramaRule
import XMonad.Hooks.SetWMName
import XMonad.Layout.SimpleFloat
import XMonad.Hooks.FloatNext
import XMonad.Hooks.Place
import XMonad.Hooks.ICCCMFocus	-- issue #177 workaround. works only for JDK6...
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.FloatKeys

-- emacs-like shortcuts experiments
import XMonad.Actions.Submap
import qualified Control.Arrow as A
import Data.Bits
import qualified Data.Map as M

-- main = do
--	xmonad $ defaultConfig
--		{ terminal = "urxvt"
--		}

-- The main function.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myManageHook = composeAll . concat $ -- see also: composeOne
-- To find the property name associated with a program, use
-- xprop | grep WM_CLASS
-- and click on the client you're interested in.
-- xprop | grep WM_CLASS: WM_CLASS(STRING) = <resource>, <class>
           [[ isDialog --> doFloat ]
           ,[ className =? "Skype" --> doFloat ]
           ,[ className =? "Xmessage" --> doFloat ]
--           ,[ className =? "Nm-connection-editor" --> doFloat ]
-- just to prevent it from being moved by placeHook
--           ,[ resource =? "sun-awt-X11-XDialogPeer" --> doFloat ]
           ,[ resource =? "xfce4-notifyd" --> doFloat ]
           ,[(className =? "Firefox" <&&> resource =? "Browser") --> doFloat]
           ,[(className =? "Firefox" <&&> resource =? "Download") --> doFloat]
           ,[ title =? "Firefox Preferences" -->doFloat ]
-- Float Firefox dialog windows
--           ,[(className =? "Firefox" <&&> resource =? "Dialog") --> doFloat ]
           ]

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, determines what is being written to the bar.
--currentWorkspaceColor = "#429942"
currentWorkspaceColor = "#FF0000"	-- red
--visibleWorkspaceColor = "#00AAFF"
visibleWorkspaceColor = "#1E90FF"	-- dodgerblue 1 (dodgerblue)
myPP = xmobarPP { ppCurrent = xmobarColor currentWorkspaceColor "" -- . wrap "<" ">"
                , ppVisible = xmobarColor visibleWorkspaceColor "" . wrap "[" "]"
--                , ppSort    = getSortByXineramaRule
                , ppSep     = " | "
                , ppTitle   = xmobarColor "green" "" . shorten 85
                , ppExtras = [ willFloatAllNewPP (\x-> "Float") ]
                , ppOrder = newOrder
                }
newOrder :: [String] -> [String]
newOrder (ws:la:ti:[])    = [ws,la,ti]
newOrder (ws:la:ti:ex:[]) = [ws,la,ex,ti]
newOrder x                = x

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

terminalCmd = "urxvtc"
dmenuRunCmd = "cmd=$(yeganesh --executables -- -b -f -i -p \"$ \") && exec $cmd"
--dmenuRunCmd = "cmd=$(yeganesh --executables -- -b -f -i -p "$") && exec $cmd"
--dmenuRunCmd = "yeganesh --executables -- -b -f -i -p "$""

-- Main configuration
--myConfig = defaultConfig { modMask = mod4Mask }

addPrefix p ms conf =
    M.singleton p . submap $ M.mapKeys (A.first chopMod) (ms conf)
    where
        mod     = modMask conf
        chopMod = (.&. complement mod)

myConfig = myConfig2
--           {
--             keys = addPrefix (controlMask, xK_m) (keys myConfig2)
--           }

myConfig2 = defaultConfig {
             terminal = terminalCmd
           , layoutHook = avoidStruts $ layoutHook defaultConfig
           , manageHook = myManageHook <+>
--                          placeHook (inBounds (underMouse (0.5,0.5))) <+> -- simpleSmart
                          floatNextHook <+>
                          manageDocks <+>
--                          myManageHook <+>
                          manageHook defaultConfig
           , startupHook = setWMName "LG3D"
           , logHook = takeTopFocus	-- issue #177 workaround
           } `additionalKeys`
           [ ((mod4Mask, xK_l), spawn "xscreensaver-command -lock")
           , ((mod1Mask, xK_p), spawn dmenuRunCmd) -- overriding default command
--         , ((mod4Mask, xK_r), spawn dmenuRunCmd) -- additional, windows-like
           , ((mod4Mask, xK_e), spawn "dolphin") --spawn "thunar")
           , ((mod1Mask .|. shiftMask, xK_a),
                                withFocused $ keysMoveWindowTo (0, 0) (0, 0))
             -- XF86AudioMute
           , ((0, 0x1008ff12), spawn "amixer -q set Master,0 toggle")
             -- XF86AudioRaiseVolume
           , ((0, 0x1008ff13), spawn "amixer -q set Master,0 5%+")
             -- XF86AudioLowerVolume
           , ((0, 0x1008ff11), spawn "amixer -q set Master,0 5%-")
             -- Ctrl+XF86AudioMute=microphone mute (till i figure out how to use dedicated hw button)
           , ((controlMask, 0x1008ff12), spawn "amixer -q set Capture,0 toggle")
             -- Ctrl+XF86AudioRaiseVolume=microphone raise volume
           , ((controlMask, 0x1008ff13), spawn "amixer -q set Capture,0 1000+")
             -- Ctrl+XF86AudioLowerVolume=microphone lower volume
           , ((controlMask, 0x1008ff11), spawn "amixer -q set Capture,0 1000-")
             -- See also http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-FloatNext.html
           , ((mod1Mask, xK_r), toggleFloatAllNew >> runLogHook)
           ]

