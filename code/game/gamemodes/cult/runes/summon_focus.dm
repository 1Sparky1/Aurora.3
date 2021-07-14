/datum/rune/summon_focus
	name = "focus summoning rune"
	desc = "This rune is used to summon a focus for our usage."
	domain_flags = ALL_DOMAINS

/datum/rune/summon_focus/do_rune_action(mob/living/user, atom/movable/A)
	user.say("Rhi't Atho Yra'll oth c'vollonnit!")
	user.visible_message("<span class='warning'>\The [A] disappears in a flash, and in its place lies a focus.</span>", \
	"<span class='warning'>You are blinded by a flash! After you're able to see again, you see a focus in place of \the [A].</span>", \
	"<span class='warning'>You hear a pop and smell ozone.</span>")
	var/obj/item/focus/F = new cult.dom.foci
	F.forceMove(get_turf(A))
	qdel(A)
	return TRUE