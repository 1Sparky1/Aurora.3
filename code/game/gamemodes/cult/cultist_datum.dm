/datum/cultist
	var/list/memorized_runes

/datum/cultist/proc/memorize_rune()
	set name = "Memorize Rune"
	set desc = "Stand atop a rune and memorize it, allowing you to draw it without your tome."
	set category = "Cultist"

	if(!ishuman(usr))
		to_chat(usr, SPAN_WARNING("Your form is too simple to memorize runes!"))
		return

	if(usr.stat || usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You are in no shape to do this."))
		return

	var/datum/cultist/C = usr.mind.antag_datums[MODE_CULTIST]

	if(LAZYLEN(C.memorized_runes) >= 1)
		if(isheadcultist(usr))
			if(LAZYLEN(C.memorized_runes) >= 3)	
				to_chat(usr, SPAN_WARNING("You can only memorize up to three runes!"))
				return
		else
			to_chat(usr, SPAN_WARNING("You can only memorize one rune!"))
			return

	var/mob/living/carbon/human/H = usr
	var/obj/effect/rune/R = locate() in get_turf(H)
	if(R)
		if(!R.rune.can_memorize())
			to_chat(H, SPAN_WARNING("This rune is too complex to be memorized!"))
			return
		if(LAZYISIN(C.memorized_runes, R.rune.name))
			to_chat(H, SPAN_WARNING("This rune is already memorized!"))
			return
		H.visible_message("<b>[H]</b> bends over and runs their hands across \the [src].", SPAN_NOTICE("You bend over and run your hands across the patterns of the rune, slowly memorizing it."))
		if(!do_after(H, 10 SECONDS, TRUE))
			return
		LAZYADD(C.memorized_runes, R.rune)
		to_chat(H, SPAN_NOTICE("You memorize the [R.rune]! You will now be able to scribe it at will."))
	else
		to_chat(H, SPAN_WARNING("There was no rune beneath you to memorize."))

/datum/cultist/proc/forget_rune()
	set name = "Forget Rune"
	set desc = "Cleanse the knowledge of a rune from your memory, freeing up space for another."
	set category = "Cultist"

	if(!ishuman(usr))
		to_chat(usr, SPAN_WARNING("Your form is too simple to memorize runes!"))
		return

	if(usr.stat || usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You are in no shape to do this."))
		return

	var/datum/cultist/C = usr.mind.antag_datums[MODE_CULTIST]

	if(!LAZYLEN(C.memorized_runes))
		to_chat(usr, SPAN_WARNING("You have no runes memorized!"))
		return

	var/chosen_rune = input("Choose a rune to forget.") as null|anything in C.memorized_runes
	if(!chosen_rune)
		return
	LAZYREMOVE(C.memorized_runes, chosen_rune)

/datum/cultist/proc/scribe_rune()
	set name = "Scribe Rune"
	set desc = "Scribe a rune that you have memorized."
	set category = "Cultist"

	if(!ishuman(usr))
		to_chat(usr, SPAN_WARNING("Your form is too simple to memorize runes!"))
		return

	var/datum/cultist/C = usr.mind.antag_datums[MODE_CULTIST]

	if(!LAZYLEN(C.memorized_runes))
		to_chat(usr, SPAN_WARNING("You have no runes memorized!"))
		return

	if(usr.stat || usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You are in no shape to do this."))
		return

	var/chosen_rune = input("Choose a rune to scribe.") as null|anything in C.memorized_runes
	if(!chosen_rune)
		return

	var/mob/living/carbon/human/H = usr
	cult.dom.pre_create_rune(H, chosen_rune)