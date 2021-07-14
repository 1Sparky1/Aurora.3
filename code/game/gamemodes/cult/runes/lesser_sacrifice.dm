/datum/rune/lesser_sacrifice //GOD THIS ONE'S A MESS, AND I DON'T WANT TO TOUCH IT YET
	name = "lesser sacrificial rune"
	desc = "This rune is used to sacrifice an unbeliever providing a small boon to another near-by rune."
	rune_flags = NO_TALISMAN | CAN_MEMORIZE
	domain_flags = BLOOD_DOMAIN
	level = 6

/datum/rune/lesser_sacrifice/do_rune_action(mob/living/user, atom/movable/A)
	var/list/mob/living/carbon/human/cultists_in_range = list()
	var/list/mob/living/carbon/human/victims = list()

	for(var/mob/living/V in get_turf(A)) // Checks for non-cultist mobs to sacrifice. Lesser will take any mob.
		if(isliving(V) && !iscult(V))
			victims += V // Checks for cult status and mob type

	for(var/obj/item/I in get_turf(A)) // Checks for MMIs/brains/Intellicards
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
		var/worthy = FALSE //Provides a bonus for big sacrifices
		if(istype(H,/mob/living/carbon/human))
			worthy = TRUE //All compex mobs are worthy
		else if(istype(H,/mob/living/simple_animal))
			var/mob/living/simple_animal/lamb = H
			if(lamb.meat_amount >= 5)
				worthy = TRUE //This is aprox. anything of goat size and bigger

		var/output
		var/sacrifice
		if(cultists_in_range.len)
			sacrifice = TRUE
		else
			output = SPAN_CULT("Your target's earthly bonds are too strong. You need more cultists to succeed in this ritual.")
			fizzle(user)
		if(output)
			for(var/mob/C in cultists_in_range)
				to_chat(C, output)
		var/empower
		if(sacrifice)
			empower = do_sacrifice(cultists_in_range, H, H.stat, 80, worthy)
		if(empower)
			var/list/near_runes
			for(var/obj/effect/rune/R in orange(3, get_turf(A)))
				if(is_type_in_list(R.rune, list(/datum/rune/armor, /datum/rune/communicate, /datum/rune/talisman)))
					if(!R.rune.empowered)
						LAZYSET(near_runes, R.rune, R)
			var/datum/rune/choice = input("Choose a rune to empower.") as null|anything in near_runes
			if(choice)
				empower_rune(choice, near_runes[choice])
			qdel(A)


/datum/rune/lesser_sacrifice/proc/do_sacrifice(var/list/mob/cultists, var/mob/victim, var/victim_status, var/probability, var/worthy)
	var/victim_dead
	if(victim_status == DEAD) // dead sacrifices are half as likely to satisfy
		victim_dead = TRUE
		probability *= 0.5

	var/enough_cultists
	if(length(cultists) >= 2)
		enough_cultists = TRUE
		

	if(worthy)
		probability += 20

	var/victim_sacrifice = TRUE // Checks whether we're gonna sacrifice the victim or not
	var/satisfied = FALSE // Whether the empowered goes of
	for(var/mob/C in cultists)
		if(!victim_dead && !enough_cultists)
			to_chat(C, SPAN_WARNING("The victim is still alive, you will need more cultists chanting for the sacrifice to succeed."))
			victim_sacrifice = FALSE
		else if(prob(probability))
			to_chat(C, SPAN_CULT("[cult.deity] accepts this sacrifice."))
			satisfied = TRUE
		else
			to_chat(C, SPAN_CULT("[cult.deity] accepts this sacrifice."))
			to_chat(C, SPAN_WARNING("This soul was not enough to gain [cult.deity]'s' favor."))

	if(victim_sacrifice)
		if(isrobot(victim))
			victim.dust() // To prevent the MMI from remaining
		else
			victim.gib()
	return satisfied

/datum/rune/lesser_sacrifice/proc/empower_rune(var/datum/rune/R, var/obj/effect/rune/P)
	R.empowered = TRUE
	var/I = P.icon
	P.overlays += overlay_image(icon = I, icon_state = "empowered", flags=RESET_COLOR)