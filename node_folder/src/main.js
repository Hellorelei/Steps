import kaplay from "kaplay";
import "kaplay/global";

const k = kaplay({
	/// We're setting some nice defaults, such as:
	/// fixed width and height to 512 for x16 and x32 texture compat
	/// letterbox to allow for letterboxing
	/// and stretch so that the canvas fills as much space as available
	width: 512,
	height: 512,
	letterbox: true,
	stretch: true,
})

let start_menu;
let window_dimensions = k.canvas

class GameRoutine {
	/// Handles general game flow.
	constructor() {
	}

	static start() {
		console.log('GameRoutine.start() called: Starting game...')
		AssetLoader.start()
		StartMenu.setupStartMenu()
		k.go("start_menu");
	}
}

class AssetLoader {
	/// This class handles the loading of assets.
	constructor() {
	}

	static start() {
		/// List of things to do when called:
		AssetLoader.getFont()
		AssetLoader.getAssets()
	}
	static getFont() {
		/// Let's grab our main font :)
		k.loadFont("Shantell Sans", "assets/fonts/Shantell_Sans/static/ShantellSans-Medium.ttf")
	}
	static getAssets() {
		/// Gets a list of sprites to load from sprite_list.json
		fetch("assets/sprites/sprite_list.json").then(res => res.json()).then(json => AssetLoader.loadSprites(json));
	}

	static loadSprites(sprite_list) {
		/// Tries to load all sprites from the provided dictionary
		///console.log(sprite_list)
		console.log('Loading sprites...')
		console.log(Object.keys(sprite_list).length + ' assets found.')
		for (const [sprite_name, sprite_file] of Object.entries(sprite_list)) {
			console.log(
				'Loading sprite: ' + sprite_name
			)
			k.loadAseprite(
				sprite_name,
				'assets/sprites/' + sprite_file + '.png',
				'assets/sprites/' + sprite_file + '.json'
			)
			console.log(
				'    done!'
			)
		}
	}
}

class StartMenu {
	constructor() {}

	static setupStartMenu() {
		start_menu = scene("start_menu", () => {
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

GameRoutine.start()
console.log(k.width() + ', ' + k.height())
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