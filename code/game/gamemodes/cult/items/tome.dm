/obj/item/book/tome
	name = "arcane tome"
	description_cult = null
	icon_state = "tome"
	item_state = "tome"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	unique = TRUE
	slot_flags = SLOT_BELT

/obj/item/book/tome/attack(mob/living/M, mob/living/user)
	if(isobserver(M))
		var/mob/abstract/observer/D = M
		D.manifest(user)
		attack_admins(D, user)
		return

	if(!istype(M))
		return

	if(!iscult(user))
		return ..()

	if(iscult(M))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	M.take_organ_damage(0, rand(5,20)) //really lucky - 5 hits for a crit
	visible_message(SPAN_WARNING("\The [user] beats \the [M] with \the [src]!"))
	to_chat(M, SPAN_DANGER("You feel searing heat inside!"))
	attack_admins(M, user)

/obj/item/book/tome/proc/attack_admins(var/mob/living/M, var/mob/living/user)
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had the [name] used on them by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Used [name] on [M.name] ([M.ckey])</span>")
	msg_admin_attack("[key_name_admin(user)] used [name] on [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))


/obj/item/book/tome/attack_self(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/scribe = user
	if(use_check_and_message(scribe))
		return

	if(isheadcultist(scribe))
		if(!(cult.dom && cult.deity))
			switch(alert("What shall you do with the tome?", "Cultist Tome", "Choose Domain", "Choose Deity", "Cancel"))
				if("Cancel")
					return
				if("Choose Domain")
					if(use_check_and_message(user))
						return
					if(cult.dom)
						to_chat(scribe, SPAN_WARNING("Your cult already has a domain."))
						return
					var/domain = input("Choose a domain for your deity.") as null|anything in SScult.domains_by_name
					for(var/D in subtypesof(/datum/domain))
						var/datum/domain/domain_temp = new D
						if(domain_temp.name == domain)
							cult.dom = domain_temp
							break
					if(!cult.dom)
						return
					for(var/datum/mind/H in cult.current_antagonists)
						if(H.current)
							to_chat(H.current, SPAN_CULT("[scribe] has set your cult's domain to [cult.dom.name]."))
							var/obj/item/focus/F = new cult.dom.foci
							var/location = H.current.put_in_hands(F) ? "in your hand" : "at your feet"
							to_chat(H.current, SPAN_NOTICE("Your deity's power manifests as \an [F] [location]"))
					return
				if("Choose Deity")
					if(cult.deity)
						to_chat(scribe, SPAN_WARNING("Your cult already has a diety."))
						return
					cult.deity = input("Choose a deity for your cult.")
					if(!cult.deity)
						return
					for(var/datum/mind/H in cult.current_antagonists)
						if(H.current)
							to_chat(H.current, SPAN_CULT("[scribe] has set your cult's deity to [cult.deity]."))
					return
		else
			var/dat = ""
			dat += "Domain: [cult.dom]<br>"
			dat += "Deity: [cult.deity]<br>"
			dat += "<br>"
			dat += "Currently Known Runes ([KNOWN_RUNES]/[CAN_KNOW_RUNES]):<br>"
			var/list/completed = list() //List of runes we've added to dat
			var/list/delayed = list() //List of runes we've skipped (While ordering them)
			var/i = 1 //Current order level
			for(var/datum/rune/R in cult.cult_runes)
				var/colour = "green"
				if(R.level in RUNE_LEVEL_MED)
					colour = "blue"
				else if(R.level in RUNE_LEVEL_HIGH)
					colour = "purple"
				dat += "<p style='color:[colour]'>[R.name]</p>"
				completed += R.name
			dat += "<hr>"
			dat += "<p style='color:green'>Weak Runes: [SScult.count_level(RUNE_LEVEL_LOW)]</p>"
			dat += "<p style='color:cyan'>Strong Runes: [SScult.count_level(RUNE_LEVEL_MED)]/3</p>"
			dat += "<p style='color:violet'>Powerful Runes: [SScult.count_level(RUNE_LEVEL_HIGH)]/1</p>"
			dat += "<br>"
			dat += "Learn Runes:<br>"
			while(completed.len < SScult.runes_by_name.len)
				var/restart = FALSE
				for(var/rune in subtypesof(/datum/rune))
					if(restart)
						break
					var/datum/rune/R = new rune
					if(R.name in completed)
						continue
					if(R.level > i) // Order by level
						if(R.name in delayed)
							i++
							delayed = list()
							restart = TRUE
							continue
						delayed += R.name
						continue
					if(!R.domain_flags & cult.dom.flag)
						completed += R.name
						continue
					var/list/level_general = RUNE_LEVEL_LOW
					var/colour = "green"
					if(R.level in RUNE_LEVEL_MED)
						level_general = RUNE_LEVEL_MED
						colour = "cyan"
					else if(R.level in RUNE_LEVEL_HIGH)
						level_general = RUNE_LEVEL_HIGH
						colour = "violet"
					dat += "<p style='color:[colour]'>"
					var/prerequesites_met = TRUE
					for(var/datum/rune/P in R.prerequesites)
						var/checked = LAZYLEN(cult.cult_runes)
						for(var/datum/rune/O in cult.cult_runes)
							if(P.type != O.type)
								checked--
						if(!checked) 
							prerequesites_met = FALSE
					if(KNOWN_RUNES >= CAN_KNOW_RUNES || R.level > cult.get_cult_size() || !SScult.check_level_limit(level_general) || !prerequesites_met)
						// Non-href text. You can still see the runes you don't have, or which you aren't big enough for.
						dat += "[R.name] required cultists: [R.level]<br>"
						if(LAZYLEN(R.prerequesites))
							dat += "ritual requires:"
							for(var/datum/rune/P in R.prerequesites)
								dat += " [P.name]"
							dat += "</p>"
						completed += R.name
						continue
					dat += "<a href='?src=\ref[src];[R.name]=[1]'>[R.name]</a> Required Cultists: [R.level]<br>"
					if(LAZYLEN(R.prerequesites))
						dat += "- ritual requires:"
						for(var/datum/rune/P in R.prerequesites)
							dat += " [P.name]"
						dat += "</p>"
					completed += R.name
					continue
			var/datum/browser/tome_win = new(user, "tome", "Rune Overview")
			tome_win.set_content(dat)
			tome_win.open()
			return
	else
		to_chat(user, SPAN_CULT("The book seems full of illegible scribbles."))

/obj/item/book/tome/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	for(var/rune in subtypesof(/datum/rune))
		var/datum/rune/R = new rune
		if(href_list["[R.name]"])
			cult.cult_runes += R
			for(var/datum/mind/H in cult.current_antagonists)
				if(H.current)
					to_chat(H.current, SPAN_CULT("[usr] has discovered the secrets of the [R.name] rune."))
	attack_self(usr)
	return

/obj/item/book/tome/examine(mob/user)
	..(user)
	if(!iscult(user) || !isobserver(user))
		to_chat(user, "An old, dusty tome with frayed edges and a sinister looking cover.")
	else
		to_chat(user, "The foundations of a cult. These ancient texts hold the power to change the shape of the universe, but only the most devout followers can understand them.")

/obj/item/book/tome/cultify()
	return
