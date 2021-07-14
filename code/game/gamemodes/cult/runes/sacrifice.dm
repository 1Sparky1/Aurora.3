/datum/rune/sacrifice
	name = "sacrifice rune"
	desc = "This rune is used to sacrifice an unbeliever."
	rune_flags = NO_TALISMAN | CAN_MEMORIZE
	domain_flags = BLOOD_DOMAIN
	level = 8
	prerequesites = list(new /datum/rune/lesser_sacrifice)

/datum/rune/sacrifice/do_rune_action(mob/living/user, atom/movable/A)
	var/list/mob/living/carbon/human/cultists_in_range = list()
	var/list/mob/living/carbon/human/victims = list()
	var/list/needed_runes = list()

	for(var/obj/effect/rune/R in orange(5, get_turf(A)))
		if(istype(R.rune, /datum/rune/lesser_sacrifice))
			needed_runes += R

	var/more_runes = 2 - LAZYLEN(needed_runes)
	if(more_runes > 0)
		to_chat(user, SPAN_CULT("The sacrifice requires [more_runes] more lesser sacrifice runes near-by."))
		return fizzle(user)

	for(var/mob/living/carbon/human/V in get_turf(A)) // Checks for non-cultist humans to sacrifice
		if(ishuman(V) && !iscult(V))
			victims += V // Checks for cult status and mob type

	for(var/obj/item/I in get_turf(A))
		if(istype(I,/obj/item/organ/internal/brain))
			var/obj/item/organ/internal/brain/B = I
			victims += B.brainmob

		else if(istype(I,/obj/item/device/mmi))
			var/obj/item/device/mmi/B = I
			victims += B.brainmob

		else if(istype(I,/obj/item/aicard))
			for(var/mob/living/silicon/ai/AI in I)
				victims += AI
	
	for(var/mob/living/carbon/C in orange(1, A))
		if(iscult(C) && !C.stat)
			cultists_in_range += C
			C.say("Barhah hra zar[pick("'","`")]garis!")

	for(var/mob/H in victims)
		var/worthy = FALSE
		if(istype(H,/mob/living/carbon/human))
			var/willing = alert(H, "Are you a willing sacrifice?", "Sacrifice", "Yes", "No")
			if(willing == "Yes")
				worthy = TRUE //If they convince someone to be sacrificed, good on them

		var/output
		var/empower
		if(cultists_in_range.len >= 3)
			if(!istype(H, /mob/living/carbon/human))
				output = SPAN_CULT("This sacrifice is too little to gain Their favour.")
			else
				empower = do_sacrifice(cultists_in_range, H, H.stat, 60, worthy)
		else
			fizzle(user)
		
		if(output)
			for(var/mob/C in cultists_in_range)
				to_chat(C, output)
		if(empower)
			for(var/obj/effect/rune/R in orange(5, get_turf(A)))
				if(is_type_in_list(R.rune, list(/datum/rune/armor, /datum/rune/communicate, /datum/rune/talisman)))
					if(!R.rune.empowered)
						empower_rune(R.rune, R)
			qdel(A)


/datum/rune/sacrifice/proc/do_sacrifice(var/list/mob/cultists, var/mob/victim, var/victim_status, var/probability, var/worthy)
	var/victim_dead
	if(victim_status == DEAD)
		victim_dead = TRUE
		probability *= 0.5 // dead sacrifices are half as likely to satisfy

	var/enough_cultists
	if(length(cultists) >= 3)
		enough_cultists = TRUE	

	var/victim_sacrifice = TRUE // Checks whether we're gonna sacrifice the victim or not
	var/satisfied
	for(var/mob/C in cultists)
		if(!victim_dead && enough_cultists)
			if(worthy || prob(probability))
				to_chat(C, SPAN_CULT("[cult.deity] accepts this sacrifice."))
				satisfied = TRUE
			else
				to_chat(C, SPAN_CULT("[cult.deity] accepts this sacrifice."))
				to_chat(C, SPAN_WARNING("However, this soul was not enough to gain Their favor."))
		else if(!victim_dead && !enough_cultists)
			to_chat(C, SPAN_WARNING("The victim is still alive, you will need more cultists chanting for the sacrifice to succeed."))
			victim_sacrifice = FALSE

	if(victim_sacrifice)
		if(isrobot(victim))
			victim.dust() // To prevent the MMI from remaining
		else
			victim.gib()
	return satisfied

/datum/rune/sacrifice/proc/empower_rune(var/datum/rune/R, var/obj/effect/rune/P)
	R.empowered = TRUE
	var/I = P.icon
	P.overlays += overlay_image(icon = I, icon_state = "empowered", flags=RESET_COLOR)