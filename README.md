# 📻 🍂 Le Radio Automne
World wide web audio receiving machine

![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
[![Release](https://img.shields.io/badge/latest%20release-v1.1.2%20Samoyed-lightgrey)](https://github.com/Lesterrry/Radio-Automne/releases/latest)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

![Screenshot](https://github.com/Lesterrry/Radio-Automne/raw/main/screeens/Main.gif)

‼️ **NEW ARRIVALS >>>** 📡 [List of available frequencies](https://github.com/Lesterrry/Radio-Automne/tree/main/Frequencies)

💿 See also: [Juno](https://github.com/lesterrry/juno) – a CD player which looks like a CD player

## What is it?
Radio Automne is an internet-radio client, wrapped in beautiful user interface. It has:
- Multiple built-in frequencies which suit every mood
- *DeepWave*, automatic service, which finds almost infinite number of related tracks
- *Narrator*, voice synthesis feature, which will talk to you throughout the playback
- Sleep timer: when time's up, radio will pause and your Mac will enter sleep mode
- Multiple appearances
- 100% free access
## Installation
1. Download the [latest release](https://github.com/Lesterrry/Radio-Automne/releases/latest).
2. Move the app to the Applications directory on your Mac.
3. Right-click the app icon, select "Open".
4. Confirm opening.
## User manual
### 1. Applying power
Press `ON/STANDBY` button and wait for the radio to boot.
### 2. Tuning
Frequencies are controlled using 'Frequency Control' module. Main Display always shows selected frequency’s name. By pressing `Up` and `Down` buttons you can seek through available frequencies. Tune indicator displays state of currently selected frequency. If selected frequency is currently being used, the indicator turns green. If indicator is off, selected frequency is not being used. To tune in to such frequency, press `Set` button.

If you want to add your own frequency from SoundCloud, go to `./Music/Radio Automne` on your Mac and fill in the JSON file with as many custom frequencies as you wish.

`New` indicator switches on if selected frequency was recently added to the registry.

`Stream` indicator switches on if selected frequency does not support track identifying, as well as other smart features. Such frequencies are basic Web streams.

`Memory` indicator switches on if selected frequency is stored on your Mac.

### 3. Playing
Playback is controlled by 'Playback Controller'. To start playing, press `Play` button after you tuned in to a frequency. If you press the button while the radio is already playing, current track will start from the very beginning. 
To pause playback, press `Pause` button.

Press `Next` or `Previous` buttons to switch between tracks.

Press `Link` button to find the track online.

Press `DeepWave` button to start playing similar tracks to the current one.

### 4. Personalizing the machine
To precisely set up the machile, press `Setup` button. Setup menu will be shown in the Terminal window. Use `Up` & `Down` arrow keys on your keyboard to switch between settings, and `Left` & `Right` to change their values.

>**NB:** Sleep timer function needs your special permission if running for the first time.

>**NB:** in order for *Narrator* feature to work properly, make sure you have installed corresponding voice synthesizers. `Ava Premium` is recommended for English, and `Milena Premium` for Russian. Download them in MacOS Universal Access settings.

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
| Server | 1 - Silverwing (faster), 2 - Sprint (more reliable) |
| Verbose | 0 - few terminal output, 1 – lots of terminal output |
| Narrator | 0 - off, 1 – on |
| DeepWave chance | 0 - off, 1 – DW tracks are rare, <...>, 4 – DW tracks come up often |
| DeepWave count | [Equivalent to number of DW tracks to add during playback] |
