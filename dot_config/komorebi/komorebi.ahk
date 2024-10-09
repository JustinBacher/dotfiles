#Requires AutoHotkey v2.0.2
#SingleInstance Force

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

!q::Komorebic("close")
!m::Komorebic("minimize")

; Focus windows
!h::Komorebic("focus left")
!j::Komorebic("focus down")
!k::Komorebic("focus up")
!l::Komorebic("focus right")

!+&Tab::
!&[::Komorebic("cycle-focus previous")
!&Tab::
!&]::Komorebic("cycle-focus next")

; Move windows
!h::Komorebic("move left")
!j::Komorebic("move down")
!k::Komorebic("move up")
!l::Komorebic("move right")

; Stack windows
!Left::Komorebic("stack left")
!Down::Komorebic("stack down")
!Up::Komorebic("stack up")
!Right::Komorebic("stack right")
!;::Komorebic("unstack")
![::Komorebic("cycle-stack previous")
!]::Komorebic("cycle-stack next")

; Resize
!=::Komorebic("resize-axis horizontal increase")
!-::Komorebic("resize-axis horizontal decrease")
!+=::Komorebic("resize-axis vertical increase")
!+_::Komorebic("resize-axis vertical decrease")

; Manipulate windows
!w::Komorebic("toggle-float")
!f  ::Komorebic("toggle-monocle")

; Window manager options
!+r::Komorebic("retile")
!p::Komorebic("toggle-pause")

; Layouts
!x::Komorebic("flip-layout horizontal")
!y::Komorebic("flip-layout vertical")

; Workspaces
!1::Komorebic("focus-monitor-workspace 0 0")
!2::Komorebic("focus-monitor-workspace 1 0")
!3::Komorebic("focus-monitor-workspace 0 1")
!4::Komorebic("focus-monitor-workspace 1 1")
!5::Komorebic("focus-monitor-workspace 1 2")
!6::Komorebic("focus-monitor-workspace 1 3")
!7::Komorebic("focus-monitor-workspace 1 4")
!8::Komorebic("focus-monitor-workspace 1 5")
!9::Komorebic("focus-monitor-workspace 1 6")
!0::Komorebic("focus-monitor-workspace 1 7")

; Move windows across workspaces
!+1::Komorebic("move-to-monitor-workspace 0 0")
!+2::Komorebic("move-to-monitor-workspace 1 0")
!+3::Komorebic("move-to-monitor-workspace 0 1")
!+4::Komorebic("move-to-monitor-workspace 1 1")
!+5::Komorebic("move-to-monitor-workspace 1 2")
!+6::Komorebic("move-to-monitor-workspace 1 3")
!+7::Komorebic("move-to-monitor-workspace 1 4")
!+8::Komorebic("move-to-monitor-workspace 1 5")
!+9::Komorebic("move-to-monitor-workspace 1 6")
!+0::Komorebic("move-to-monitor-workspace 1 7")