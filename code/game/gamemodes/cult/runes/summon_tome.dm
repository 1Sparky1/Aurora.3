/datum/rune/summon_tome //Used for replacing leaders after they die.
	name = "mantle rune"
	desc = "This rune is used to take up the mantle of being a cult leader."
	domain_flags = ALL_DOMAINS
	level = 1

/datum/rune/summon_tome/do_rune_action(mob/living/user, atom/movable/A)
	var/lead_count = cult.get_cult_size(TRUE)
	if(isheadcultist(user))
		to_chat(user, SPAN_WARNING("You are already a cult leader."))
	if(lead_count < 3)
		user.say("N'ath reth sh'yro eth d'raggathnor!")
		user.visible_message("<span class='warning'>\The [A] disappears in a flash, and in its place lies a book.</span>", \
		"<span class='warning'>You are blinded by a flash! After you're able to see again, you see a book in place of \the [A].</span>", \
		"<span class='warning'>You hear a pop and smell ozone.</span>")
		to_chat(user, "You feel your mind open as the knowledge of [cult.deity] pours into you.")
		user.mind.special_role = "Head Cultist"
		LAZYREMOVE(cult.faction_members, user.mind)
		cult.update_icons_removed(user.mind)
		cult.update_icons_added(user.mind)
		new /obj/item/book/tome(get_turf(A))
		qdel(A)
	return TRUE