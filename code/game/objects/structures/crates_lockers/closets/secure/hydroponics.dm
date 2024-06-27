/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(ACCESS_HYDROPONICS)
	icon_state = "hydro"

/obj/structure/closet/secure_closet/hydroponics/fill()
	..()
	switch(rand(1,2))
		if(1)
			new /obj/item/clothing/accessory/apron/blue(src)
		if(2)
			new /obj/item/clothing/accessory/overalls/blue(src)
	new /obj/item/storage/bag/plants(src)
	new /obj/item/clothing/under/rank/hydroponics(src)
	new /obj/item/device/analyzer/plant_analyzer(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/clothing/head/bandana/hydro(src)
	new /obj/item/material/minihoe(src)
	new /obj/item/material/hatchet(src)
	new /obj/item/wirecutters/clippers(src)
	new /obj/item/reagent_containers/spray/plantbgone(src)
	new /obj/item/storage/belt/hydro(src)

/obj/structure/closet/secure_closet/xenobotany
	name = "xenobotanist's locker"
	req_access = list(ACCESS_XENOBOTANY)
	icon_state = "xenobot"

/obj/structure/closet/secure_closet/xenobotany/fill()
	..()
	switch(rand(1,2))
		if(1)
			new /obj/item/clothing/accessory/apron/blue(src)
		if(2)
			new /obj/item/clothing/accessory/overalls/blue(src)
	new /obj/item/clothing/under/rank/scientist/botany(src)
	new /obj/item/storage/bag/plants(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/device/analyzer/plant_analyzer(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/clothing/head/bandana/hydro(src)
	new /obj/item/material/minihoe(src)
	new /obj/item/material/hatchet(src)
	new /obj/item/wirecutters/clippers(src)
	new /obj/item/reagent_containers/spray/plantbgone(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/watertank(src)
	new /obj/item/storage/belt/hydro(src)
	new /obj/item/clothing/gloves/botanic_leather(src)
	new /obj/item/sampler(src)
