#define JOULES2RENWICKS(X) X / 75 //Much lower than the old conversion rate, but shields are MUCH more renwick hungry now
#define RENWICKS2JOULES(X) X * 75

#define SHIELD_DISCHARGE_RATE 0.1
#define SHIELD_DISCHARGE_MINIMUM 0.1
#define SHIELD_STRENGTH_MAX 80

#define MODEFLAG_HYPERKINETIC BITFLAG(1)
#define MODEFLAG_PHOTONIC BITFLAG(2)
#define MODEFLAG_HUMANOIDS BITFLAG(3)
#define MODEFLAG_INORGANIC BITFLAG(4)
#define MODEFLAG_NONHUMANS BITFLAG(5)
#define MODEFLAG_ATMOSPHERIC BITFLAG(6)
#define MODEFLAG_HULL BITFLAG(7)
#define MODEFLAG_MODULATE BITFLAG(8)
#define MODEFLAG_OVERCHARGE BITFLAG(9)

#define ADAPTION_LASER_SUPER 1
#define ADAPTION_LASER_HIGH 2
#define ADAPTION_LASER_MEDIUM 3
#define ADAPTION_LASER_LOW 4
#define ADAPTION_NEUTRAL 5
#define ADAPTION_BALLISTIC_LOW 6
#define ADAPTION_BALLISTIC_MEDIUM 7
#define ADAPTION_BALLISTIC_HIGH 8
#define ADAPTION_BALLISTIC_SUPER 9

#define PROJ_DIR_ALL "Bubble"
#define PROJ_DIR_NORTH "Aft"
#define PROJ_DIR_EAST "Port"
#define PROJ_DIR_SOUTH "Fore"
#define PROJ_DIR_WEST "Starboard"

#define DEFAULT_SHIELD_COLOR "#28cfd5"
