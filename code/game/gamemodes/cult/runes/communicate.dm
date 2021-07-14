/datum/rune/communicate
	name = "communication rune"
	desc = "This rune is used to send a message to all acolytes."
	rune_flags = CAN_MEMORIZE
	domain_flags = ALL_DOMAINS

/datum/rune/communicate/do_rune_action(mob/living/user, atom/movable/A)
	var/input = input(user, "Please choose a message to tell to the other acolytes.", "Voice of [cult.dom]", "")//sanitize() below, say() and whisper() have their own
	if(!input)
		fizzle(user, A)

		user.say("O bidai nabora se'sma!")
		user.whisper("[input]")

	input = sanitize(input)
	log_and_message_admins("used a communicate rune to say '[input]'")
	for(var/datum/mind/H in cult.current_antagonists)
		if(H.current)
			to_chat(H.current, SPAN_CULT("The familiar voice of [H.current] fills your mind: [input]"))
			if(empowered && (H.current != user))
				var/reply = alert(H.current, "Do you wish to reply to the sender?", "Reply?", "Yes", "No")
				if(reply == "Yes")
					var/msg = input(H.current, "Please choose a message to tell the sender.", "Voice of [cult.dom].")
					to_chat(user, SPAN_CULT("You hear the reply of [H.current]: [msg]"))
	qdel(A)
