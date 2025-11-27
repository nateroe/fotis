# Fortress of the Infernal Sanctum

A GZDoom map project featuring defensive fortress architecture, adaptive music, and a cinematic title screen.

## Overview

- **Enemy count**: ~1052
- **Format**: UDMF for GZDoom
- **Key landmarks**: Kong Gate (octagonal fortified checkpoint), Infernal Sanctum (inverted cross building), drawbridge approach
- **Skybox**: Milky Way galaxy - creates "hell dimension in cosmic void" atmosphere

## Title Screen System

### Maquette Design
- 1/32 scale geometry (1/64 caused UDB precision issues)
- 1/16 scale textures and sprites (intentionally "wrong" for readability)
- Displayed in darkened room with dynamic overhead lighting
- Full-size reference torch sells the miniature illusion
- Tiny scaled trees in lava pools reinforce diorama feel

### Camera Sequence (5 shots)
1. Outer defenses approach
2. Full overview with scale-reference torch
3. Kong Gate from above (octagonal structure with torch ring)
4. Drawbridge from "back side" through cutaway - reveals model construction
5. Drawbridge and Sanctum from proper angle - hero shot with inverted cross

Design philosophy: Each shot leads to the next, shows the player route abstractly, interesting details but no gameplay spoilers. "A promise, not a walkthrough."

### Planned Camera System
- Data: position + look-at coordinate pairs per viewpoint
- Single coordinate set = horizontal orbit at implied radius
- Two coordinate sets = lerp between positions
- Slow movement for parallax, not a flythrough
- Goal: just enough motion for depth cues and life

## Custom Actors

### RedTorchTiny (ZScript)
```zscript
class RedTorchTiny : Actor
{
	Default
	{
		//$Title "Red Torch (Tiny)"
		//$Category "Decorations"
		//$Sprite TTS0A0
		Scale 0.0625;
		Radius 1;
		Height 4;
		ProjectilePassHeight -1;
		+SOLID;
	}
	
	States
	{
	Spawn:
		TRED ABCD 4 Bright;
		Loop;
	}
}
```
- No dynamic light (unlike standard RedTorch) - prevents lighting blowout on maquette
- DoomEdNum in MAPINFO: 14001+
- UDB limitation: 2D thing icons don't respect Scale property

## Music System

### Composition
- Inspired by John Carpenter's "Prince of Darkness"
- Original track: ~4m30s expanded to ~18m30s of loops
- Instrumentation layers:
  - Low-E drone (modular + Phase Plant, snarling texture)
  - Waterphone granular swells
  - Bassline (low E with half-step F movement - horror staple)
  - Choral pads (Phase Plant) - sparse voicings, Em7 add 9 with clustered F/G
  - Lead guitar (reverb/delay, legato bends)
  - 8-string rhythm guitar (distorted, doubles bassline)
  - 909 kick breakdown
  - "Creepy keys" (E, B, C, D focus)

### Segment Structure
18 segments total including interludes:
- SEG0-SEG7: Main progression segments
- SEG2B, SEG6B: Variant sections
- INTR1-INTR6B: Interlude loops

### Adaptive Logic
- **Ratchet system**: Music only advances forward, never regresses
- **Interludes**: Triggered when encounter cleared, player hasn't moved to next area
- **16-second lead-in**: Interludes start with moderate intensity wind-down before sparse loop
- **Threshold**: Typically `count > 4` to avoid hunting last straggler
- **Weighted monsters**: Cyberdemons count as 5, archviles weighted similarly

### Encounter Pattern (ACS)
```c
int count = 5;
while (count > 4) {
	count = ThingCount(T_NONE, tid);
	count += ThingCount(T_CYBERDEMON, tid) * 5;
	// additional wave checks as needed
	Delay(1);
}
ACS_NamedExecute("switchMusic", 0, MUS_INTR_N);
```

### switchMusic Script
- Compares logical music IDs via GetMusicIndex() indirection layer
- Only switches if new index > current index (ratchet)
- Override parameter for special cases (secret area SEG6B)
- Near-instant crossfade (0.02s) - can't sync in GZDoom, so quick cut reads better than slow misaligned fade

## Album Version (Planned)
- Separate arrangement from game loops
- May keep some extended "b" sections
- Single interlude at texture shift point (drones+guitars → 909+bass+keys)
- Will be longer than original 4m30s but much shorter than 18m30s

## Editor Notes

### UDB Quirks
- Blue pyramids in 3D view = vertex slope handles (toggle: View menu or Alt+V)
- Thing Scale property not respected in 2D view
- //$Sprite editor key works but icons have minimum display size
- 1/64 scale geometry causes precision/snapping issues

### File Organization
- ZScript actors in zscript.zs
- DoomEdNums in MAPINFO
- Custom sprites need Doom naming convention (TTS0A0.png etc)

