/datum/rune/blood_drain
	name = "blood draining rune"
	desc = "This rune is used to drain the blood of non-believers into a focus."
	rune_flags = HAS_SPECIAL_TALISMAN_ACTION
	domain_flags = BLOOD_DOMAIN
	level = 4
	var/list/mob/living/carbon/human/lambs
	var/mob/living/carbon/human/target

/datum/rune/blood_drain/Destroy()
	LAZYCLEARLIST(lambs)
	target = null
	return ..()

/datum/rune/blood_drain/do_rune_action(mob/living/user, atom/movable/A)
	LAZYINITLIST(lambs)
	for(var/mob/living/carbon/human/H in get_turf(A))
		if(iscult(H))
			if(!target)
				target = H
			continue
		if(H.stat == DEAD)
			continue
		if(H.species.flags & NO_BLOOD)
			continue
		LAZYADD(lambs, H)
	if(!target)
		target = user //If nobody is on the rune, make the user the target
	if(drain(target, A))
		qdel(A)
		return TRUE
	fizzle(user, A)

/datum/rune/blood_drain/do_talisman_action(mob/living/user, var/atom/movable/A)
	LAZYINITLIST(lambs)
	var/list/choices = list()
	for(var/mob/living/carbon/human/H in orange(5, user))
		if(!iscult(H) && !(H.stat == DEAD) && !(H.species.flags & NO_BLOOD) && can_see(user, H, 5))
			LAZYADD(choices, H)
	var/target = input("Choose a target to drain.") as null|anything in choices
	if(target)
		LAZYADD(lambs, target)
	if(drain(user, A))
		qdel(A)
		return TRUE
	fizzle(user, A)
	
		

/datum/rune/blood_drain/proc/drain(var/mob/living/carbon/human/target, var/atom/movable/A)
	var/obj/item/focus/F = locate() in target.contents
	if(!F)
		return FALSE
	for(var/mob/living/carbon/human/H in lambs)
		if(LAZYLEN(F.blood) >= 6)
			to_chat(target, SPAN_WARNING("\The [F] cannot hold anymore blood."))
			return TRUE
		target.whisper("Sa'ii, ble-nii...")
		var/volume = min(H.get_blood_volume(), 10) //Ten if we can, but only as much as the victim can give
		H.vessel.remove_reagent(/decl/reagent/blood, volume)
		H.take_overall_damage(5, 0)
		playsound(target, 'sound/magic/enter_blood.ogg', 50, 1)
		LAZYADD(F.blood, H)
	return TRUE
		
