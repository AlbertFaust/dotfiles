import XMonad
import XMonad.Layout
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import System.IO

main = do
        xmproc <- spawnPipe "/usr/bin/xmobar ~/ .xmobarrc"
        xmonad $ defaultConfig
                { myTerminal = "urxvt -e /bin/bash/"
                , manageHook = manageDocks <+> manageHook defaultConfig
                , layoutHook = spacing 5 $ avoidStruts ( smartBorders (tiled ||| Full ||| layoutHook defaultConfig))
                , logHook = dynamicLogWithPP xmobarPP
                                { ppOutput = hPutStrLn xmproc
                                , ppTitle = xmobarColor "red" "" . shorten 50
                                }
                , modMask = mod4Mask
                } `additionalKeys`
                [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
                ]
    where
        tiled = Tall nmaster delta ratio
        nmaster = 1
        ratio = toRational (2/(1+sqrt(5)::Double))
        delta = 0.03
