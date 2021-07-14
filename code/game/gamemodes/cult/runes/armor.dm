/datum/rune/armor
	name = "forging rune"
	desc = "A rune used to create a set of armor and a sword for the acolytes to use."
	domain_flags = BLOOD_DOMAIN
	level = 5

/datum/rune/armor/do_rune_action(mob/living/user, atom/movable/A)
	user.say("N'ath reth sh'yro eth d'raggathnor!")
	user.visible_message(SPAN_DANGER("A flash of red light appears around [user], as a set of armor envelops their body!"),
						 SPAN_CULT("A refreshing feeling envelops you; the armor of [cult.deity] is once again protecting you."))

	if(empowered)
		empowered_action(user, A)

	if(istype(user, /mob/living/simple_animal/construct))
		var/mob/living/simple_animal/construct/C = user
		var/construct_class
		if(narsie_cometh) //Keeping in incase admemes want to go hell mode
			construct_class = alert(C, "Please choose which type of construct you wish to become.", "Construct Selection", "Juggernaut", "Wraith", "Harvester")
		else
			construct_class = alert(C, "Please choose which type of construct you wish to become.", "Construct Selection", "Juggernaut", "Wraith", "Artificer")

		var/list/static/construct_types = list("Juggernaut" = /mob/living/simple_animal/construct/armored,
											   "Wraith"     = /mob/living/simple_animal/construct/wraith,
											   "Artificer"  = /mob/living/simple_animal/construct/builder,
											   "Harvester"  = /mob/living/simple_animal/construct/harvester)
		
		var/construct_path = construct_types[construct_class]
		var/mob/living/simple_animal/construct/Z = new construct_path(get_turf(C))
		Z.key = C.key
		if(iscult(C))
			cult.add_antagonist(Z.mind)
		C.death()
		construct_msg(Z, construct_class)
		Z.cancel_camera()
	
	else if(ishuman(user))
		user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(user), slot_head)
		user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(user), slot_wear_suit)
		user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), slot_shoes)
		user.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(user), slot_back)
		user.put_in_hands(new /obj/item/melee/cultblade(user))

	qdel(A)
	return TRUE

/datum/rune/armor/proc/construct_msg(mob/living/construct, var/type)
	switch(type)
		if("Juggernaut")
			to_chat(construct, SPAN_CULT("You are playing a Juggernaut. Though slow, you can withstand extreme punishment, and rip apart enemies and walls alike."))
		if("Wraith")
			to_chat(construct, SPAN_CULT("You are playing a Wraith. Though relatively fragile, you are fast, deadly, and even able to phase through walls."))
		if("Artificer")
			to_chat(construct, SPAN_CULT("You are playing an Artificer. You are incredibly weak and fragile, but you are able to construct fortifications, repair allied constructs (by clicking on them), and even create new constructs"))
		if("Harvester")
			to_chat(construct, SPAN_CULT("You are playing a Harvester. You are gifted with the ability to open doors with your mind, to draw runes at will, and to teleport back to Nar'Sie. Seek out all non-believers and bring them to the Geometer."))
	to_chat(construct, SPAN_CULT("You are still bound to serve your creator, follow their orders and help them complete their goals at all costs."))

/datum/rune/armor/proc/empowered_action(mob/living/user, atom/movable/A)
	if(istype(user, /mob/living/simple_animal/construct))
		var/mob/living/simple_animal/construct/C = user
		var/construct_class
		if(narsie_cometh) //Keeping in incase admemes want to go hell mode
			construct_class = alert(C, "Please choose which type of construct you wish to become.", "Construct Selection", "Juggernaut", "Wraith", "Harvester")
		else
			construct_class = alert(C, "Please choose which type of construct you wish to become.", "Construct Selection", "Juggernaut", "Wraith", "Artificer")

		var/list/static/construct_types = list("Juggernaut" = /mob/living/simple_animal/construct/armored/empowered,
											   "Wraith"     = /mob/living/simple_animal/construct/wraith/empowered,
											   "Artificer"  = /mob/living/simple_animal/construct/builder/empowered,
											   "Harvester"  = /mob/living/simple_animal/construct/harvester/empowered)
		
		var/construct_path = construct_types[construct_class]
		var/mob/living/simple_animal/construct/Z = new construct_path(get_turf(C))
		Z.key = C.key
		if(iscult(C))
			cult.add_antagonist(Z.mind)
		C.death()
		construct_msg(Z, construct_class)
		Z.cancel_camera()
	
	else if(ishuman(user))
		user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/empowered(user), slot_head)
		user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/empowered(user), slot_wear_suit)
		user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult/empowered(user), slot_shoes)
		user.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(user), slot_back)
		user.put_in_hands(new /obj/item/melee/cultblade/empowered(user))
