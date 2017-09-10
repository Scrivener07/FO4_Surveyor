Scriptname Fallout:Surveyor:Marker extends ObjectReference
import Fallout
import Fallout:Surveyor
import Papyrus:Diagnostics:Log


UserLog Log

Actor Player
ObjectReference MapMarker


; Events
;---------------------------------------------

Event OnInit()
	Log = LogNew(Context.Title, self)
	Player = Game.GetPlayer()
	Initialize()
EndEvent


; Functions
;---------------------------------------------

Function Initialize()
	If (AllowEnabled)
		MapMarker = self.GetLinkedRef()

		If (Map.Register(self))
			WriteLine(Log, "Registered with the map.")
		Else
			WriteLine(Log, "Could not register with the map.")
		EndIf
	Else
		WriteLine(Log, "Ignoring initialize. AllowEnabled:"+AllowEnabled)
	EndIf
EndFunction


Function SetLocation(ObjectReference akTarget)
	MoveTo(akTarget)
	Enable()
	WriteLine(Log, "Moved to the target location. Target:"+akTarget)
EndFunction


Function SetDefault()
	Disable()
	MoveToMyEditorLocation()
	WriteLine(Log, "Set marker to default location.")
EndFunction


; Overrides
;---------------------------------------------

; @ObjectReference
Function Enable(bool abFadeIn = false)
	{Enables this object.}
	MapMarker.Enable(abFadeIn)
	parent.Enable(abFadeIn)
EndFunction


; @ObjectReference
Function Disable(bool abFadeOut = false)
	{Disables this object.}
	MapMarker.Disable(abFadeOut)
	parent.Disable(abFadeOut)
EndFunction


; @ObjectReference
bool Function IsEnabled()
	{Is this object currently enabled?}
	return MapMarker.IsEnabled() && parent.IsEnabled()
EndFunction


; @ObjectReference
bool Function IsDisabled()
	{Is this object currently disabled?}
	return MapMarker.IsDisabled() && parent.IsDisabled()
EndFunction


; @ObjectReference
Function MoveTo(ObjectReference akTarget, float afXOffset = 0.0, float afYOffset = 0.0, float afZOffset = 0.0, bool abMatchRotation = true)
	{Moves this object to the same location as the passed-in reference, offset by the specified amount.}
	MapMarker.MoveTo(akTarget, afXOffset, afYOffset, afZOffset, abMatchRotation)
	parent.MoveTo(akTarget, afXOffset, afYOffset, afZOffset, abMatchRotation)
EndFunction


; @ObjectReference
Function MoveToMyEditorLocation()
	{Moves this object to its own editor location.}
	MapMarker.MoveToMyEditorLocation()
	self.MoveToMyEditorLocation()
EndFunction


; Properties
;---------------------------------------------

Group Module
	Surveyor:Context Property Context Auto Const Mandatory
	Surveyor:Map Property Map Auto Const Mandatory
EndGroup


Group Properties
	bool Property AllowEnabled = true Auto Const

	bool Property CanFastTravel Hidden
		bool Function Get()
			return self.CanFastTravelToMarker()
		EndFunction
		Function Set(bool aValue)
			self.EnableFastTravel(aValue)
		EndFunction
	EndProperty
EndGroup



