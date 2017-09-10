Scriptname Fallout:Surveyor:Map extends Papyrus:Project:Modules:Required
import Fallout
import Fallout:Surveyor
import Papyrus:Collections
import Papyrus:Diagnostics:Log

UserLog Log
MarkerEntry[] Entries

Struct MarkerEntry
	Surveyor:Marker Marker
	bool Available = true
EndStruct


; Events
;---------------------------------------------

Event OnInitialize()
	Log = LogNew(Context.Title, self)
	Entries = new MarkerEntry[0]
	WriteLine(Log, "Initialized")
EndEvent


; Functions
;---------------------------------------------

bool Function Register(Surveyor:Marker aMarker)
	If (aMarker)
		MarkerEntry entry = new MarkerEntry
		entry.Marker = aMarker
		entry.Available = true

		Entries.Add(entry)

		WriteLine(Log, "Registered the '"+aMarker+"'' marker.")
		return true
	Else
		WriteLine(Log, "Cannot register a none marker.")
		return false
	EndIf
EndFunction


Function MarkCreate()
	MarkerEntry entry = GetAvailable(Entries)
	If (entry)
		entry.Available = false
		entry.Marker.SetLocation(Player)
		WriteLine(Log, "Marked location on the world map. "+entry.Marker)
	Else
		WriteLine(Log, "Could not create a map marker.")
	EndIf
EndFunction


Function MarkErase()
	int last = Entries.Length - 1
	MarkerEntry entry = Entries[last]
	If (entry)
		entry.Marker.SetDefault()
		entry.Available = true
		WriteLine(Log, "Erased the last map marker. "+entry.Marker)
	Else
		WriteLine(Log, "Could not erase the last map marker.")
	EndIf
EndFunction


MarkerEntry Function GetAvailable(MarkerEntry[] aEntries)
	int index = 0

	While (index < aEntries.Length)
		index = aEntries.FindStruct("Available", true, index)
		If (index > -1)
			return aEntries[index]
		Else
			WriteLine(Log, "No available marker was found.")
			return none
		EndIf

		index += 1
	EndWhile
EndFunction
