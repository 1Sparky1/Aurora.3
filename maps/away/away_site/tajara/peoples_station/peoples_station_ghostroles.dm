/datum/ghostspawner/human/peoples_station_crew
	short_name = "peoples_station_crew"
	name = "People's Space Station Crewmember"
	desc = "Crew the People's Space Station."
	tags = list("External")

	spawnpoints = list("peoples_station_crew")
	req_perms = null
	max_count = 5
	uses_species_whitelist = FALSE

	outfit = /obj/outfit/admin/peoples_station_crew
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	welcome_message = "As a crewmember of the People's Space Station, you must man your station and protect the People's Republic of Adhomai's and its allies' assets. \
	Your superior is the station's captain, but you should listen to the commissar in matters of ideology."

	assigned_role = "People's Space Station Crewmember"
	special_role = "People's Space Station Crewmember"
	extra_languages = list(LANGUAGE_SIIK_MAAS)
	respawn_flag = null

/obj/outfit/admin/peoples_station_crew
	name = "People's Space Station Crewmember"

	id = /obj/item/card/id
	shoes = /obj/item/clothing/shoes/jackboots/tajara

	uniform = /obj/item/clothing/under/tajaran/cosmonaut
	l_ear = /obj/item/device/radio/headset/ship

	belt = /obj/item/storage/belt/military

	accessory = /obj/item/clothing/accessory/badge/hadii_card
	r_pocket = /obj/item/storage/wallet/random

	l_hand = /obj/item/martial_manual/tajara

/obj/outfit/admin/peoples_station_crew/get_id_access()
	return list(ACCESS_PRA, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/peoples_station_crew/captain
	short_name = "peoples_station_captain"
	name = "People's Space Station Captain"
	desc = "Command the People's Space Station."
	tags = list("External")

	welcome_message = "As the captain of the People's Space Station, you must command the station in its mission of protecting the People's Republic and its allies in space. \
	While the commissar is not your superior, you should listen to his advice."

	spawnpoints = list("peoples_station_captain")
	max_count = 1
	uses_species_whitelist = TRUE

	outfit = /obj/outfit/admin/peoples_station_crew/captain
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "People's Space Station Captain"
	special_role = "People's Space Station Captain"

/obj/outfit/admin/peoples_station_crew/captain
	name = "People's Space Station Captain"

	head = /obj/item/clothing/head/tajaran/orbital_captain
	uniform = /obj/item/clothing/under/tajaran/cosmonaut/captain
	accessory = /obj/item/clothing/accessory/hadii_pin
	belt = /obj/item/storage/belt/military
	belt_contents = list(
						/obj/item/ammo_magazine/mc9mm = 1,
						/obj/item/gun/projectile/pistol/adhomai = 1
						)
	l_hand = /obj/item/clothing/accessory/badge/hadii_card/member
	r_hand = /obj/item/martial_manual/tajara


/datum/ghostspawner/human/peoples_station_crew/commissar
	short_name = "peoples_station_commissar"
	name = "People's Space Station Party Commissar"
	desc = "Ensure that the People's Space Station's crew follow the principles of Hadiism."

	welcome_message = "As the Party Commissar of the People's Space Station, you must advice the crew on ideological matters and how to behave in the Hadiist way. \
	While the captain is not your superior, you should listen to his advice on matters related to tactics."

	max_count = 1
	spawnpoints = list("peoples_station_commissar")

	assigned_role = "Party Commissar"
	special_role = "Party Commissar"
	uses_species_whitelist = TRUE

	outfit = /obj/outfit/admin/peoples_station_crew/commissar
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)

/obj/outfit/admin/peoples_station_crew/commissar
	name = "Party Commissar"

	uniform = /obj/item/clothing/under/tajaran/cosmonaut/commissar
	head = /obj/item/clothing/head/tajaran/cosmonaut_commissar
	accessory = /obj/item/clothing/accessory/hadii_pin
	belt = /obj/item/gun/projectile/deagle/adhomai
	belt_contents = null
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
						/obj/item/ammo_magazine/a50 = 2,
						/obj/item/material/knife/trench = 1,
						/obj/item/clothing/accessory/badge/hadii_card/member = 1,
						/obj/item/storage/box/hadii_manifesto = 1,
						/obj/item/storage/box/hadii_card = 1
						)
	l_hand = /obj/item/device/megaphone
	r_hand = /obj/item/martial_manual/tajara
