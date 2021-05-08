#  Le Radio Automne
World wide web audio receiving machine

![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
[![Release](https://img.shields.io/badge/latest%20release-v1.1.0%20Samoyed-lightgrey)](https://github.com/Lesterrry/Radio-Automne/releases/latest)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

[![SoundCloud](https://img.shields.io/badge/SoundCloud-listen-9cf?style=social&logo=soundcloud)](https://soundcloud.com/lesterrry)
![Screenshot](https://github.com/Lesterrry/Radio-Automne/raw/main/screeens/Main.gif)
## What is it?
Radio Automne is an internet-radio client, wrapped in beautiful user interface. It provides such features, as:
- Automatic frequency range fetching, configuring and setting up
- DeepWave: smart track lookup add-on, providing ultimate tailor-made playback experience
- Narrator: voice synthesis feature, which will talk to you 
- Sleep timer: when time's up, player will pause and your Mac will enter sleep mode
- Multiple appearances 
## Installation
1. Download the [latest release](https://github.com/Lesterrry/Radio-Automne/releases/latest).
2. Move the app to the Applications directory on your Mac.
3. Right-click the app icon, select "Open".
4. Confirm opening.
## User manual
### 1. Applying power
Power is applied by pressing the ON/STANDBY button. Machine immediately starts booting. If booted successfully, machine will wait for you to choose a frequency.
### 2. Managing frequencies
Frequencies are controlled using ‘Frequency Control’ module. Main Display always shows selected frequency’s name. Try pressing Up and Down buttons, this will guide you through retrieved frequencies. To understand tuned frequency, pay attention to the Tune indicator: if module is successfully tuned, indicator turns green. If module is currently performing frequency tuning, the same indicator turns red. If indicator is off, selected frequency is not being used. To tune in to such frequency, press Set button when selected.
>Note: The New indicator switches on in case selected frequency has been added to the registry recently.
>Note: The Stream indicator switches on in case selected frequency does not support track identifying, as well as other smart features. Such frequencies are basic Web streams.
### 3. Starting playing
Playback is controlled by Playback Controller. When successfully tuned, machine should be told to start playback by pressing Play button. If pressed while already playing, Play button tells the machine to start playing current track from the very beginning. 
To pause playback, press Pause button.
Switching between tracks should be performed by pressing Next and Previous button.
Link button helps user retrieve the track origin.
DeepWave button, if pressed, tells the machine to play similar to the current one tracks. It can be pressed many times, however some tracks may not support DeepWave.
### 4. Understanding system status
System status indicator is located underneath Standby button. Colourless indicator means the machine is currently off, yellow means it’s busy, green – ready or playing, and red means that the machine has encountered an error. Usually, error descriptions are shown in the Terminal.
### 5. Personalizing the machine
To precisely set up the machile, user should press Setup button. Thus, a Setup menu will be shown in the Terminal window. Switching between settings is done by preessing Up and Down keys, while their values are set using Right and Left ones.
>Note: sleep timer function needs your special permission if running for the first time.
>Note: in order for Narrator feature to work properly, make sure you have installed corresponding voice synthesizers. Ava is recommended for English, and Default Women's Siri for Russian. Download them in MacOS Universal Access settings.

Keyboard operation:

| Key | Action |
| ------ | ------ |
| Q | Quit |
| A | Select lower frequency |
| S | Tune into selected frequency |
| D | Select upper frequency |
| Space | Play/Pause |
| Return | Switch on/off |
| Right arrow | Next track |
| Left arrow | Previous track |

Setting keys:

| Setting | Keys |
| ------ | ------ |
| Display artwork | 0 - do not display, 1 – display track artwork, 2 – display playlist artwork |
| Appearance | 1 - House in the Woods, 2 - Hi-Fi Black, 3 - Lost in Belize, 4 – Snow-white marble, 5 – Japanese High-End, 6 – Soviet Wooden, 7 – Space Dog |
| Quick Boot | 0 - off, 1 - on |
| Sleep Timer | 0 – off, 1 = 10 mins, 9 = 90 mins |
| Auto DeepWave | 0 - off, 1 – few DW tracks, <...>, 4 – lots of DW tracks |
| Verbose | 0 - few terminal output, 1 – rich terminal output |
| Narrator | 0 - off, 1 – on |
