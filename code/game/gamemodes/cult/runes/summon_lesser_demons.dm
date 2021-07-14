/datum/rune/summon_lesser_demon
    name = "lesser demon summoning rune"
    desc = "This rune is used to summon lesser demons for our cause."
    rune_flags = NO_TALISMAN
    domain_flags = BLOOD_DOMAIN
    var/list/summonable = list("Hell Hound"= /mob/living/simple_animal/hostile/commanded/dog/hellhound,
    "Fel Bat" = /mob/living/simple_animal/hostile/felbat,
    "Imp" = /mob/living/simple_animal/hostile/imp,
    "Hellportal")
    level = 6

/datum/rune/summon_lesser_demon/do_rune_action(mob/living/user, atom/movable/A)
    var/list/cultists = list()
    for(var/mob/living/carbon/human/C in orange(1, get_turf(A)))
        if(iscult(C))
            LAZYADD(cultists, C)
    if(LAZYLEN(cultists) >= 2)
        var/choice = input("Choose a demon to summon.") as null|anything in summonable
        if(!choice)
            return fizzle(user)
        for(var/mob/living/carbon/human/H in cultists)
            H.say("Tak'l Reno Acr'oi ara m'nellemet!")
        if(choice == "Hellportal")
            LAZYREMOVE(summonable, "Hellportal") //Can't pick Hellportal to summon
            var/i
            while(i < 3)
                var/P = summonable[pick(summonable)]
                var/mob/D = new P
                D.forceMove(get_turf(A))
                i++
            LAZYADD(summonable, "Hellportal") //Add it back again
            user.visible_message(SPAN_CULT("A wicked portal opens over \the [A], evil creatures coming forth as the rune disappears."),
            SPAN_CULT("A rift in the Veil opens over \the [A], the armies of [cult.deity] spilling out, before the rune disappears."),     
            SPAN_CULT("You hear an otherworldly noise."))
        else
            var/M = summonable[choice]
            var/mob/D = new M
            D.forceMove(get_turf(A))
            user.visible_message(SPAN_CULT("\The [A] becomes a red mist, and \an [choice] appears where the rune was."),
            SPAN_CULT("\The [A] disappears in a red mist, leaving \an [choice] behind."),
            SPAN_CULT("You hear an otherworldly noise."))  
        qdel(A)
        return TRUE
    return fizzle(user)