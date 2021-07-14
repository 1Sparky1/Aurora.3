/mob/living/carbon/human/balor/Initialize(mapload)
	. = ..(mapload, SPECIES_BALOR)

/datum/species/balor
	name = SPECIES_BALOR
	name_plural = "balor"
	
	icon_template = 'icons/mob/human_races/r_balor.dmi'
	icobase = 'icons/mob/human_races/r_balor.dmi'
	deform = 'icons/mob/human_races/r_balor.dmi'
	eyes = "eyes_balor"
	eyes_icons = 'icons/mob/human_face/eyes48x48.dmi'
	has_floating_eyes = TRUE
	icon_x_offset = -16
	healths_x = 22
	healths_overlay_x = 9

	default_genders = list(NEUTER)

	language = LANGUAGE_CULT
	default_language = LANGUAGE_CULT

	unarmed_types = list(/datum/unarmed_attack/claws/shredding)
	darksight = 10
	siemens_coefficient = 0
	rarity_value = 10
	slowdown = 2

	break_cuffs = TRUE
	mob_size = 30

	ethanol_resistance = -1
	taste_sensitivity = TASTE_NUMB

	speech_sounds = list('sound/species/revenant/grue_growl.ogg') //NEED SOMETHING HERE. LOOK LATER
	speech_chance = 50

	warning_low_pressure = 50 //immune to pressure, so they can into survive space/breaches without worries
	hazard_low_pressure = -1

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	total_health = 400
	brute_mod = 0.8
	burn_mod = 0.8
	fall_mod = 0

	breath_type = null
	poison_type = null

	blood_color = "#700018"
	flesh_color = "#550004"

	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "explodes in a bright flash."
	death_message_range = 7

	flags = NO_SCAN | NO_POISON | NO_BREATHE
	spawn_flags = IS_RESTRICTED

	vision_flags = DEFAULT_SIGHT | SEE_MOBS

	stamina_recovery = 5
	sprint_speed_factor = 0.8
	sprint_cost_factor = 0.5

	inherent_verbs = list(
	)

	max_nutrition_factor = -1
	max_hydration_factor = -1

	hud_type = /datum/hud_data/construct

/datum/species/balor/handle_death(var/mob/living/carbon/human/H)
	for(var/obj/item/I in H)
		H.unEquip(I)
	qdel(H)

/datum/species/balor/handle_post_spawn(var/mob/living/carbon/human/H)
	H.real_name = "Balor"
	H.name = H.real_name
	..()
	H.gender = NEUTER
	H.universal_understand = TRUE
	H.add_language(LANGUAGE_CULT)

/datum/species/revenant/get_random_name()
	return "Balor"

/datum/species/revenant/handle_death_check(var/mob/living/carbon/human/H)
	if(H.get_total_health() <= config.health_threshold_dead)
		return TRUE
	return FALSE