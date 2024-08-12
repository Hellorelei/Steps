import kaplay from "kaplay";
import "kaplay/global";

const k = kaplay()

let start_menu;
let window_dimensions = k.canvas


class SpritesLoader {
	constructor() {
	}

	static getFont() {
		k.loadFont("Shantell Sans", "assets/fonts/Shantell_Sans/static/ShantellSans-Medium.ttf")
	}
	static getAssets() {
		fetch("assets/sprites/sprite_list.json").then(res => res.json()).then(json => console.log(json));
	}

	static loadStarch() {
		k.loadAseprite(
			"starch",
			"sprites/starch_1.png",
			"sprites/starch_1.json"
		)
}
}

class StartMenu {
	constructor() {}

	static setupStartMenu() {
		start_menu = scene("start_menu", () => {
			console.log(window_dimensions)
			console.log(k.width)
			k.add([
				pos(
					100, 100,
				),
				text(
					"Steps",
					{
						size: 48,
						font: "Shantell Sans",
						align: "center",
					})
			])
		})
	}
}
SpritesLoader.getFont()
SpritesLoader.getAssets()
StartMenu.setupStartMenu()
k.go("start_menu");

///k.loadSprite("bean", "sprites/bean.png")


///k.add([
///	k.pos(120, 80),
///	k.sprite("bean"),
///])

k.onClick(() => k.addKaboom(k.mousePos()))
k.onClick(
	() => k.add([
		k.pos(k.mousePos()),
		k.sprite(
			"starch",
			{
				anim: "idle",
			})
	])
)

k.onClick(() => console.log(k.mousePos()))