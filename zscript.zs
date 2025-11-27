class RedTorchTiny : Actor
{
	Default
	{
		//$Title "Red Torch (Tiny)"
		//$Category "Decorations"
		//$Sprite TREDA0
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
