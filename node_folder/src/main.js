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
		console.log('GameRoutine.start() called: Starting...')
		k.load(new Promise ((resolve, reject) => {
			console.log('    · loading assets...')
			AssetLoader.loadAssets()
				///.then(() => console.log('did we skip?'))
				.then((ui_loaded) => StartMenu.setupStartMenu())
				.then((start_menu_ready) => Credits.setupCreditsPage())
				.then(() => console.log('all loaded.'))
				.then(() => resolve())
		}))
			.then(() => k.go("start_menu"))
	}
}

class AssetLoader {
	/// This class handles the loading of assets.

	static loadAssets(){
		return new Promise((resolve, reject) => {
			console.log('    ————> loadAssets()')
			AssetLoader.loadFont()
				.then(() => AssetLoader.loadUI())
				.then(() => AssetLoader.loadSprites())
				.then(() => console.log ('    <———— loadAssets()'))
				.then(() => resolve())

		})
	}

	static loadFont() {
		/// Let's grab our main font :)
		return new Promise(function (resolve, reject) {
			console.log('        · loading fonts...')
			k.loadFont("Shantell Sans", "assets/fonts/Shantell_Sans/static/ShantellSans-Medium.ttf", {size:64})
			console.log('        -> done')
			resolve()
		})
	}

	static loadUI() {
		return new Promise(async function (resolve, reject) {
			console.log('        · loading UI...')
			let ui_list = await AssetLoader.getUI()
			///console.log(ui_list)
			for (const entry of ui_list)  {
				///console.log(entry)
				let data = AssetLoader.getUIData(entry)
				///console.log(data)
				Object.assign(data, UIElements.UIFiles)
			}
			console.log('        -> done')
			resolve()
		})
	}

	static async loadSprites() {
		///console.log(sprite_list)
		console.log('        · loading sprites...')
		let sprite_list = await AssetLoader.getSprites()
		console.log('            ' + Object.keys(sprite_list).length + ' sprites found.')
		for (const [sprite_name, sprite_file] of Object.entries(sprite_list)) {
			console.log(
				'            loading sprite: ' + sprite_name
			)
			k.loadAseprite(
				sprite_name,
				'assets/sprites/' + sprite_file + '.png',
				'assets/sprites/' + sprite_file + '.json'
			)
		}
		console.log('        -> done')
		return true
	}

	static async getSprites() {
		/// Gets a list of sprites to load from sprite_list.json
		let sprite_list = fetch("assets/sprites/sprite_list.json").then(res => res.json());
		return await sprite_list
	}

	static async getUI() {
		let ui_list = fetch('ui/ui_list.json').then(res => res.json())
		return await ui_list
	}

	static async getUIData(entry) {
		let ui_data = fetch("ui/" + entry + '.json').then(res => res.json())
		return await ui_data
	}

}

class UIElements {
	/*
	The UI is created following properties within respective .json files.
	Elements are placed on a grid made of 64x64 8x8 squares, totaling default 512x512 display size:
			00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18...
		00	x  x  x  x  x  x  x  x
		01  ...
		02
		03
		04
		05
		06
		07
		08
		...
	 */
	static UIFiles = {}

	static createUIElement(type, entry) {
		console.log('constructor called!')
		try {
			let args = UIElements.UIFiles[entry]
			console.log('with args: ')
			console.log(args)
			switch (type) {
			case 'start_menu_big':
				return UIElements.makeMainMenuButton(args);
		}
		}
		catch(e) {
			console.error(e)
		}
	}

	static makeMainMenuButton(args) {
		return add([
			"button",
			args['tag'],
			outline(0, WHITE),
			anchor(args['anchor']),
			pos(vec2(args['pos_x'], args['pos_y']),),
			area(),
			rect(
				args["width"],
				args["height"],
			),
		])
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
			k.onClick("credits_button", (credits_button) => k.go("credits_page"))
			k.onClick("quit_button", (quit_button) => k.quit())
			k.onHover("button", (button) => button.use(outline(1, BLACK)))
			k.onHoverEnd("button", (button) => button.use(outline(0, WHITE)))
			k.onHover("button", (button) => console.log('hover' + button))
		})
		k.go("start_menu");
		return true
	}

	static setupStartMenuButtons() {
		const start_button = UIElements.createUIElement('main_menu', 'start_menu_big', 'start_button')
		/*const start_button = add([
			"button",
			"start_button",
			outline(0, WHITE),
			pos(vec2(canvas_width()/2, 9*(canvas_height()/16))),
			anchor('center'),
			area({scale: vec2(1.1, 1)}),
			rect(
				canvas_width()/2,
				canvas_height()/8,
				),
			])*/
		const credits_button = add([
			"button",
			"credits_button",
			outline(0, WHITE),
			pos(vec2(canvas_width()/2, 12*(canvas_height()/16))),
			anchor('center'),
			area({scale: vec2(1.1, 1)}),
			rect(
				canvas_width()/2,
				canvas_height()/8,
				),
			])

		const quit_button = add([
				"quit_button",
				"button",
				outline(0, WHITE),
				pos(vec2(canvas_width()-canvas_width()/16, 14*canvas_height()/16)),
				anchor("right"),
				area(),
				color(100, 10, 10),
				rect(
					canvas_width()/8,
					canvas_height()/16,
				)
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
			k.onHover("button", (button) => button.use(outline(1, BLACK)))
			k.onHoverEnd("button", (button) => button.use(outline(0, WHITE)))
			k.onClick("back_button", (start_button) => k.go("start_menu"))
			add([
				"back_button",
				"button",
				outline(0, WHITE),
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

///k.onClick(() => console.log(k.mousePos()))

///k.loadFont("Shantell Sans", "assets/fonts/Shantell_Sans/static/ShantellSans-Medium.ttf", {size:64})

/*
k.onDraw(() => {
	k.drawText({
		text: "abcdefg\nhijklmn\nopqrstu\nvwxyz!",
		size: 48,
		font: "Shantell Sans",
		///font: "monospace",
		pos: k.mousePos(),
		width: 120
	})
})*/
