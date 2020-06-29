-- Kizrak

-- prototypes\derpy-cluster-artillery-ammo.lua

local sb = serpent.block -- luacheck: ignore 211

---------------------------------------------------------------------------------------------------

local clusterResearch = table.deepcopy(data.raw.technology["military-4"])

clusterResearch.name = "derpy-cluster-artillery-research"
clusterResearch.prerequisites = {"military-4","derpy-artillery"}

clusterResearch.effects = {{
	recipe = "derpy-cluster-artillery-ammo",
	type = "unlock-recipe"
}}

clusterResearch.icon = "__lightArtillery__/graphics/cluster-ammo.png"

clusterResearch.unit.count = 5
clusterResearch.unit.time = 5

log(sb( clusterResearch ))
data:extend{clusterResearch}

---------------------------------------------------------------------------------------------------

-- the recicpe to craft the item
local derpyArtilleryShellRecipe = table.deepcopy(data.raw.recipe["artillery-shell"])

derpyArtilleryShellRecipe.name = "derpy-cluster-artillery-ammo"
derpyArtilleryShellRecipe.result = "derpy-cluster-artillery-ammo"
derpyArtilleryShellRecipe.ingredients = {
	{"derpy-artillery-ammo", 6},
	{"advanced-circuit", 1},
	{"explosives", 1},
	{type="fluid", name="lubricant", amount=5}
}
derpyArtilleryShellRecipe.category = "advanced-crafting"
derpyArtilleryShellRecipe.energy_required = 20

data:extend{derpyArtilleryShellRecipe}

---------------------------------------------------------------------------------------------------

-- item the player carries
local derpyArtilleryAmmo = table.deepcopy(data.raw["ammo"]["artillery-shell"])

derpyArtilleryAmmo.name = "derpy-cluster-artillery-ammo"
derpyArtilleryAmmo.ammo_type.action.action_delivery.projectile="derpy-cluster-artillery-projectile-1"
derpyArtilleryAmmo.stack_size = 20

data:extend{derpyArtilleryAmmo}

---------------------------------------------------------------------------------------------------

-- thing that flies through air and does damage
local derpyArtilleryProjectile = table.deepcopy(data.raw["artillery-projectile"]["artillery-projectile"])

derpyArtilleryProjectile.name = "derpy-cluster-artillery-projectile-1"

local target_effects = derpyArtilleryProjectile.final_action.action_delivery.target_effects

target_effects[2].repeat_count = 11

table.insert(target_effects,{
	entity_name = "big-artillery-explosion",
	type = "create-entity"
})

derpyArtilleryProjectile.action = {
	{
		type = "cluster",
		cluster_count = 11,
		distance = 10,
		distance_deviation = 15,
		action_delivery =
		{
			type = "projectile",
			projectile = "cluster-projectile-2", -- not grenade
			direction_deviation = 0.6,
			starting_speed = 0.25,
			starting_speed_deviation = 0.3,
		}
	},
	{
		type = "area",
		radius = 2.5,
		action_delivery =
		{
			type = "instant",
			target_effects =
			{
				{
					type = "damage",
					damage = {amount = 35, type = "explosion"}
				}
			}
		}
	}
}

log(sb( derpyArtilleryProjectile ))
data:extend{derpyArtilleryProjectile}

---------------------------------------------------------------------------------------------------

local derpyClusterArtilleryProjectile =
	{
		type = "projectile",
		name = "cluster-projectile-2",
		flags = {"not-on-map"},
		acceleration = 0.005,
		action =
		{
			{
				type = "cluster",
				cluster_count = 11,
				distance = 10,
				distance_deviation = 15,
				action_delivery =
				{
					type = "projectile",
					projectile = "cluster-artillery-pellet-3",
					direction_deviation = 0.6,
					starting_speed = 0.25,
					starting_speed_deviation = 0.3,
					max_range = 20,
				}
			}
		},
		light = {intensity = 0.5, size = 4},
		animation =
		{
			filename = "__base__/graphics/entity/artillery-projectile/hr-shell.png",
			width = 64,
			height = 64,
			scale = 0.5
		},
		shadow =
		{
			filename = "__base__/graphics/entity/artillery-projectile/hr-shell-shadow.png",
			width = 64,
			height = 64,
			scale = 0.5
		},
	}

log(sb( derpyClusterArtilleryProjectile ))
data:extend{derpyClusterArtilleryProjectile}

---------------------------------------------------------------------------------------------------

local derpyClusterArtilleryPellet =
	{
		type = "projectile",
		name = "cluster-artillery-pellet-3",
		direction_only = true,
		flags = {"not-on-map"},
		acceleration = 0.005,
		action =
		{
			{
				type = "area",
				radius = 2.5,
				action_delivery =
				{
					type = "instant",
					target_effects =
					{
						{
							type = "damage",
							damage = {amount = 6, type = "impact"}
						},
						{
							type = "create-entity",
							entity_name = "explosion"
						}
					}
				}
			}
		},
		light = {intensity = 0.5, size = 4},
		animation =
		{
			filename = "__base__/graphics/entity/bullet/bullet.png",
			frame_count = 1,
			width = 3,
			height = 50,
			priority = "high"
		},
	}

log(sb( derpyClusterArtilleryPellet ))
data:extend{derpyClusterArtilleryPellet}

---------------------------------------------------------------------------------------------------

