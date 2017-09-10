Scriptname Fallout:Surveyor:Equipment extends Papyrus:Project:Modules:Required
import Fallout
import Papyrus:Diagnostics:Log


UserLog Log


int OptionNone = -1 const
int OptionExit = 0 const
int OptionCreate = 1 const
int OptionRemove = 2 const

; Events
;---------------------------------------------

Event OnInitialize()
	Log = LogNew(Context.Title, self)
	WriteLine(Log, "OnInitialize")
EndEvent


Event OnEnable()
	Add()
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForCustomEvent(Prompt, "OnSelected")
	WriteLine(Log, "OnEnable")
EndEvent


Event OnDisable()
	RemoveAll()
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForCustomEvent(Prompt, "OnSelected")
	WriteLine(Log, "OnDisable")
EndEvent


Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	If (akBaseObject == Fallout_Surveyor_Kit)
		WriteLine(Log, "The player has consumed a kit. Count:"+Count)

		If (Utility.IsInMenuMode())
			Fallout_Surveyor_KitMessageExitMenu.Show()
			Utility.Wait(0.1)
		EndIf
		Add()

		Prompt.Show(Fallout_Surveyor_KitMessagePrompt)
	EndIf
EndEvent


Event Fallout:Surveyor:Prompt.OnSelected(Surveyor:Prompt akSender, var[] arguments)
	Prompt:SelectedEventArgs e = arguments[0] as Prompt:SelectedEventArgs
	If (e)
		If (e.Index == OptionNone || e.Index == OptionExit)
			WriteLine(Log, "The prompt arguments were none or exit.")
			return
		ElseIf (e.Index == OptionCreate)
			Map.MarkCreate()
		ElseIf (e.Index == OptionRemove)
			Map.MarkErase()
		Else
			WriteLine(Log, "The prompt index '"+e.Index+"'' arguments are unhandled.")
		EndIf
	Else
		WriteLine(Log, "The prompt '"+akSender+"'' arguments are none.")
	EndIf
EndEvent


; Functions
;---------------------------------------------

Function Add()
	If (Count == 0)
		Player.AddItem(Fallout_Surveyor_Kit, 1, true)
		WriteLine(Log, "Gave the player one kit.")
	Else
		WriteLine(Log, "The player already has a kit.")
	EndIf
EndFunction


Function RemoveAll()
	If (Count > 0)
		Player.RemoveItem(Fallout_Surveyor_Kit, Count, true)
		WriteLine(Log, "Removed all kits from the player.")
	Else
		WriteLine(Log, "There are no kits to remove from the player.")
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Modules
	Surveyor:Map Property Map Auto Const Mandatory
	Surveyor:Prompt Property Prompt Auto Const Mandatory
EndGroup

Group Properties
	Potion Property Fallout_Surveyor_Kit Auto Const Mandatory

	Message Property Fallout_Surveyor_KitMessageExitMenu Auto Const Mandatory
	Message Property Fallout_Surveyor_KitMessagePrompt Auto Const Mandatory

	int Property Count Hidden
		int Function Get()
			return Player.GetItemCount(Fallout_Surveyor_Kit)
		EndFunction
	EndProperty
EndGroup
