/datum/rune/teleport
	name = "teleportation rune"
	desc = "This rune is used to teleport around to other teleport runes of our creation. Use your focus on the rune to configure it."
	var/network
	var/last_tp_time = 0
	domain_flags = ALL_DOMAINS
	level = 5

/datum/rune/teleport/New()
	..()
	addtimer(CALLBACK(src, .proc/random_network), 5) // if this rune somehow spawned without a network, we assign a random one
	SScult.teleport_runes += src

/datum/rune/teleport/Destroy()
	SScult.teleport_runes -= src
	return ..()

/datum/rune/teleport/get_cultist_fluff_text()
	. = ..()
	if(network)
		. += "This rune's network tag reads: <span class='cult'><b><i>[network]</i></b></span>."

/datum/rune/teleport/proc/random_network()
	if(!network) // check if it hasn't been assigned yet
		network = pick(SScult.teleport_network)

/datum/rune/teleport/do_focus_action(var/mob/living/user, atom/movable/A)
	var/choice = alert(user, "Do you wish to delete this rune or configure it?", "Teleportation Rune", "Delete", "Configure")
	if(choice == "Configure")
		var/configure = input(user, "Choose a network.", "Teleportation Rune") as null|anything in SScult.teleport_network
		if(configure)
			network = configure
		else
			return FALSE //don't wipe the rune if they don't wanna change it
	else
		return ..()

/datum/rune/teleport/do_talisman_action(mob/living/user, atom/movable/A)
	teleport(user, A)
	qdel(A)

/datum/rune/teleport/do_rune_action(mob/living/user, atom/movable/A)
	teleport(user, A)

/datum/rune/teleport/proc/teleport(mob/living/user, atom/movable/A)
	var/turf/T = get_turf(user)
	if(isNotStationLevel(T.z))
		to_chat(user, SPAN_WARNING("You are too far from the station, [cult.deity] is unable to reach you here."))
		return fizzle(user, A)

	var/list/datum/rune/teleport/possible_runes = list()
	for(var/datum/rune/teleport/R in SScult.teleport_runes)
		if(R == src)
			continue
		if(R.network != src.network)
			continue
		possible_runes += R

	if(length(possible_runes))
		if(last_tp_time + 5 SECONDS > world.time)
			to_chat(user, SPAN_CULT("The rune is still recharging!"))
			return fizzle(user, A)
		user.say("Sas'so c'arta forbici!")//Only you can stop auto-muting
		var/datum/rune/teleport/valid_rune = pick(possible_runes)
		cult.dom.tp(user, valid_rune)
		valid_rune.last_tp_time = world.time
		last_tp_time = world.time
	return fizzle(user, A)


