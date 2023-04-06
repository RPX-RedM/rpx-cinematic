local CinematicStarted = false
local CurrentCinematic = nil
local CurrentStage = nil
local ShowingText = nil

--@function: ShowSubtitle
--@description: Shows a subtitle.
--@param: Text string The text to show.
local function ShowSubtitle(Text)
    SendNUIMessage({ action = "SHOW_SUBTITLE", text = Text })
end

--@function: HideSubtitle
--@description: Hides the subtitle.
local function HideSubtitle()
    SendNUIMessage({ action = "HIDE_SUBTITLE" })
end

--@function: StartCinematic
--@description: Starts a Cinematic.
--@param: CinematicName string The name of the Cinematic to start.
local StartCinematic = function(CinematicName)
    CreateThread(function()
        local Cinematic = Config.Cinematics[CinematicName]
        if Cinematic and not CinematicStarted then
            -- Start the Cinematic
            CinematicStarted = true
            CurrentCinematic = Cinematic
            CurrentStage = 1

            LocalPlayer.state.UIHidden = true

            -- Disable player movement
            Citizen.InvokeNative(0x4D51E59243281D80, PlayerId(), false, 0, false)

            DoScreenFadeOut(250)
            Wait(250)

            -- Set the camera
            for id,camera in ipairs(Cinematic.Cameras) do
                Config.Cinematics[CinematicName].Cameras[id].Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
                SetCamCoord(Config.Cinematics[CinematicName].Cameras[id].Cam, Cinematic.Cameras[id].Position)
            end
            for id,camera in ipairs(Cinematic.Cameras) do
                Config.Cinematics[CinematicName].Cameras[id].FinishCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
                SetCamCoord(Config.Cinematics[CinematicName].Cameras[id].FinishCam, Cinematic.Cameras[id].TransitionToPosition)
            end

            -- Enable the letterbox
            Citizen.InvokeNative(0x69D65E89FFD72313, true, true) -- _REQUEST_LETTER_BOX_NOW 

            -- Start music event
            Citizen.InvokeNative(0x1E5185B72EF5158A, Cinematic.MusicEvent)  -- PREPARE_MUSIC_EVENT
            Citizen.InvokeNative(0x706D57B0F50DA710, Cinematic.MusicEvent)  -- TRIGGER_MUSIC_EVENT

            -- Set the cameras active with interpolation
            for id,camera in ipairs(Cinematic.Cameras) do
                -- Set the focus position for rendering
                SetFocusPosAndVel(Cinematic.Cameras[id].Position.x, Cinematic.Cameras[id].Position.y, Cinematic.Cameras[id].Position.z, 0.0, 0.0, 0.0)

                -- Wait for the collision to load at the camera position
                while not (Citizen.InvokeNative(0xDA8B2EAF29E872E2, Cinematic.Cameras[id].Position.x, Cinematic.Cameras[id].Position.y, Cinematic.Cameras[id].Position.z)) do -- _HAS_COLLISION_LOADED_AT_COORD
                    Wait(5)
                end

                SetCamActive(camera.Cam, true)
                ShowingText = Cinematic.Cameras[id].Text

                if type(Cinematic.Cameras[id].PointCamAt) == "vector3" then
                    PointCamAtCoord(camera.Cam, Cinematic.Cameras[id].PointCamAt)
                elseif type(Cinematic.Cameras[id].PointCamAt) == "number" then
                    SetCamRot(camera.Cam, 0.0, 0.0, Cinematic.Cameras[id].PointCamAt)
                end

                if type(Cinematic.Cameras[id].PointCamAt) == "vector3" then
                    -- The order of these two functions is important
                    SetCamActiveWithInterp(camera.FinishCam, camera.Cam, 10000, 3.0, 3.0)
                    PointCamAtCoord(camera.FinishCam, Cinematic.Cameras[id].PointCamAt)
                elseif type(Cinematic.Cameras[id].PointCamAt) == "number" then
                    -- The order of these two functions is important
                    SetCamRot(camera.FinishCam, 0.0, 0.0, Cinematic.Cameras[id].PointCamAt)
                    SetCamActiveWithInterp(camera.FinishCam, camera.Cam, 10000, 3.0, 3.0)
                end

                -- Begin rendering the script cameras
                RenderScriptCams(true, true, 0, 0)

                -- Fade the screen in and show the subtitle
                DoScreenFadeIn(250)
                Wait(260)
                ShowSubtitle(camera.Text, 1, nil)

                -- Wait for the camera to finish interpolating
                Wait(10000 + 2500)

                -- Fade the screen out and hide the subtitle
                HideSubtitle()
                DoScreenFadeOut(250)
                Wait(250)
                CurrentStage = CurrentStage + 1
            end

            -- Stop rendering the script cameras
            RenderScriptCams(false, true, 0, 0)

            LocalPlayer.state.UIHidden = false

            -- Stop music event
            Citizen.InvokeNative(0x706D57B0F50DA710, "MC_MUSIC_STOP")  -- TRIGGER_MUSIC_EVENT

            -- Reset the letterbox
            Citizen.InvokeNative(0x69D65E89FFD72313, false, false) -- _REQUEST_LETTER_BOX_NOW 

            CurrentStage = nil

            -- Destroy cameras
            for id,camera in ipairs(Cinematic.Cameras) do
                DestroyCam(camera.Cam)
                DestroyCam(camera.FinishCam)
                Config.Cinematics[CinematicName].Cameras[id].Cam = nil
                Config.Cinematics[CinematicName].Cameras[id].FinishCam = nil
            end

            -- Reset the rendering focus to the player
            ClearFocus()

            -- Wait for the collision to load at the player position before fading in
            while not (Citizen.InvokeNative(0xDA8B2EAF29E872E2, GetEntityCoords(PlayerPedId()))) do -- _HAS_COLLISION_LOADED_AT_COORD
                Wait(5)
            end

            DoScreenFadeIn(250)
            Wait(250)

            -- Re-enable player movement
            Citizen.InvokeNative(0x4D51E59243281D80, PlayerId(), true, 0, false)

            CinematicStarted = false
            CurrentCinematic = nil

            TriggerEvent("RPX:CinematicFinished", CinematicName)
        end
    end)
end
exports('StartCinematic', StartCinematic)

--@thread: CinematicThread
--@description: Disables all controls while a Cinematic is playing.
CreateThread(function()
    while true do
        Wait(0)
        if CinematicStarted then
            DisableAllControlActions(0)
        else
            Wait(500)
        end
    end
end)

--@command: cinematic
--@description: Starts a cinematic.
--@param: CinematicName The name of the cinematic to start.
if Config.Debug then
    RegisterCommand("cinematic", function(source, args, rawCommand)
        local CinematicName = args[1]
        if CinematicName then
            StartCinematic(CinematicName)
        end
    end)
end