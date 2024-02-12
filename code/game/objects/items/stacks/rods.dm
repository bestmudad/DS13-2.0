GLOBAL_LIST_INIT(rod_recipes, list ( \
	new/datum/stack_recipe("grille", /obj/structure/grille, 2, time = 10, one_per_turf = TRUE, on_floor = FALSE), \
	new/datum/stack_recipe("table frame", /obj/structure/table_frame, 2, time = 10, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("scooter frame", /obj/item/scooter_frame, 10, time = 25, one_per_turf = FALSE), \
	new/datum/stack_recipe("linen bin", /obj/structure/bedsheetbin/empty, 2, time = 5, one_per_turf = FALSE), \
	new/datum/stack_recipe("railing", /obj/structure/railing, 3, time = 18, window_checks = TRUE), \
	new/datum/stack_recipe("tank holder", /obj/structure/tank_holder, 2, time = 5, one_per_turf = TRUE, on_floor = FALSE), \
	new/datum/stack_recipe("ladder", /obj/structure/ladder/crafted, 15, time = 150, one_per_turf = TRUE, on_floor = FALSE), \
	new/datum/stack_recipe("catwalk floor tile", /obj/item/stack/tile/catwalk_tile, 1, 4, 20), \
	))

/obj/item/stack/rods
	name = "iron rod"
	desc = "Some rods. Can be used for building or something."
	singular_name = "iron rod"
	icon_state = "rods"
	inhand_icon_state = "rods"
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_NORMAL
	force = 9
	throwforce = 10
	throw_range = 7
	mats_per_unit = list(/datum/material/iron=1000)
	max_amount = 50
	attack_verb_continuous = list("hits", "bludgeons", "whacks")
	attack_verb_simple = list("hit", "bludgeon", "whack")
	hitsound = 'sound/weapons/gun/general/grenade_launch.ogg'
	embedding = list(embed_chance = 50)
	novariants = TRUE
	matter_amount = 2
	cost = 250
	source = /datum/robot_energy_storage/iron
	merge_type = /obj/item/stack/rods

/obj/item/stack/rods/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to stuff \the [src] down [user.p_their()] throat! It looks like [user.p_theyre()] trying to commit suicide!"))//it looks like theyre ur mum
	return BRUTELOSS

/obj/item/stack/rods/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	update_appearance()
	AddElement(/datum/element/openspace_item_click_handler)

/obj/item/stack/rods/handle_openspace_click(turf/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag)
		target.attackby(src, user, click_parameters)

/obj/item/stack/rods/get_main_recipes()
	. = ..()
	. += GLOB.rod_recipes

/obj/item/stack/rods/update_icon_state()
	. = ..()
	var/amount = get_amount()
	if(amount <= 5)
		icon_state = "rods-[amount]"
	else
		icon_state = "rods"

/obj/item/stack/rods/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WELDER)
		if(get_amount() < 2)
			to_chat(user, span_warning("You need at least two rods to do this!"))
			return

		if(W.use_tool(src, user, 0, volume=40))
			var/obj/item/stack/sheet/iron/new_item = new(usr.loc)
			user.visible_message(span_notice("[user.name] shaped [src] into iron sheets with [W]."), \
				span_notice("You shape [src] into iron sheets with [W]."), \
				span_hear("You hear welding."))
			var/obj/item/stack/rods/R = src
			src = null
			var/replace = (user.get_inactive_held_item()==R)
			R.use(2)
			if (!R && replace)
				user.put_in_hands(new_item)
	else
		return ..()

/obj/item/stack/rods/cyborg/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_blocker)

/obj/item/stack/rods/two
	amount = 2

/obj/item/stack/rods/ten
	amount = 10

/obj/item/stack/rods/twentyfive
	amount = 25

/obj/item/stack/rods/fifty
	amount = 50

/obj/item/stack/rods/lava
	name = "heat resistant rod"
	desc = "Treated, specialized iron rods. When exposed to the vaccum of space their coating breaks off, but they can hold up against the extreme heat of active lava."
	singular_name = "heat resistant rod"
	icon_state = "rods"
	inhand_icon_state = "rods"
	color = "#5286b9ff"
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_NORMAL
	mats_per_unit = list(/datum/material/iron=1000, /datum/material/plasma=500, /datum/material/titanium=2000)
	max_amount = 30
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	merge_type = /obj/item/stack/rods/lava

/obj/item/stack/rods/lava/thirty
	amount = 30
