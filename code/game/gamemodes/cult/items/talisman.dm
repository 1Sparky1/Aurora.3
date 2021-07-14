/obj/item/talisman
	name = "eldrich talisman"
	icon = 'icons/obj/cult.dmi'
	icon_state = "talisman"
	var/uses = 1
	var/datum/rune/rune

/obj/item/talisman/Initialize()
	. = ..()
	var/image/I = image(icon = icon, icon_state = "talisman_overlay")
	I.color = cult.dom.color
	overlays += I

/obj/item/talisman/Destroy()
	QDEL_NULL(rune)
	return ..()

/obj/item/talisman/examine(mob/user)
	..()
	if(iscult(user) && rune)
		to_chat(user, "The spell inscription reads: <span class='cult'><b><i>[rune.name]</i></b></span>.")

/obj/item/talisman/attack_self(mob/living/user)
	if(iscult(user))
		if(rune)
			user.say("INVOKE!")
			rune.activate(user, src)
			return
		else
			to_chat(user, SPAN_CULT("This talisman has no power."))
	else
		to_chat(user, SPAN_CULT("The smell of ozone permeates this talisman. That can't be good."))
		return

/obj/item/talisman/proc/use()
	uses--
	if(uses <= 0)
		qdel(src)