/* Autosplitter script for Metroid Fusion (JP) on BizHawk by video james
 *
 * This autosplitter will start LiveSplit's timer the frame the menu arrow flashes and
 * will stop the timer the frame the player loses control of Samus at the end.
 *
 * Print statements print to Dbgview.exe, so use that if you want to see debug messages.
 */ 

// These variables watch memory values to find the right frames to split on.
state("emuhawk") {
	uint start : "mgba.dll", 0x000DB020, 0x10, 0x18, 0x1E8, 0x30, 0xE28;
	uint jingle : "mgba.dll", 0x000DB020, 0x10, 0x18, 0x1E8, 0x30, 0xE4C;
	uint soundCheck : "mgba.dll", 0x000DB020, 0x10, 0x18, 0x1E8, 0x30, 0x7D94;
	uint securityCheck : "mgba.dll", 0x000DB020, 0x10, 0x18, 0x1E8, 0x30, 0x54F0;
}

init { 
	print("\n********** Autosplitter is tied to game **********\n");
	byte startCounter;
	byte split;
	vars.startCounter = 0;
	vars.split = 1;
}

// This snippet adds an option to start a run from either a NG+ file or a fresh file.
startup {
	settings.Add("ngPlus", false, "NG+");
}

start {
	vars.split = 1;
	// Starts the timer after one menu change if the NG+ box is unchecked.
	if (current.start == 16723 && !settings["ngPlus"]) {
		vars.split = 1;
		print("\n********** Timer started **********\n");
		print("Split counter is: " + vars.split + "\n");
		return true;
	}
	// Starts the timer after two menu changes if the NG+ box is checked.
	if (current.start == 16723 && settings["ngPlus"]) {
		vars.startCounter += 1;
		print("\nStart counter: " + vars.startCounter + "\n");
		if (vars.startCounter == 2) {
			print("\n********** Timer started **********");
			print("Split counter is: " + vars.split + "\n");
			vars.startCounter = 0;
			return true;
		}
	}
}

split {
	vars.startCounter = 0;
	// Flag to split on the frame before the upgrade text pops on screen.
	if ((current.jingle == 2150121510) && (old.jingle != 2150121510) && (old.jingle != 1882193943 && old.jingle != 1882193945)
		&& (current.soundCheck == 0) && (current.securityCheck != 136843920)) {
			vars.split += 1;
			print("\n********** Splitting **********\n");
			print("Split counter is: " + vars.split + "\n");
			return true;
	}
	// Alternative flag to split at Power Bombs, which has a slightly different value.
	if ((current.jingle == 2148024358) && (old.jingle != 2148024358) && (old.jingle != 1882193943 && old.jingle != 1882193945)
		&& (current.soundCheck == 0) && (current.securityCheck != 136843920)) {
			vars.split += 1;
			print("\n********** Splitting **********\n");
			print("Split counter is: " + vars.split + "\n");
			return true;
	}
	// Flag to split on the frame Samus starts facing forward at the end.
	if (current.jingle == 9207808) {
		print("\n********** Timer should be stopped **********\n");
		vars.split += 1;
		return true;
	}
}
