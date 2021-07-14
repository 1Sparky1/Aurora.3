/datum/rune/talisman
	name = "talisman creation rune"
	desc = "This rune creates a talisman out of a rune around it."
	rune_flags = NO_TALISMAN | CAN_MEMORIZE
	domain_flags = ALL_DOMAINS
	level = 3

/datum/rune/talisman/do_rune_action(mob/living/user, atom/movable/A)
	var/obj/effect/rune/imbued_from
	for(var/obj/effect/rune/R in orange(1, A))
		if(!R.rune)
			continue
		if(R.rune.type == src.type)
			continue
		if(!R.rune.can_be_talisman())
			continue
		var/obj/item/talisman/T = new /obj/item/talisman(get_turf(A))
		imbued_from = R
		T.rune = R.rune
		if(empowered)
			T.uses = 3
		break
	if(imbued_from)
		A.visible_message(SPAN_CULT("The power from \the [imbued_from] floods into a talisman!"))
		user.say("H'drak v'loso! Mir'kanas verbot!")
		qdel(imbued_from)
		playsound(A, 'sound/magic/enter_blood.ogg', 50)
	else
		return fizzle(user, A)