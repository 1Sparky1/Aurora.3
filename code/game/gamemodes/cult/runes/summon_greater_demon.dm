/datum/rune/summon_greater_demon
    name = "greater demon summoning rune"
    desc = "This rune is used to summon a greater demon to our cause. Be warned, these powerful creatures are not fully bound to the will of us or our deity."
    rune_flags = NO_TALISMAN
    domain_flags = BLOOD_DOMAIN
    var/list/summonable = list("balor")
    level = 8

/datum/rune/summon_lesser_demon/do_rune_action(mob/living/user, atom/movable/A)
    var/list/cultists = list()
    for(var/mob/living/carbon/human/C in orange(1, get_turf(A)))
        if(iscult(C))
            LAZYADD(cultists, C)
    if(LAZYLEN(cultists) >= 3)
        var/choice = pick(summonable)
        for(var/mob/living/carbon/human/H in cultists)
            H.say("Hr'o lat'hi randir'ta ochra tir!")
        var/datum/ghostspawner/D = SSghostroles.get_spawner(choice)
	    var/datum/antagonist/A = all_antag_types[choice]
	    A.update_current_antag_max()
	    var/previous_count = D.max_count
	    D.max_count = min(D.max_count + 1, D.cur_max)
	    if(D.max_count > previous_count)
		    say_dead_direct("A slot for \an [choice] as opened up!<br>Spawn in as it by using the ghost spawner menu in the ghost tab, and try to be good!")
	    if(!D.enabled)
		    D.enable()
        user.visible_message(SPAN_CULT("\The [A] becomes a red mist, and \an [choice] appears where the rune was."),
        SPAN_CULT("\The [A] disappears in a red mist, leaving \an [choice] behind."),
        SPAN_CULT("You hear an otherworldly noise."))  
        qdel(A)
        return TRUE
    return fizzle(user)