#include functions.txt
SetWorkingDir, C:\Documents and Settings\Gud\Desktop\ORE

; DEFINE PARAMETERS
d := 2000 ; Define delay
n := 2 ; Number of miners
c := 16300 ; Capacity of hauler
spots := 9 ; Number of mining spots
m := 8 ; Set start mining spot

; Calculate constants from parameters
p := Round(c / 27500 * 100)

#z::
WinWait, EVE, 
IfWinNotActive, EVE, , WinActivate, EVE, 
WinWaitActive, EVE,

Mining:

Log("Mining session started. Assuming system " m ".")

i := 1

While, 1 {

	CheckEVE()

	; Check to make sure that all miners are running

	While A_Index <= n
	{
		if !CheckIfMining(A_Index)
		{
			Log("Not all miners are running. Reactivating...")
			DeactivateMiners(n) ; If not, deactivate miners
			Sleep, 1*d
			;Can() ; Loot what we have
			;Sleep, 1*d
			StartMining(n) ; And start mining again
			Break ; Exit while loop
		}
		Can() ; Just make sure we don't miss some loot
		CheckMoreLoot()
		Sleep, 1*d
	}
	
	If i = 15
	{
		ReactivateMiners(n) ; Reactivate miners every 60 seconds approx
		i := 1
		Can()
		CheckMoreLoot()
	}

	Can()

	if CheckIfFull(p)
		Gosub, Hauling

	Sleep, 1*d
	i += 1
}
return

#h::
WinWait, EVE, 
IfWinNotActive, EVE, , WinActivate, EVE, 
WinWaitActive, EVE,

Hauling:

; ------------------- FLY BACK TO STATION IN MINER ------------------

;Scoop drones to bay
MouseClick, right,  124,  368
Sleep, 1000
MouseClick, left,  202,  424
Sleep, 10000

Dock()

Log("Waiting for ship cooldown to finish (30 sec).")

RepairRetriever()

Sleep, 20000 ; wait for docking to complete

; ---------------- BOARD MAMMOTH AND FLY BACK TO HAUL ----------------

ActivateMammoth()

UnDock()

WarpToAsteroids(m)

; ---------------------- LOOT JET CAN TO MAMMOTH ----------------------

LootCan()

; -------------------- RETURN TO STATION WITH LOOT --------------------

Dock()

LootToStation()

; Wait for docking to finish - ADD CODE TO REPAIR HAULER?
Sleep, 25000

; -------------------- FLY BACK TO MINING IN MINER -------------------
m := PickMiningSpot(spots)

ActivateRetriever()

Undock()

WarpToAsteroids(m)

; Launch drones
MouseClick, right,  132,  546
Sleep, 1000
MouseClick, left,  176,  571
Sleep, 1000

; ------------------------- MAKE A NEW JET CAN ------------------------
MakeCan()

Can()

StartMining(n)

Return
; ---------------------------------------------------------------------
#x::
WinWait, EVE, 
IfWinNotActive, EVE, , WinActivate, EVE, 
WinWaitActive, EVE,

Undock()

WarpToAsteroids(m)

; Launch drones
MouseClick, right,  132,  546
Sleep, 1000
MouseClick, left,  176,  571
Sleep, 1000

; ------------------------- MAKE A NEW JET CAN ------------------------
MakeCan()

Can()

StartMining(n)

Goto Mining
; ---------------------------------------------------------------------

#t::
WinWait, EVE, 
IfWinNotActive, EVE, , WinActivate, EVE, 
WinWaitActive, EVE,

;Select jet can
MouseClick, left,  831,  185
Sleep, 2*d

; Approach container
MouseClick, left,  789,  101
Sleep, 2*d

;Open jet can
MouseClick, left,  838,  100
Sleep, 2*d

; Rename jet can
MouseClick, right,  825,  184
Sleep, 2*d
MouseClick, left,  819,  286
Sleep, 2*d
Send, {SHIFTDOWN}c{SHIFTUP}argo{SPACE}{SHIFTDOWN}c{SHIFTUP}ontainer{ENTER}
Sleep, 2*d


End:

return
