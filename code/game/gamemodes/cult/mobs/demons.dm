/mob/living/simple_animal/hostile/commanded/dog/hellhound
	name = "hell hound"
	short_name = "hell hound"
	desc = "A demonic hound from beyond the Veil."
	description_cult = "The hell hound will follow any orders given to it in the language of the Cult."

	/* icon_state = "hellhound"
	icon_living = "hellhound"
	icon_dead = "hellhound_dead" */

	speak = list("Growl!", "Bark!", "AUUUUUU!","AwooOOOoo!")
	speak_emote = list("barks", "growls")
	emote_hear = list("barks", "growls")
	faction = "cult"

/mob/living/simple_animal/hostile/commanded/dog/hellhound/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(thinking_enabled && (language == all_languages[LANGUAGE_CULT]))
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return 0

/mob/living/simple_animal/hostile/commanded/dog/hellhound/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0)
	if(thinking_enabled && (language == all_languages[LANGUAGE_CULT]))
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return 0

/mob/living/simple_animal/hostile/commanded/dog/hellhound/befriend()
    return

/mob/living/simple_animal/hostile/commanded/dog/hellhound/change_name()
    return

/mob/living/simple_animal/hostile/commanded/dog/hellhound/Initialize()
    . = ..()
    var/input = pick(SScult.hellhound_names)
    LAZYREMOVE(SScult.hellhound_names, input) //To prevent duplicate naming
    if(input)
        name = input
        real_name = input
        named = TRUE

/mob/living/simple_animal/hostile/felbat
	name = "fel bat"
	desc = "A small, otherworldly, winged creature"
	description_cult = "The fel bat will track down and attack a creature it is given the scent off."

	icon_state = "devil"
	icon_living = "devil"
	icon_dead = "devil_dead"
	icon_rest = "devil_rest"
	turns_per_move = 3

	organ_names = list("head", "chest", "right wing", "left wing", "right leg", "left leg")
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = -2
	maxHealth = 15
	health = 15
	mob_size = 5

	pass_flags = PASSTABLE

	harm_intent_damage = 10
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "slashed"
	attack_sound = 'sound/weapons/slash.ogg'

	faction = "cult"
	flying = TRUE
	butchering_products = list(/obj/item/stack/material/animalhide = 1)
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 2

	var/mob/living/carbon/human/sniffed

/mob/living/simple_animal/hostile/felbat/attackby(obj/O, mob/user)
	if(iscult(user))
		if(!sniffed && O.fingerprints)
			to_chat(user, SPAN_NOTICE("\The [src] starts sniffing and investigating \the [O]."))
			var/scent = pick(O.fingerprints)
			if(do_after(user, 10))
				for(var/mob/living/carbon/human/H in world)
					if(H.get_full_print() == scent)
						if(iscult(H))
							return
						sniffed = H
						to_chat(user, SPAN_CULT("\The [src] sniff the air, before letting out a ravenous cry!"))
						return
				to_chat(user, SPAN_WARNING("\The [src] sniffs the air, then lets out an unsatisfied cry!"))
			else
				to_chat(user, SPAN_WARNING("You move away from \the [src] before it can catch a scent"))
	return ..()

/mob/living/simple_animal/hostile/felbat/think()
	if(iscult(sniffed))
		sniffed = null
		target_mob = null
	. = ..()
	if(sniffed)
		if(sniffed.stat == DEAD)
			sniffed = null		
		if(target_mob != sniffed)
			target_mob = sniffed
		if(iscult(sniffed))
			sniffed = null
			target_mob = null
		var/move_distance = smart_melee ? 2 : 1
		walk_to(src, sniffed, move_distance, move_to_delay)
		stance = HOSTILE_STANCE_ATTACKING

/mob/living/simple_animal/hostile/imp
	name = "imp"
	desc = "A small winged imp from another plane."
	description_cult = "The imp can be hidden by a hide rune."

	icon_state = "devil"
	icon_living = "devil"
	icon_dead = "devil_dead"
	icon_rest = "devil_rest"
	turns_per_move = 2

	organ_names = list("head", "chest", "right wing", "left wing", "right leg", "left leg")
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = -1
	maxHealth = 25
	health = 25
	mob_size = 7

	pass_flags = PASSTABLE

	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "stung"
	attack_sound = 'sound/weapons/pierce.ogg'

	faction = "cult"
	flying = TRUE
	butchering_products = list(/obj/item/stack/material/animalhide = 1)
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 2

/mob/living/simple_animal/hostile/imp/AttackingTarget()
	if(invisibility)
		invisibility = FALSE
	return ..()