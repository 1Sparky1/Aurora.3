/obj/item/clothing/head/culthood
	name = "ragged hood"
	icon = 'icons/obj/cult.dmi'
	icon_state = "culthood"
	item_state = "culthood"
	contained_sprite = TRUE
	desc = "A torn, dust-caked hood."
	description_cult = "This can be reforged to become an eldritch voidsuit helmet."
	flags_inv = HIDEFACE|HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|EYES
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MAJOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL
		)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/culthood/cultify()
	var/obj/item/clothing/head/helmet/space/cult/C = new /obj/item/clothing/head/helmet/space/cult(get_turf(src))
	qdel(src)
	return C

/obj/item/clothing/head/culthood/alt
	icon_state = "cult_hoodalt"

/obj/item/clothing/suit/cultrobes
	name = "ragged robes"
	desc = "A ragged, dusty set of robes."
	description_cult = "This can be reforged to become an eldritch voidsuit."
	icon = 'icons/obj/cult.dmi'
	icon_state = "cultrobes"
	item_state = "cultrobes"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/book/tome, /obj/item/melee/cultblade)
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MAJOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL
		)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0

/obj/item/clothing/suit/cultrobes/cultify()
	var/obj/item/clothing/suit/space/cult/C = new /obj/item/clothing/suit/space/cult(get_turf(src))
	qdel(src)
	return C

/obj/item/clothing/suit/cultrobes/alt
	icon_state = "cultrobesalt"
	item_state = "cultrobesalt"

/obj/item/clothing/shoes/cult
	name = "ragged boots"
	desc = "A ragged, dusty pair of boots."
	icon = 'icons/obj/cult.dmi'
	icon_state = "cultshoes"
	item_state = "cultshoes"
	contained_sprite = TRUE
	force = 5
	silent = 1
	siemens_coefficient = 0.35 //antags don't get exceptions, it's just heavy armor by magical standards
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MAJOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL
		)
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = null

/obj/item/clothing/shoes/cult/cultify()
	return

/obj/item/clothing/head/culthood/empowered
	name = "eldritch hood"
	icon_state = "culthood_empowered"
	item_state = "culthood_empowered"
	desc = "A hood emminating dark power."
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MAJOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL
		)

/obj/item/clothing/suit/cultrobes/empowered
	name = "eldritch robes"
	desc = "A set of robes emminating dark power."
	icon_state = "cultrobes_empowered"
	item_state = "cultrobes_empowered"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MAJOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL
		)

/obj/item/clothing/shoes/cult/empowered
	name = "eldritch boots"
	desc = "A pair of boots emminating dark power."
	icon_state = "cultshoes_empowered"
	item_state = "cultshoes_empowered"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MAJOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL
		)