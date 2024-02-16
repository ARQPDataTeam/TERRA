#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Menu "Analysis"
	"Load TERRA", /Q, LoadKrig()
End

Function LoadKrig()
	checkUpdates_TERRA()
	Execute/P/Q/Z "INSERTINCLUDE \"KrigData\" "
	Execute/P/Q/Z "COMPILEPROCEDURES "
End

Function checkUpdates_TERRA()
	Variable yr, mon, day
	String upd
	
	String userDir = SpecialDirPath("Igor Pro User Files", 0, 0, 0) + "User Procedures:terra:"
	NewPath/O/Q/Z userPath, userDir 
	if (V_flag)
		Abort
	endif
	OpenNotebook/P=userPath/N=UpdateDate "TERRA_updateDate.txt"
	Notebook UpdateDate, getData=2
	sscanf S_value, "%4f-%2f-%2f", yr, mon, day
	Variable userDate = date2secs(yr, mon, day)
	DoWindow/K UpdateDate
	
	String updateDir = "\\\\wto-science-nas.to.on.ec.gc.ca\\arqp_data:Resources:Software:Windows:Igor:TERRA:"
	NewPath/O/Q/Z updatePath, updateDir 
	if (V_flag)
		Execute/P/Q/Z "INSERTINCLUDE \"KrigData\" "
		Execute/P/Q/Z "COMPILEPROCEDURES "
		Abort
	endif
	OpenNotebook/P=updatePath/N=UpdateDate "TERRA_updateDate.txt"
	Notebook UpdateDate, getData=2
	sscanf S_value, "%4f-%2f-%2f", yr, mon, day
	Variable updateDate = date2secs(yr, mon, day)	
	DoWindow/K UpdateDate
	
	if (updateDate > userDate)
		Prompt upd, "A new version of TERRA is available.  Do you want to update?", popup, "Yes;No"
		DoPrompt "Update TERRA", upd
		
		if (V_flag)
			Abort
		endif
	
		if (CmpStr(upd, "Yes") == 0)
			ExecuteScriptText "\"\\\wto-science-nas.to.on.ec.gc.ca\\arqp_data\Resources\Software\Windows\Igor\TERRA\TERRAUpdate.bat\""
		endif	
	endif

End