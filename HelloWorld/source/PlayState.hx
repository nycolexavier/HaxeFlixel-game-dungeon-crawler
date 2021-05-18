package;

import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxBasic.FlxType;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	var player:Player;
	// criando um objeto para conter nosso mapa Ogmo

	var map:FlxOgmo3Loader;
	// criando outro objeto para conter o mapa FlxTile que geramos a partir do mapa Ogmo.

	var walls:FlxTilemap;

	var coins:FlxTypedGroup<Coin>;

	var enemies:FlxTypedGroup<Enemy>; 

	var hud:HUD;
	
	var money:Int = 0;

	var health:Int = 3;

	override public function create()
	{
		// Isso apenas carrega nosso arquivo de quarto em nosso objeto FlxOgmo3Loader, gera nosso FlxTilemap da camada de 'paredes' e, em seguida, define o ladrilho 1 (nosso ladrilho do piso) para não colidir e o ladrilho 2 (paredes) para colidir de qualquer direção. Em seguida, adicionamos nosso mapa de blocos ao estado.
		map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.setTileProperties(1, FlxObject.NONE);
		walls.setTileProperties(2, FlxObject.ANY);
		add(walls);

		// Moedas
		coins = new FlxTypedGroup<Coin>();
		add(coins);

		// Inimigos
		enemies = new FlxTypedGroup<Enemy>();
		add(enemies);

		// Estamos simplesmente dizendo ao nosso objeto de mapa para percorrer todas as entidades em nossa camada de 'entidades' e chamar placeEntities () para cada uma (que estamos prestes a fazer agora).
		player = new Player();
		map.loadEntities(placeEntities, "entities");
		add(player);
		// Isso simplesmente diz à câmera para seguir o jogador usando o estilo TOPDOWN, com um lerp de 1 (que ajuda a câmera a se mover um pouco mais suavemente).
		FlxG.camera.follow(player, TOPDOWN, 1);

		hud = new HUD();
		add(hud);

		super.create();
	}

	function placeEntities(entity:EntityData)
	{
		var x = entity.x;
		var y = entity.y;

		switch (entity.name)
		{
			// Portanto, se essa função for passada para uma entidade com o nome "jogador", ela definirá os valores xey do nosso objeto jogador para os valores xey da entidade.
			case "player":
				player.setPosition(x,y);
			// Isso irá simplesmente criar uma nova moeda, dizer-lhe para estar na posição definida no arquivo Ogmo (+4 axey para centralizá-la no ladrilho) e adicioná-la ao grupo de moedas.
			case "coin":
				coins.add(new Coin(x + 4, y +4));
			case "enemy":
				enemies.add(new Enemy(x + 4, y, REGULAR));
			case "boss":
				enemies.add(new Enemy(x + 4, y, BOSS));
		}
		
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		// Tudo o que isso faz é verificar se há sobreposições entre nosso jogador e o mapa de blocos das paredes a cada chamada de update (). Se houver sobreposições, os objetos serão separados automaticamente uns dos outros.
		FlxG.collide(player, walls);
		// Isso apenas diz: a cada quadro, verifique se há sobreposições entre o jogador e o grupo de moedas e, se houver, chame playerTouchCoin.
		FlxG.overlap(player, coins, playerTouchCoin);
		FlxG.collide(enemies, walls);
		enemies.forEachAlive(checkEnemyVision);
	}

	// Esta função apenas verifica se o jogador e a moeda que se sobrepõem estão vivos e existem. Nesse caso, a moeda é morta (adicionaremos a pontuação um pouco mais tarde).
	function playerTouchCoin(player:Player, coin:Coin)
	{
		if (player.alive && player.exists && coin.alive && coin.exists)
		{
			coin.kill();
			money++;
			hud.updateHUD(health, money);
		}
	}

	
	function checkEnemyVision(enemy:Enemy)
	{

		if (walls.ray(enemy.getMidpoint(), player.getMidpoint()))
		{
			enemy.seesPlayer = true;
			enemy.playerPosition = player.getMidpoint();
		}
		else
		{
			enemy.seesPlayer = false;
		}
	}
}
