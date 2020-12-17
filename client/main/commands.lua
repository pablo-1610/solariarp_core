RegisterCommand("s", function(source,args,rawcommand)
    Fox.trace("Sound OK")
    PlaySoundFrontend(-1, "Enter_Capture_Zone", "DLC_Apartments_Drop_Zone_Sounds", 0)
end, false)