/*

	Tents

*/

/datum/large_structure/tent
	stages = list("poles" = STAGE_DISASSEMBLED,
				"canvas" = STAGE_DISASSEMBLED,
				"guy lines" = STAGE_DISASSEMBLED,
				"pegs" = STAGE_DISASSEMBLED)
	component_structure = /obj/structure/component/tent_canvas
	source_item_type = /obj/item/tent

/datum/large_structure/tent/assemble()
	if(..())
		for(var/obj/structure/component/tent_canvas/C in grouped_structures)
			if(dir & (NORTH | SOUTH))
				if(C.x == x1)
					C.icon_state = "canvas_dir"
					C.dir = WEST
				else if(C.x == x2)
					C.icon_state = "canvas_dir"
					C.dir = EAST
			else
				if(C.y == y1)
					C.icon_state = "canvas_dir"
					C.dir = NORTH
				else if(C.y == y2)
					C.icon_state = "canvas_dir"
					C.dir = SOUTH
			var/image/I = overlay_image(C.icon, "[C.icon_state]_shadow")
			C.AddOverlays(I)

/obj/item/tent
	name = "expedition tent"
	desc = "A rolled up tent, ready to be assembled to make a base camp, shelter, or just a cozy place to chat."
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "tent"
	item_state = "tent"
	contained_sprite = TRUE
	w_class = ITEMSIZE_LARGE
	color = "#58a178"
	var/width = 2
	var/length = 3

	var/datum/large_structure/tent/my_tent

/obj/item/tent/Initialize()
	. = ..()
	w_class = min(ceil(width * length / 1.5), ITEMSIZE_IMMENSE) // 2x2 = ITEMSIZE_NORMAL
	desc += "\nThis one is [width] x [length] in size."

/obj/item/tent/Move()
	if(my_tent) //Delete the structure datum if we're moved
		qdel(my_tent)
		my_tent = null
	. = ..()

