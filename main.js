///import kaplay from "kaplay";
///import "kaplay/global";

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
		/// Using promises to ensure correct order in loading processes.
		k.load(new Promise ((resolve, reject) => {
			console.log('    · loading assets...')
			AssetLoader.loadAssets()
				.then((ui_loaded) => StartMenu.setupStartMenu())
				.then((start_menu_ready) => StartMenu.setupCreditsPage())
				.then(() => console.log('all loaded.'))
				.then(() => resolve())
		}))
			.then(() => k.go("main_menu"))
	}

	static addHover() {
		/// Add hover effects to all game objects with tag "button" in scene. Called whenever needed.
		k.onHover("button", (button) => button.use(outline(2, BLACK)))
		k.onHoverEnd("button", (button) => button.use(outline(0, WHITE)))
		k.onHover("button", (button) => console.log('hover' + button))
	}

	static addDestination(menu) {
		/// Add relevant destinations to buttons according to .json files.
		console.log(`Adding destinations to buttons in ${menu}.`)
		let obj = UIElements.UIFiles[menu]
		for (let button in obj) {
			console.log(`  -> Adding destinations for ${button}.`)
			button = obj[button]
			/// console.log(button)
			if ("tag" in button && "destination" in button) {
				k.onClick(button["tag"], () => k.go(button["destination"]))
				console.log(`    ${button["tag"]} --> ${button["destination"]}.`)
			} else {
				console.log("    no automatic destinations.")
			}
		}
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
			for (const entry of ui_list)  {
				UIElements.UIFiles[entry] = await AssetLoader.getUIData(entry)
				console.log('assigned data to uifiles:')
				console.log(UIElements.UIFiles)
			}
			console.log('        -> done')
			resolve()
		})
	}

	static async loadSprites() {
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
	static ui_magic = 8

	static createUIElement(type) {
		console.log('constructor called!')
		console.log(`    building buttons:${type}`)
		let obj = UIElements.UIFiles[type]
		try {
			for (let variable in obj) {
				console.log(`    using these args:`)
				console.log(obj[variable])
				UIElements.addButtonFromObject(obj[variable]);
			}
		}
		catch(e) {
			console.error(e)
		}
	}

	static addButtonFromObject(args) {
		/// Generic button builder.
		let button = add([
			"button",
			args['tag'],
			outline(0, WHITE),
			anchor(args['anchor']),
			pos(vec2(args['pos_x'] * this.ui_magic, args['pos_y'] * this.ui_magic),),
			area(),
			rect(
				args["width"] * this.ui_magic,
				args["height"] * this.ui_magic,
			),
		])
		if (args["text"]) {
			console.log(args["text"])
		button.add([
			text(args["text"], {
				size: 34,
				///font: "Shantell Sans",
			///font: "monospace",
			}),
			anchor(args["anchor"]),
			color(0, 100, 255),
		])
		}
		return button
	}
}

class StartMenu {
	constructor() {}

	static setupStartMenu() {
		const start_menu = scene("main_menu", () => {
			console.log(start_menu)
			UIElements.createUIElement('main_menu')
			this.setupStartMenuRiver()
			GameRoutine.addHover()
			GameRoutine.addDestination("main_menu")
			k.onClick("quit_button", (quit_button) => k.quit())
		})
		this.levelMenu()
		return true
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

	static levelMenu() {
		const level_menu = scene("level_menu", () => {
			console.log(level_menu)
			UIElements.createUIElement('level_menu')
			GameRoutine.addDestination("level_menu")
			GameRoutine.addHover()
		})
	}

	static setupCreditsPage(){
		const credits_page = scene("credits_page", () => {
			GameRoutine.addHover()
			GameRoutine.addDestination("credits")
			UIElements.createUIElement('credits')
		})
	}
}

const level_1 = scene("level_1", () => {
	k.loadSprite("map1", "base_assets/maps/level_1.png")
	const map1 = k.add([
		sprite("map1"),
		pos(48, 0),
		scale(1.3),
	]);

	UIElements.createUIElement('level_1')
	GameRoutine.addHover()
	GameRoutine.addDestination("level_1");

	loadSprite("can1", "assets/sprites/can_1.png", {
		sliceX: 2,
		sliceY: 1,
		anims: {
			crounch: { from: 0, to: 1, loop: true },
		},
	});

	const can1 = k.add([
		sprite("can1", {
			anim: "crounch",
		}),
		pos(48, 96),
	]);
})

const level_2 = scene("level_2", () => {
	k.loadSprite("map2", "base_assets/maps/level_2.png")
	const map2 = k.add([
		sprite("map2"),
		pos(48, 0),
		scale(1.3),
	])
	UIElements.createUIElement('level_2')
	GameRoutine.addHover()
	GameRoutine.addDestination("level_2")
})

const level_3 = scene("level_3", () => {
	k.loadSprite("map3", "base_assets/maps/level_3.png")
	const map3 = k.add([
		sprite("map3"),
		pos(48, 0),
		scale(1.3),
	])
	UIElements.createUIElement('level_3')
	GameRoutine.addHover()
	GameRoutine.addDestination("level_3")
})

const level_4 = scene("level_4", () => {
	k.loadSprite("map4", "base_assets/maps/level_4.png")
	const map4 = k.add([
		sprite("map4"),
		pos(48, 0),
		scale(1.3),
	])
	UIElements.createUIElement('level_4')
	GameRoutine.addHover()
	GameRoutine.addDestination("level_4")
});

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
