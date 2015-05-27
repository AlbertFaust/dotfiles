import XMonad
import XMonad.Layout
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import System.IO
 
main = do
        xmproc <- spawnPipe "/usr/bin/xmobar ~/ .xmobarrc"
        xmonad $ defaultConfig
                { manageHook = manageDocks <+> manageHook defaultConfig
                , layoutHook = avoidStruts ( smartBorders (Full ||| Mirror tiled ))
                , logHook = dynamicLogWithPP xmobarPP
                                { ppOutput = hPutStrLn xmproc
                                , ppTitle = xmobarColor "red" "" . shorten 50
                                }
                , modMask = mod4Mask
                } `additionalKeys`
                [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
                , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
                , ((0, xK_Print), spawn "scrot")
                ]
    where
        tiled = Tall nmaster delta ratio
        nmaster = 1
        ratio = toRational (2/(1+sqrt(5)::Double))
        delta = 0.03
