/datum/rune/summon_person
	name = "summon person rune"
	desc = "This rune is used to summon a person to our location. It will not work if they are restrained. Must be drawn in the target's blood"
	rune_flags = NO_TALISMAN
	domain_flags = BLOOD_DOMAIN
	level = 5

/datum/rune/summon_person/do_rune_action(mob/living/user, atom/movable/A)
	var/mob/living/carbon/human/target
	var/DNA = pick(A.blood_DNA) //Rune SHOULD only have one person's blood there. But I guess it has a chance of going wrong if contaminated somehow.
	for(var/mob/living/carbon/human/H)
		var/UE = H.dna.unique_enzymes
		if(UE == DNA)
			target = H
	var/list/mob/living/carbon/users = list()
	for(var/mob/living/carbon/C in orange(1, A))
		if(iscult(C) && !C.stat)
			users += C
	if(users.len >= 3)
		if(!target)
			return fizzle(user, A)
		if(target == user) //just to be sure.
			return
		if(target.buckled_to || target.handcuffed || (!isturf(target.loc) && !istype(target.loc, /obj/structure/closet)))
			for(var/mob/C in users)
				to_chat(C, SPAN_WARNING("You cannot summon \the [target], for [target.get_pronoun("his")] shackles of blood are strong."))
			return fizzle(user, A)
		cult.dom.tp(target, src)
		target.lying = TRUE
		target.regenerate_icons()
		to_chat(target, SPAN_CULT("You feel yourself being pulled through the Veil."))

		var/dam = round(25 / (users.len/2))	//More people around the rune less damage everyone takes. Minimum is 3 cultists

		for(var/mob/living/carbon/human/C in users)
			if(iscult(C) && !C.stat)
				C.say("N'ath reth sh'yro eth d[pick("'","`")]rekkathnor!")
				C.take_overall_damage(dam, 0)
				if(users.len <= 4)				// You did the minimum, this is going to hurt more and we're going to stun you.
					C.apply_effect(rand(3,6), STUN)
					C.apply_effect(1, WEAKEN)
	user.visible_message("<span class='warning'>The rune disappears with a flash of red light, and in its place now a body lies.</span>", \
	"<span class='warning'>You are blinded by a flash of red light! After you're able to see again, you see that now instead of the rune there's a body.</span>", \
	"<span class='warning'>You hear a pop and smell ozone.</span>")
	
	qdel(A)
	return fizzle(user, A)
