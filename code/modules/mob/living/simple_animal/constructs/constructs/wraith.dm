/mob/living/simple_animal/construct/wraith
	name = "Wraith"
	real_name = "Wraith"
	desc = "A wicked bladed shell contraption piloted by a bound spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "floating"
	icon_living = "floating"
	maxHealth = 90
	health_prefix = "wraith"
	melee_damage_lower = 20
	melee_damage_upper = 20
	attacktext = "slashed"
	organ_names = list("core", "right arm", "left arm")
	speed = -1
	environment_smash = TRUE
	see_in_dark = 7
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/targeted/ethereal_jaunt/shift)

	flying = TRUE

/mob/living/simple_animal/construct/wraith/empowered
	name = "Spectre"
	real_name = "Spectre"
	desc = "An unholy bladed shell contraption piloted by a bound spirit."
	icon_state = "spectre"
	icon_living = "spectre"
	maxHealth = 150
	health_prefix = "spectre"
	melee_damage_lower = 30
	melee_damage_upper = 30
	speed = -2