/obj/item/tent/afterattack(obj/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	var/turf/T = target
	if(istype(T))
		deploy_tent(T, user)

/obj/item/tent/attack_self(mob/user)
	. = ..()
	var/turf/T = get_turf(user)
	if(istype(T))
		deploy_tent(T, user)

/obj/item/tent/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(use_check(usr) || !Adjacent(usr))
		return
	var/turf/T = get_turf(src)
	if(istype(T))
		deploy_tent(T, usr)

/obj/item/tent/proc/deploy_tent(var/turf/target, var/mob/user)

	if(my_tent)
		my_tent.assemble(1 SECOND, user)
		return

	var/deploy_dir = get_compass_dir(user,target)
	if(target == get_turf(user))
		deploy_dir = user.dir

	my_tent = new /datum/large_structure/tent(src)
	my_tent.name = name
	my_tent.color = color
	my_tent.source_item = src
	my_tent.dir = deploy_dir
	my_tent.z1 = target.z
	my_tent.z2 = target.z
	my_tent.source_item_type = type

	if(deploy_dir & NORTH)
		my_tent.x1 = target.x - floor((width-1)/2)
		my_tent.x2 = target.x + ceil((width-1)/2)
		my_tent.y1 = target.y
		my_tent.y2 = target.y + (length-1)
	else if(deploy_dir & SOUTH)
		my_tent.x1 = target.x - ceil((width-1)/2)
		my_tent.x2 = target.x + floor((width-1)/2)
		my_tent.y1 = target.y
		my_tent.y2 = target.y - (length-1)
	else if(deploy_dir & EAST)
		my_tent.x1 = target.x
		my_tent.x2 = target.x + (length-1)
		my_tent.y1 = target.y + floor((width-1)/2)
		my_tent.y2 = target.y - ceil((width-1)/2)
	else
		my_tent.x1 = target.x
		my_tent.x2 = target.x - (length-1)
		my_tent.y1 = target.y + ceil((width-1)/2)
		my_tent.y2 = target.y - floor((width-1)/2)

	my_tent.assemble(1 SECOND, user)

/obj/item/tent/big
	name = "basecamp tent"
	color = "#2e3763"
	width = 3
	length = 4

/obj/structure/component/tent_canvas
	name = "tent canvas"
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "canvas"
	item_state = "canvas"
	anchored = TRUE
	density = TRUE
	atom_flags = ATOM_FLAG_CHECKS_BORDER
	atmos_canpass = CANPASS_ALWAYS //Tents are not air tight
	layer = ABOVE_HUMAN_LAYER

/obj/structure/component/tent_canvas/CanPass(atom/movable/mover, turf/target, height, air_group)
	. = ..()
	if(icon_state == "canvas")
		return TRUE	//Non-directional, always allow passage
	if(get_dir(loc, target) & dir)
		return !density
	return TRUE

/obj/structure/component/tent_canvas/CheckExit(atom/movable/O, turf/target)
	. = ..()
	if(icon_state == "canvas")
		return TRUE	//Non-directional, always allow passage
	if(get_dir(O.loc, target) & dir)
		return !density
	return TRUE

/obj/structure/component/tent_canvas/MouseDrop(over_object, src_location, over_location)
	..()
	if(use_check(usr) || !Adjacent(usr))
		return
	part_of.disassemble(2 SECONDS, usr, src)

/*
	Sleeping bags
*/
/obj/item/sleeping_bag
	name = "sleeping bag"
	desc = "A rolled up sleeping bag, ready to be taken on a camping trip."
	desc_extended = "This item can be attached to a backpack."
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "sleepingbag"
	item_state = "sleepingbag"
	contained_sprite = TRUE
	w_class = ITEMSIZE_LARGE

/obj/item/sleeping_bag/Initialize(mapload, ...)
	. = ..()
	color = pick(COLOR_NAVY_BLUE, COLOR_GREEN, COLOR_MAROON, COLOR_VIOLET, COLOR_OLIVE, COLOR_SEDONA)

/obj/item/sleeping_bag/afterattack(obj/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	var/turf/T = target
	if(istype(T))
		unroll(T, user)

/obj/item/sleeping_bag/attack_self(mob/user)
	. = ..()
	var/turf/T = get_turf(user)
	if(istype(T))
		unroll(T, user)

/obj/item/sleeping_bag/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(use_check(usr) || !Adjacent(usr))
		return
	var/turf/T = get_turf(src)
	if(istype(T))
		unroll(T, usr)

/obj/item/sleeping_bag/proc/unroll(var/turf/T, var/mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] unrolls \the [src]."))
	var/obj/structure/bed/sleeping_bag/S = new /obj/structure/bed/sleeping_bag(T, MATERIAL_CLOTH)
	S.color = color
	qdel(src)

/obj/structure/bed/sleeping_bag
	name = "sleeping bag"
	desc = "A bag for sleeping in. Great for trying to pretend you're somewhere more comfortable than you really are."
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "sleepingbag_floor"
	base_icon = "sleepingbag_floor"
	density = FALSE
	anchored = FALSE
	buckling_sound = 'sound/items/drop/cloth.ogg'
	held_item = /obj/item/sleeping_bag
	can_dismantle = FALSE
	can_pad = FALSE

/obj/structure/bed/sleeping_bag/update_icon()
	return

/obj/structure/bed/sleeping_bag/buckle(mob/living/M)
	. = ..()
	var/image/I = overlay_image(icon, "[base_icon]_top", color)
	M.AddOverlays(I)

/obj/structure/bed/sleeping_bag/unbuckle()
	if(buckled)
		buckled.update_icon()
	. = ..()

/obj/structure/bed/sleeping_bag/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(use_check(usr) || !Adjacent(usr))
		return
	if(!ishuman(usr) && (!isrobot(usr) || isDrone(usr))) //Humans and borgs can roll, but not drones
		return
	if(buckled)
		to_chat(usr, SPAN_WARNING("You can't roll up \the [src] while someone is sleeping inside."))
		return
	var/obj/item/sleeping_bag/S = new held_item(get_turf(src))
	S.color = color
	usr.visible_message(SPAN_NOTICE("\The [usr] rolls up \the [src]."))
	qdel(src)
