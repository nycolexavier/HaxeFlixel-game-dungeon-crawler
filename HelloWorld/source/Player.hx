package;

import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;

// Classe do Player
class Player extends FlxSprite
{
	static inline var SPEED:Float = 200;

	public function new(x:Float = 0, y:Float = 0)
	{
		// colocar um quadrado azul de 16 pixel na tela
		super(x, y);
        loadGraphic(AssetPaths.player__png, true, 16, 16);
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        animation.add("Ir", [3, 4, 3, 5], 6, false);
        animation.add("u", [6, 7, 6, 8], 6, false);
        animation.add("d", [0, 1, 0, 2], 6, false);
        
        drag.x = drag.y = 1600;
		// Finalmente, queremos fazer um pequeno ajuste no sprite do jogador. É uma boa ideia ter certeza de que seu jogador tem uma chance decente de passar pelas portas. Como, por padrão, nosso sprite de jogador é do mesmo tamanho que nossas peças (16x16 pixels), isso faz com que o jogador tenha que enfiar a linha na agulha para passar por portas largas de 1 telha. Para remediar isso, vamos mudar o tamanho e os deslocamentos do sprite do jogador. Isso não mudará o que realmente é exibido para o gráfico do jogador, apenas sua hitbox.
        setSize(8, 8);
        offset.set(4, 4);
	}

	// Função que observará a entrada do jogador e responderá e ela
	function updateMovement()
	{
		// declaramos as variáveis auxiliares para ajudar mais tarde na função
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

        // verificação se essas teclas estão sendo pressionadas
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		if (up || down || left || right)
		{
			var newAngle:Float = 0;
			if (up)
			{
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
                facing = FlxObject.UP;
			}
			else if (down)
			{
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
                facing = FlxObject.DOWN;
			}
			else if (left) 
            {
				newAngle = 180;
                facing = FlxObject.LEFT;
            }
			else if (right)
			{
				newAngle = 0;
                facing = FlxObject.RIGHT;
            }
            // determina a velocidade baseda no ângulo e no aceleramento
            velocity.set(SPEED, 0);
            velocity.rotate(FlxPoint.weak(0, 0), newAngle);

            if((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
            {
                switch (facing)
                {
                    case FlxObject.LEFT, FlxObject.RIGHT:
                        animation.play("Ir");
                    case FlxObject.UP:
                        animation.play("u");
                    case FlxObject.DOWN:
                        animation.play("d");
                }
            }
		}
	}

	override function update(elapsed:Float)
	{
        updateMovement();
		super.update(elapsed);
	}
}
