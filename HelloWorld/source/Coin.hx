package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class Coin extends FlxSprite
{
    public function new (x:Float, y:Float)
    {
        super(x, y);
        loadGraphic(AssetPaths.coin__png, false, 8, 8);
    }

    override function kill()
	// Primeiro, substituímos a função kill () - normalmente, ao chamar .kill () em um objeto, ele definirá as propriedades alive e existing como false. Neste caso, queremos definir alive como false, mas não queremos definir existing como false ainda (objetos que existem == false não são desenhados ou atualizados). Em vez disso, inicializamos um FlxTween, FlxTween é uma ferramenta poderosa que permite animar as propriedades de um objeto. Para nossas moedas, queremos fazê-lo desaparecer ao mesmo tempo que sobe. Definimos a duração para 0,33 segundos e estamos usando o estilo de atenuação circOut para tornar a interpolação um pouco mais agradável. Também queremos chamar finishKill () quando a interpolação for concluída, o que apenas define a propriedade exists da moeda como falsa, removendo-a efetivamente da tela. Por padrão, o tipo de interpolação é definido como ONESHOT, portanto, é executado apenas uma vez (em vez de loop). Você pode alterar isso especificando um tipo diferente nas opções de interpolação, mas em nosso caso, o comportamento padrão é exatamente o que precisamos. O tipo de callback completo FlxTween é FlxTween-> Void (recebe um único argumento FlxTween e não retorna nada). Nesse caso, o chamamos de _ para indicar que não nos importamos com ele, que é um idioma Haxe comum (além disso, não há nada de especial nele - para o compilador é apenas um argumento chamado _).
    {
        alive = false;
        FlxTween.tween(this, {alpha: 0, y: y - 16}, 0.33, {ease: FlxEase.circOut, onComplete: finishKill});
    }

    function finishKill(_)
    {
        exists = false;
    }
}