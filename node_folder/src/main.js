import kaplay from "kaplay";
import "kaplay/global";

const k = kaplay()

///k.loadSprite("bean", "sprites/bean.png")
k.loadAseprite(
	"starch",
	"sprites/starch_1.png",
	"sprites/starch_1.json"
)
///k.loadSpriteAtlas(
///	"sprites/starch_1.png",
///	"sprites/starch_1.json",
///)
/// k.loadSprite("starch", "http://172.22.22.61:8082/steps/assets/sprites/starch_1.gif")

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