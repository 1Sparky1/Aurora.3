#define DEFAULT_MAX_RUNES   25
#define KNOWN_RUNES cult.cult_runes.len //The number of runes the cult currently has unlocked
#define CAN_KNOW_RUNES 1 + cult.get_cult_size() //The current cap of how many runes the cult can know

#define RUNE_LEVEL_LOW list(1, 2, 3, 4) //Rune levels which you can hypothetically know infinite of.
#define RUNE_LEVEL_MED list(5, 6, 7) //Rune levels which you can only know three of.
#define RUNE_LEVEL_HIGH list(8, 9, 10) //Rune levels which you can only know one of.

/var/datum/controller/subsystem/cult/SScult

/datum/controller/subsystem/cult
	name = "Cult"
	flags = SS_NO_FIRE

	var/list/domains_by_name  = list()

	var/list/runes_by_name  = list()
	var/list/rune_list      = list()

	var/list/teleport_runes = list()
	var/list/static/teleport_network = list("Vernuth", "Koglan", "Irgros", "Akon")

	var/rune_limit          = DEFAULT_MAX_RUNES //in the SS so admins can easily modify it if needed
	var/rune_boost          = 0
	var/tome_data           = ""

	var/list/hellhound_names = list("Demonclaw",
                                    "Bloodfang",
                                    "Archteeth",
                                    "Scornsable",
                                    "Badfang",
                                    "Mokk",
                                    "Dor",
                                    "Kraan",
                                    "Bekrus",
                                    "Bez"
                                    )

/datum/controller/subsystem/cult/New()
	NEW_SS_GLOBAL(SScult)

/datum/controller/subsystem/cult/Initialize()
	. = ..()
	for(var/rune in subtypesof(/datum/rune))
		var/datum/rune/R = new rune
		runes_by_name[R.name] = rune
		tome_data += "<div class='rune-block'>"
		tome_data += "<b>[capitalize_first_letters(R.name)]</b>: <i>[R.desc]</i><br>"
		tome_data += "This rune <b><i>[R.can_be_talisman() ? "can" : "cannot"]</i></b> be turned into a talisman.<br>"
		tome_data += "This rune <b><i>[R.can_memorize() ? "can" : "cannot"]</i></b> be memorized to be scribed without a tome.<br><hr>"
		tome_data += "</div>"
	for(var/domain in subtypesof(/datum/domain))
		var/datum/domain/D = new domain
		domains_by_name[D.name] = domain

/datum/controller/subsystem/cult/proc/add_rune(var/datum/rune/R)
	if(check_rune_limit())
		return FALSE
	else
		rune_list += R
		return TRUE

/datum/controller/subsystem/cult/proc/check_rune_limit()
	return ((length(rune_list) + rune_boost + length(cult.current_antagonists)) >= rune_limit)

/datum/controller/subsystem/cult/proc/remove_rune(var/datum/rune/R)
	if(R in rune_list)
		rune_list -= R
		return TRUE
	else
		return FALSE

/datum/controller/subsystem/cult/proc/get_cult_runes_by_level(var/L = 1)
	. = list()
	for(var/datum/rune/R in cult.cult_runes)
		if(R.level == L)
			. += R

/datum/controller/subsystem/cult/proc/count_level(var/list/level)
	var/count = 0
	for(var/L in level)
		var/list/runes = get_cult_runes_by_level(L)
		count += runes.len
	return count

/datum/controller/subsystem/cult/proc/check_level_limit(var/list/level = list())
	var/count = count_level(level)
	var/test = level[1]
	if((test in RUNE_LEVEL_LOW) || ((test in RUNE_LEVEL_MED) && (count < 3)) || ((test in RUNE_LEVEL_HIGH) && !count))
		. = TRUE
	else
		. = FALSE