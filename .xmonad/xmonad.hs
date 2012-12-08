import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.ManageDocks
--import XMonad.Util.WorkspaceCompare	-- for getSortByXineramaRule
import XMonad.Hooks.SetWMName
import XMonad.Layout.SimpleFloat
import XMonad.Hooks.FloatNext
import XMonad.Hooks.Place
import XMonad.Hooks.ICCCMFocus	-- issue #177 workaround. works only for JDK6...
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.FloatKeys
import XMonad.Config.Kde (kde4Config)
import Graphics.X11.ExtraTypes.XF86 (xF86XK_AudioMute,
                                     xF86XK_AudioRaiseVolume,
                                     xF86XK_AudioLowerVolume)

-- emacs-like shortcuts experiments
-- see also XMonad.Util.EZConfig.mkKeymap
--import XMonad.Actions.Submap
--import qualified Control.Arrow as A
--import Data.Bits
--import qualified Data.Map as M

data XMonadDEnv = NoEnv | KdeEnv

xmonadConfigForEnv NoEnv  = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig
xmonadConfigForEnv KdeEnv = xmonad kde4Config

-- The main function.
main = xmonadConfigForEnv NoEnv

myManageHook = composeAll . concat $ -- see also: composeOne
-- xprop | grep WM_CLASS: WM_CLASS(STRING) = <resource>, <className>
           [[ isDialog --> doFloat ]
           ,[ className =? "Skype" --> doFloat ]
           ,[ className =? "Xmessage" --> doFloat ]
           ,[ resource =? "sun-awt-X11-XDialogPeer" --> doFloat ]
           ,[ resource =? "xfce4-notifyd" --> doFloat ]
           ,[(className =? "Firefox" <&&> resource =? "Browser") --> doFloat]
           ,[(className =? "Firefox" <&&> resource =? "Download") --> doFloat]
           ,[ title =? "Firefox Preferences" -->doFloat ]
           ]

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, determines what is being written to the bar.
currentWorkspaceColor = "#FF0000"	-- red
visibleWorkspaceColor = "#1E90FF"	-- dodgerblue 1 (dodgerblue)
titleColor = "green"
maxTitleLength = 95
myPP = xmobarPP { ppCurrent = xmobarColor currentWorkspaceColor "" -- . wrap "<" ">"
                , ppVisible = xmobarColor visibleWorkspaceColor "" . wrap "[" "]"
--                , ppSort    = getSortByXineramaRule
                , ppSep     = " | "
                , ppTitle   = xmobarColor titleColor "" . shorten maxTitleLength
                , ppExtras  = [ willFloatAllNewPP (\x-> "Float") ]
                , ppOrder   = newOrder
                }
newOrder :: [String] -> [String]
newOrder (ws:la:ti:[])    = [ws,la,ti]
newOrder (ws:la:ti:ex:[]) = [ws,la,ex,ti]
newOrder x                = x

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

terminalCmd = "urxvtc"
dmenuRunCmd = "cmd=$(yeganesh --executables -- -b -f -i -p \"$ \") && exec $cmd"
--lockScreenCmd = "xscreensaver-command -lock"
lockScreenCmd = "xlock -mode blank -bg black -dpmsstandby 6 -dpmssuspend 15 -dpmsoff 30"


-- emacs-like shortcuts experiments
--addPrefix p ms conf =
--    M.singleton p . submap $ M.mapKeys (A.first chopMod) (ms conf)
--    where
--        mod     = modMask conf
--        chopMod = (.&. complement mod)

--myConfig = myConfig2
--           {
--             keys = addPrefix (controlMask, xK_m) (keys myConfig2)
--           }

myConfig = myConfig2
myConfig2 = defaultConfig {
             terminal = terminalCmd
--           , modMask = mod1Mask -- alt
--           , modMask = mod4Mask -- super
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
           [ ((mod4Mask, xK_l), spawn lockScreenCmd)
           , ((mod1Mask, xK_p), spawn dmenuRunCmd) -- overriding default command
--         , ((mod4Mask, xK_r), spawn dmenuRunCmd) -- additional, windows-like
           , ((mod4Mask, xK_e), spawn "dolphin")
           , ((mod1Mask .|. shiftMask, xK_a),
                                withFocused $ keysMoveWindowTo (0, 0) (0, 0))
             -- XF86AudioMute = 0x1008ff12
           , ((0, xF86XK_AudioMute), spawn "amixer -q set Master,0 toggle")
             -- XF86AudioRaiseVolume = 0x1008ff13
           , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set Master,0 5%+")
             -- XF86AudioLowerVolume = 0x1008ff11
           , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set Master,0 5%-")
             -- Ctrl+XF86AudioMute=microphone mute (till i figure out how to use dedicated hw button)
           , ((controlMask, xF86XK_AudioMute), spawn "amixer -q set Capture,0 toggle")
             -- Ctrl+XF86AudioRaiseVolume=microphone raise volume
           , ((controlMask, xF86XK_AudioRaiseVolume), spawn "amixer -q set Capture,0 1000+")
             -- Ctrl+XF86AudioLowerVolume=microphone lower volume
           , ((controlMask, xF86XK_AudioLowerVolume), spawn "amixer -q set Capture,0 1000-")
             -- See also http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-FloatNext.html
           , ((mod1Mask, xK_r), toggleFloatAllNew >> runLogHook)
           ]
