/datum/ghostspawner/demon
	desc = "Assist the cult that brought you to this plane, then turn on them when it provides the most gain."
	tags = list("Antagonist")

	observers_only = TRUE

	loc_type = GS_LOC_ATOM

/datum/ghostspawner/demon/New()
	. = ..()
	welcome_message = "You are \an [short_name]. You're interests are intertwined with the cult's, however you are not their servant, and are free to make your own path."

/datum/ghostspawner/demon/balor
	short_name = "balor"
	name = "Balor"

	spawn_mob = /mob/living/carbon/human/balor
