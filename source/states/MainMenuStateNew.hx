package states;
import flixel.effects.FlxFlicker;
import options.OptionsState;

class MainMenuStateNew extends MusicBeatState{
    var path:String = "mainmenunew/";

    var bg:FlxSprite;
    var button:Array<FlxSprite> = [];
    var button_id:Int = 0;
    var button_id_X = 0;
    var button_id_Y = 0;

    var gooberVer:FlxText;
    var selectionConfirm:Bool = false;

    function onCreate() {

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.cameras = [camHUD];
        add(bg);

        gooberVer = new FlxText(12, FlxG.height - 24, 0, "VS Goober V1.0 Build", 10);
        gooberVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        gooberVer.cameras = [camHUD];
        add(gooberVer);

        for (i in 0...4) {
            button[i] = new FlxSprite().loadGraphic(Paths.image(path + "mainMenu_button_" + Std.string(i)));
            button[i].origin.set(button[i].frameWidth / 2, button[i].frameHeight / 2);
            button[i].frames = Paths.getSparrowAtlas(path + "mainMenu_button_" + Std.string(i));
            button[i].animation.addByPrefix("unselected", "section_unselected", 16);
            button[i].animation.addByPrefix("selected", "section_selected", 16);
            button[i].antialiasing = ClientPrefs.data.antialiasing;
            button[i].cameras = [camHUD];
            add(button[i]);

            if (i == 0) {
                button[i].x = 335;
                button[i].y = 65;
            } else if (i == 1) {
                button[i].x = 725;
                button[i].y = 65;
            } else if (i == 2) {
                button[i].x = 335;
                button[i].y = 405;
            } else if (i == 3) {
                button[i].x = 725;
                button[i].y = 405;
            }
        }
    }

    function onUpdate() {
        selectLogic();

        button[button_id - 1].scale.set(1.2, 1.2);
        button[button_id - 1].animation.play("selected");

        for (i in 0...4) {
            if (i != button_id - 1) {
                button[i].scale.set(1, 1);
                button[i].animation.play("unselected");

                if (selectionConfirm) {
                    button[i].visible = false;
                }
            }
        }

        if (controls.UI_ACCEPT_P) {
            selectionConfirm = true;
            FlxG.sound.play(Paths.sound('confirmMenu'));
            FlxFlicker.flicker(button[button_id - 1], 1.1, 0.05, false){
                if (button_id == 1) {
                    MusicBeatState.switchState(new StoryMenuState());
                } else if (button_id == 2) {
                    MusicBeatState.switchState(new FreeplayState());
                } else if (button_id == 3) {
                    MusicBeatState.switchState(new OptionsState());
                } else if (button_id == 4) {
                    MusicBeatState.switchState(new CreditsState());
                }
            };
        }

        if (controls.UI_BACK_P) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new TitleState());
        }
    }

    function selectLogic() {
        if (controls.UI_LEFT_P) {
            button_id_X += 1;
            FlxG.sound.play(Paths.sound('scrollMenu'));
        } else if (controls.UI_RIGHT_P) {
            button_id_X -= 1;
            FlxG.sound.play(Paths.sound('scrollMenu'));
        }

        if (controls.UI_UP_P) {
            button_id_Y += 1;
            FlxG.sound.play(Paths.sound('scrollMenu'));
        } else if (controls.UI_DOWN_P) {
            button_id_Y -= 1;
            FlxG.sound.play(Paths.sound('scrollMenu'));
        }

        if (button_id_X > 1) {
            button_id_X = 0;
        } else if (button_id_X < 0) {
            button_id_X = 1;
        }

        if (button_id_Y > 1) {
            button_id_Y = 0;
        } else if (button_id_Y < 0) {
            button_id_Y = 1;
        }

        if (button_id_X == 0 && button_id_Y == 0) {
            button_id = 1;
        } else if (button_id_X == 1 && button_id_Y == 0) {
            button_id = 2;
        } else if (button_id_X == 0 && button_id_Y == 1) {
            button_id = 3;
        } else if (button_id_X == 1 && button_id_Y == 1) {
            button_id = 4;
        }
    }
}