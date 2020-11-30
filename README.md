"# wrist_hockey"
Wrist Hockey is a multiplayer miniature air hockey game.

SENSORS USED:
->Accelerometer(MPU-6050)
->Piezo-electric sensor

WORKING OF THE GAME

Using two MPU-6050s we record the accelerations along the x-axis. We have
used wire library for serial communication.

The piezo-electric sensor is used to pause the game and start the game.

The two output modalities used are piezo speaker and visual output on screen.

Each players have health 100. Each miss leads to -50 lose in health.
