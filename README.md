# MiniAudio4Delphi
A modern, high-performance, fully-featured audio wrapper for Delphi, powered by the incredible miniaudio C library. 
     
🎧 MiniAudio4Delphi v0.1    
    
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/LaMitaOne/MiniAudio4Delphi)    
     
MiniAudio4Delphi brings modern 3D spatial audio, MP3/WAV/FLAC decoding, custom effects, and node-based audio routing straight to your Delphi applications — with zero external dependencies besides a single DLL.    

✨ Features
 High-Level Engine: Easy initialization, loading, and playback of audio files.
 3D Spatial Audio: Full 3D positioning, listener setup, attenuation models, and Doppler effects.
 Sound Groups (Buses): Route your audio into groups (e.g., Master, Music, SFX) for easy volume control.
 Low-Level Decoders: Directly decode MP3, WAV, and FLAC data from memory or files.
 Node Graph & Effects: Build complex audio pipelines with Biquad Filters, Delays, and custom waveforms.
 Resource Manager: Asynchronously load and manage thousands of audio files without blocking your game loop.

📦 Installation & Usage
A compiled Win64 EXE and all necessary files (including miniaudio.dll) are included in this repository.
Just download, run the EXE, and check the sample project to see how it works!
To use it in your own projects: Place MiniAudio4Delphi.pas in your library path and copy the miniaudio.dll next to your .exe.

🛠️ Building the DLL

The miniaudio.dll is included(64 bit), but if you want to recompile it yourself (e.g., for Win32 or updates), I've included the original miniaudio.h, miniaudio.c, and a how_to_compile.txt in the source folder. 4 hours till i had a working full dll... ^^            

⚠️ Status

This wrapper is fully compiled and the DLL is 100% complete (exporting over 1100 functions). The Delphi wrapper currently covers the most critical High-Level, 3D, Decoder, and Node functions. Feel free to wrap the remaining low-level filters!   

Note: This is an Alpha release and hasn't been extensively tested in deep production yet. There might be bugs. But the basics work perfectly — as you can see and hear in the included sample project (Left / Center / Right sound panning is working).

📄 License

This wrapper follows the licensing of the original miniaudio project (Public Domain / MIT-0). Do whatever you want with it.
