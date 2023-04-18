Config = {}

Config.Debug = true

Config.Cinematics = {
    ["Intro"] = {
        MusicEvent = "AB21_BEECHERS_RIDE_SONG_EVENT",
        Cameras = {
            [1] = {
                Position = vector3(1259.76, -1265.02, 79.20),
                PointCamAt = vector3(1341.49, -1368.60, 81.52),
                TransitionToPosition = vector3(1362.18, -1318.53, 79.20),
                Text = "Welcome to the <strong style=\"color:yellow\">RPX Framework</strong>.",
                Cam = nil,
                FinishCam = nil,
            },
            [2] = {
                Position = vector3(2615.72, -1262.04, 53.12),
                PointCamAt = 90.0,
                TransitionToPosition = vector3(2610.23, -1137.47, 53.12),
                Text = "The <strong style=\"color:yellow\">RPX Framework</strong> is a Lua based framework for RedM built from the ground up in 2023, <span style=\"color:#0091ff\">without</span> re-inventing the wheel.",
                Cam = nil,
                FinishCam = nil,
            },
            [3] = {
                Position = vector3(2513.85, 816.91, 86.17),
                PointCamAt = 21.0,
                TransitionToPosition = vector3(2559.28, 798.94, 78.69),
                Text = "The framework was built with modern practices. It utilizes <span style=\"color:#0091ff\">state bags</span> wherever possible, and easy to understand code that serves for a great base for any roleplay server.",
                Cam = nil,
                FinishCam = nil,
            },  
            [4] = {
                Position = vector3(-1292.40, 2499.31, 334.32),
                PointCamAt = vector3(-1353.38, 2424.04, 307.12),
                TransitionToPosition = vector3(-1350.91, 2419.19, 308.82),
                Text = "With <span style=\"color:#0091ff\">OneSync Infinity</span> not only supported but required, the framework has been built to scale to the size of any server.",
                Cam = nil,
                FinishCam = nil,
            },
            [5] = {
                Position = vector3(-5870.95, -3245.26, 8.57),
                PointCamAt = vector3(-5992.37, -3230.81, -18.31),
                TransitionToPosition = vector3(-6005.03, -3268.84, -18.31),
                Text = "Whether you're in the coldest northern parts, or way down south, <span style=\"color:#0091ff\">we've got you covered</span>.",
                Cam = nil,
                FinishCam = nil,
            },
            [6] = {
                Position = vector3(-358.33, 782.59, 118.59),
                PointCamAt = vector3(-232.48, 800.04, 134.13),
                TransitionToPosition = vector3(-252.84, 793.37, 118.59),
                Text = "Welcome to the <span style=\"color:#ff1900\">Wild West</span>, choose your path with <strong style=\"color:yellow\">RPX Framework</strong>!",
                Cam = nil,
                FinishCam = nil,
            },
        },
    }
}