#define BLOOD_DOMAIN 1
#define ALL_DOMAINS BLOOD_DOMAIN


/datum/domain
    var/name //The name of the domain
    var/obj/item/focus/foci //The domain's focus
    var/flag
    var/color //The domain's colour.
    

/datum/domain/proc/pre_create_rune(var/mob/living/carbon/human/scribe, var/chosen_rune, var/obj/item/focus/F)
    if(scribe.stat || scribe.incapacitated())
        to_chat(scribe, SPAN_WARNING("You are in no shape to do this."))
        return

    var/area/A = get_area(scribe)
    //prevents using multiple dialogs to layer runes.
    if(locate(/obj/effect/rune) in get_turf(scribe)) //This is check is done twice. once when choosing to scribe a rune, once here
        to_chat(scribe, SPAN_WARNING("There is already a rune in this location."))
        return

    log_and_message_admins("created \an [chosen_rune] at \the [A.name] - [scribe.loc.x]-[scribe.loc.y]-[scribe.loc.z].") //only message if it's actually made

    return TRUE

/datum/domain/proc/create_rune(var/C, var/mob/living/carbon/human/scribe, var/chosen_rune, var/obj/item/focus/F, var/overule)
    var/time = 5 SECONDS
    if(!F) // If scribing from memoryq
        scribe.visible_message(SPAN_CULT(get_scribe_msg(scribe)))
        time = 15 SECONDS
    else if(!overule)
        scribe.visible_message(SPAN_CULT(get_focus_msg(scribe)))
    if(do_after(scribe, time))
        var/obj/effect/rune/R = new(get_turf(scribe), chosen_rune)
        to_chat(scribe, SPAN_CULT("You finish drawing [cult.deity]'s markings."))
        R.rune = chosen_rune	
        R.color = C
        R.filters = filter(type="drop_shadow", x = 1, y = 1, size = 4, color = C)
        return R

/datum/domain/proc/get_scribe_msg(var/mob/living/carbon/human/scribe)
    return

/datum/domain/proc/get_focus_msg(var/mob/living/carbon/human/scribe, var/obj/item/focus/F)
    return

/datum/domain/proc/tp(var/mob/living/carbon/human/user, var/datum/rune/R) //Custom teleport stuff.
    return

/datum/domain/blood
    name = "Blood"
    foci = /obj/item/focus
    flag = BLOOD_DOMAIN
    color = "#C80000"

/datum/domain/blood/pre_create_rune(var/mob/living/carbon/human/scribe, var/chosen_rune, var/obj/item/focus/F)
    if(!..())
        return
    var/donated = FALSE
    var/added_scribe = FALSE
    var/mob/living/carbon/human/donor = scribe

    if(F && LAZYLEN(F.blood)) //One or more blood
        var/list/potential_donors = list()
        var/unnecessary = TRUE
        for (var/mob/living/carbon/human/stored in F.blood)
            if(!(stored == scribe))
                unnecessary = FALSE //We have now confirmed there is more than one blood, and it isn't just the scribe
            if(stored in potential_donors)
                continue
            potential_donors += stored
        if(!(scribe in potential_donors))
            potential_donors += scribe
            added_scribe = TRUE
        if(unnecessary && !added_scribe)
            donated = TRUE
            F.blood -= donor
        else
            var/donor_temp = input("Choose who's blood to draw the rune with.") as null|anything in potential_donors
            if(donor_temp)
                donor = donor_temp
                if(!(added_scribe && donor == scribe))
                    donated = TRUE //If the scribe didn't have their blood stored, they have to cut their hand still.
                    F.blood -= donor
            else
                return

    var/colour = donor.species.blood_color
    create_rune(colour, scribe, chosen_rune, F, FALSE, donated, donor)

/datum/domain/blood/create_rune(var/C, var/mob/living/carbon/human/scribe, var/chosen_rune, var/obj/item/focus/F, var/overule, var/donated, var/mob/living/carbon/human/donor)
    if(!F)
        scribe.drip(4)
    else if(!donated)
        scribe.visible_message(SPAN_CULT("[scribe] slices open their palm with a ceremonial knife, dripping their blood onto \the [F], as runes appear beneath them."))
        playsound(scribe, 'sound/weapons/bladeslice.ogg', 50, FALSE)
        scribe.drip(4)
        overule = TRUE
    var/obj/effect/rune/R = ..()
    if(!R)
        return
    LAZYINITLIST(R.blood_DNA)
    R.blood_DNA[donor.dna.unique_enzymes] = donor.dna.b_type    
    
/datum/domain/blood/get_scribe_msg(scribe)
    return "Blood flows out from \the [scribe]'s hands, taking shape beneath them..."

/datum/domain/blood/get_focus_msg(scribe, F)
    return "[scribe] places \the [F] against the floor, blood streaming out of it and forming runes."

/datum/domain/blood/tp(var/mob/living/carbon/human/user, var/datum/rune/R)
    user.visible_message("<span class='warning'>[user] disappears in a flash of red light!</span>", \
		"<span class='cult'>You feel as if your body gets dragged through Redspace!</span>", \
		"<span class='warning'>You hear a sickening crunch and sloshing of viscera.</span>")
    gibs(get_turf(user))
    playsound(user, 'sound/magic/enter_blood.ogg', 50, 1)
    user.forceMove(get_turf(R.parent))
    playsound(user, 'sound/magic/enter_blood.ogg', 50, 1) //Gotta play it twice, at the destination AND source.
    gibs(get_turf(user))
    