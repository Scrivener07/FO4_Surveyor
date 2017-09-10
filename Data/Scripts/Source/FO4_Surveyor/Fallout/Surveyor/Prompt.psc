Scriptname Fallout:Surveyor:Prompt extends ReferenceAlias Default
import Fallout
import Papyrus:Diagnostics:Log
import Papyrus:Script

UserLog Log
CustomEvent OnSelected

Message Display
TextData Data

string EmptyState = "" const
string BusyState = "Busy" const

Struct TextData
	float Value1 = 0.0
	float Value2 = 0.0
	float Value3 = 0.0
	float Value4 = 0.0
	float Value5 = 0.0
	float Value6 = 0.0
	float Value7 = 0.0
	float Value8 = 0.0
	float Value9 = 0.0
EndStruct

Struct SelectedEventArgs
	int Index = -1
	{The Selected menu buttons index.}
EndStruct


; Functions
;---------------------------------------------

Event OnInit()
	Log = LogNew(Context.Title, self)
	WriteLine(Log, "Initializing")
EndEvent


; Functions
;---------------------------------------------

Function Show(Message aDisplay, TextData aData = none)
	Display = aDisplay
	Data = aData
	WriteLine(Log, "Showing the '"+aDisplay+"' message with data '"+aData+"'.")
	ChangeState(self, BusyState)
EndFunction


State Busy
	Function Show(Message aDisplay, TextData aData = none)
		{Empty}
		WriteLine(Log, "The prompt is busy and cannot show a message.")
	EndFunction


	Event OnBeginState(string asOldState)
		SelectedEventArgs Selected = new SelectedEventArgs

		If (Data)
			Selected.Index = Display.Show(\
				Data.Value1, Data.Value2, Data.Value3,\
				Data.Value4, Data.Value5, Data.Value6,\
				Data.Value7, Data.Value8, Data.Value9)
		Else
			Selected.Index = Display.Show()
		EndIf

		var[] arguments = new var[1]
		arguments[0] = Selected
		SendCustomEvent("OnSelected", arguments)

		WriteLine(Log, "Selected:"+Selected.Index)
		ChangeState(self, EmptyState)
	EndEvent


	Event OnEndState(string asNewState)
		Display = none
		Data = none
		WriteLine(Log, "The prompt data has been cleared.")
	EndEvent
EndState


; Properties
;---------------------------------------------

Group Modules
	Surveyor:Context Property Context Auto Const Mandatory
EndGroup


Group Properties
	bool Property IsReady Hidden
		bool Function Get()
			return GetState() != BusyState
		EndFunction
	EndProperty
EndGroup
