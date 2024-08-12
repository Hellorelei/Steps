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

const canvas_width = k.width
const canvas_height = k.height

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
		Credits.setupCreditsPage()
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
		k.loadFont("Shantell Sans", "assets/fonts/Shantell_Sans/static/ShantellSans-Medium.ttf", {size:64})
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
		const start_menu = scene("start_menu", () => {
			console.log(start_menu)
			this.setupStartMenuButtons()
			this.setupStartMenuRiver()
			k.onClick("start_button", (start_button) => k.go("game"))
			k.onClick("credits_button", (start_button) => k.go("credits_page"))
		})
		k.go("start_menu");
	}

	static setupStartMenuButtons() {
		const start_button = add([
			"button",
			"start_button",
			pos(vec2(canvas_width()/2, 9*(canvas_height()/16))),
			anchor('center'),
			area({scale: vec2(1.6, 1.6)}),
			rect(
				canvas_width()/2,
				canvas_height()/8,
				),
			])
		const credits_button = add([
			"button",
			"credits_button",
			pos(vec2(canvas_width()/2, 12*(canvas_height()/16))),
			anchor('center'),
			area({scale: vec2(1.6, 1.6)}),
			rect(
				canvas_width()/2,
				canvas_height()/8,
				),
			])

	}

	static setupStartMenuRiver() {
		const river = add([
			"river",
			pos(vec2(0, canvas_height())),
			anchor("botleft"),
			area(),
			color(0, 100, 255),
			rect(
				canvas_width(),
				canvas_height()/16,
			),
		])
	}
}

class Credits {
	constructor() {}

	static setupCreditsPage(){
		const credits_page = scene("credits_page", () => {
			k.onClick("back_button", (start_button) => k.go("start_menu"))
			add([
				"back_button",
				"button",
				pos(vec2(canvas_width()/16, 14*canvas_height()/16)),
				anchor("left"),
				area(),
				color(100, 50, 100),
				rect(
					canvas_width()/8,
					canvas_height()/16,
				)
			])
		})
	}
}

GameRoutine.start()
console.log(k.width() + ', ' + k.height())

k.onClick(() => console.log(k.mousePos()))

k.onDraw(() => {
	k.drawText({
		text: "abcdefg\nhijklmn\nopqrstu\nvwxyz!",
		size: 48,
		font: "Shantell Sans",
		pos: k.mousePos(),
		width: 120
	})
})