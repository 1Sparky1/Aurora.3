/datum/rune/hide_runes
	name = "concealment rune"
	desc = "This rune is used to conceal other runes in an area around us."
	rune_flags = CAN_MEMORIZE
	domain_flags = ALL_DOMAINS

/datum/rune/hide_runes/do_rune_action(mob/living/user, atom/movable/A)
	var/rune_found
	for(var/obj/effect/rune/R in orange(4, get_turf(A)))
		if(R == A)
			continue
		R.invisibility = INVISIBILITY_OBSERVER
		rune_found = TRUE
	for(var/mob/living/simple_animal/hostile/imp/I in orange(4, get_turf(A)))
		I.invisibility = INVISIBILITY_OBSERVER
	if(rune_found)
		user.say("Kla'atu barada nikt'o!")
		for(var/mob/V in viewers(get_turf(A)))
			to_chat(V, SPAN_WARNING("\The [A] dissipates into dust cloud, veiling the surrounding runes."))
		qdel(A)
		return TRUE