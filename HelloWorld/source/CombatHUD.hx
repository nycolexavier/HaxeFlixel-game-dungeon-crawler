package;

import haxe.display.JsonModuleTypes.JsonEnumFields;
import haxe.rtti.CType.Platforms;
import flixel.ui.FlxBar;
import flixel.FlxSprite;

/**
    Esse enum é usado para definir os valores válidos para nossa variável de resultado.
    O resultado só pode ser um desses 4 valores e podemos verificar esses valores facilmente quando o combate for concluído.
**/

enum Outcome
{
    NONE;
    ESCAPE;
    VICTORY;
    DEFEAT;
}

enum Choice
{
    FIGHT;
    FLEE;
}

class CombatHUD extends FlxTypedGroup<FlxSprite>
{
    // Essas variáveis públicas serão usadas após o término do combate para nos ajudar a nos contar o que aconteceu.
    public var enemy:Enemy; // Passaremos o enemySprite que o "playerSprite" tocou para inicializar o combare, e isso nos informará também qual enemySprite matar, etc.

    public var playerHealth(default, null):Int; // Quando o combate terminar, precisaremos saber quanta saúde restante o "playerSprite" tem.

    public var outcome(default, null):Outcome; // Quando o combate terminar, precisatemos saber se o "PlayerSprite" matou o "enemySprite" ou fugiu.

    // Estes são os sprites que usaremos para mostrar a interface do hud de combate.
    var background:FlxSprite; // Este é o sprite de fundo
    var playerSprite:Player; // Este é um sprite do "playerSprite"
    var enemySprite:Enemy; // Este é um sprite do "enemySprite"

    // Essas variás serão usadas para rastrear a saúde do "enemySprite"
    var enemyHealth:Int;
    var enemyMaxHealth:Int;
    var enemyHealth:FlxBar; // Esse "FlxBar" nos mostrará a saúde atual/máxima do "enemySprite"

    var playerHealthCounter: FlxText; // isso mostrará a saúde atual/máxima

    var damages:Array<FlzText> // Este array conterá 2 objetos FlxText que mostraram o dano causados (ou falhas)

    var pointer:FlxSprite; // Este será o ponteiro para mostrar para qual opção (Lutar ou Fugir) o usuário está apontando.
    var selected:Choice; // Isso rastreará qual opção está selecionada
    var choices:Map<Choice, FlxText> // Este mapa contera os FlxTexts para nossas 2 opções: Luta ou Fuga

    var results:FlxText; // Esse texto mostrará o resultado da batalha pelo "playerSprite"

    var alpha:Float = 0; // we will use this to fade in and out our combat hud
    var wait:Bool = true; // Este sinalizador será definido quando não quisermos que o "PlayerSprite" seja capaz de fazer nada (entre os turnos)

    var fledSound:FlxSound;
    var hurtSound:FlxSound;
    var loseSound:FlxSound;
    var missSound:FlxSound;
    var selectSound:FlxSound;
    var winSound:FlxSound;
    var combatSound:FlxSound;

    var screen:FlxSprite;

    public function new()
    {
        super();

        screen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
        var waveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 4, -1, 4);
        var waveSprite = new FlxEffectSprite(screen, [waveEffect]);
        add(waveSprite);

        // Primeiro, crie nosso plano de fundo. Faça um quadro preto e desenhe as bordas em branco. Adicione-0 ao nosso grupo.
        background = new FlxSprite(). makeGraphic(120, 120, FlxColor.WHITE);
        background.drawRect(1, 1, 118, 44, FlxColor.BLACK);
        background.drawRect(1, 46, 118, 73, FlxColor.BLACK);
        background.screenCenter();
        add(background);

        // A seguir, faça um "playerSprite" 'fictício' que se pareça com o nosso "playerSprite" (mas não pode se mover) e adicione-o.
        playerSprite = new Player(background.x + 36, background.y + 16);
        playerSprite.animation.frameIndex = 3;
        playerSprite.active = false;
        playerSprite.facing = FlxObject.RIGHT;
        add(playerSprite);

        // Faça a mesma coisa para um "enemySprite" usaremos apenas o tipo "enemySprite" REGULAR por enquando e alterá-lo mais tarde
        enemySprite = new Enemy(background.x + 76, background.y + 16, REGULAR);
        enemySprite.animation.frameIndex = 3;
        enemySprite.active = false;
        enemySprite.facing = FlxObejct.LEFT;
        add(enemySprite);

        // Configurar a exibição de saúde do "playerSprite" e adicioná-lo ao grupo.
        playerHealthCounter = new FlxText(0, playerSprite.y + playerSprite.height + 2, 0, "3 / 3", 8);
        playerHealthCounter.alignment = CENTER;
        playerHealthCounter.x = playerSprite.x + 4 - (playerHealthCounter.width / 2);
        add(playerHealthCounter);

        // Crie e adicione um FlxBar para mostrar a saúde do "enmySprite". Vamos torná-lo vermelho e amarelo.
        
    }
}