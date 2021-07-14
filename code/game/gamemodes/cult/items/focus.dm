/obj/item/focus
    name = "occult focus"
    icon = 'icons/obj/cult.dmi'
    icon_state = "blood_focus"
    w_class = ITEMSIZE_SMALL
    var/list/blood = list()
    description_cult = null

/obj/item/focus/attack_self(mob/living/user)
    if(!ishuman(user))
        return

    var/mob/living/carbon/human/H = user
    if(use_check_and_message(H))
        return

    if(iscult(H))
        if(!cult.cult_runes.len)
            to_chat(H, SPAN_WARNING("Your cult has not unlocked the knowledge of any runes yet."))
            return

        if(locate(/obj/effect/rune) in H.loc)
            to_chat(H, SPAN_WARNING("There is already a rune in this location."))
            return

        var/chosen_rune
        //var/network
        chosen_rune = input("Choose a rune to scribe.") as null|anything in cult.cult_runes
        if(!chosen_rune)
            return

        if(use_check_and_message(H))
            return

        cult.dom.pre_create_rune(H, chosen_rune, src)
        
    else
        var/obj/item/organ/internal/eyes/E = locate(/obj/item/organ/internal/eyes) in H.organs
        E.take_damage(25) //Staring into a focus fucks your eyes.
        to_chat(H, SPAN_WARNING("Your eyes burn as you stare into \the [src]."))
        focus_backfire(H)

/obj/item/focus/proc/focus_backfire(mob/living/carbon/human/H)
    if(H.species.flags & NO_BLOOD || blood.len >= 6)
        return
    var/volume = min(H.get_blood_volume(), 5) //Five if we can, but only as much as the victim can give
    H.vessel.remove_reagent(/decl/reagent/blood, volume)
    H.take_overall_damage(5, 0)
    blood += H

