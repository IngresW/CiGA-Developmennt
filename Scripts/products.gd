const PRODUCTS = [
	{
		"id": 0,
		"name": "黑曜石 (Obsidian)",
		"trigger": {"type": "tile_by_tile", "from": 3, "to": 0, "prob": 0.2},
		"score": 20,
		"cost": 5
	},
	{
		"id": 1,
		"name": "铁矿石 (Iron Ore)",
		"trigger": {"type": "tile_by_element", "tile": 6, "element": 0, "prob": 0.2},
		"score": 20,
		"cost": 5
	},
	{
		"id": 2,
		"name": "硫磺 (Sulfur)",
		"trigger": {"type": "tile_by_tile", "from": 0, "to": 2, "prob": 0.05},
		"score": 5,
		"cost": 0
	},
	{
		"id": 3,
		"name": "木炭 (Charcoal)",
		"trigger": {"type": "tile_by_tile", "from": 2, "to": 0, "prob": 0.05},
		"score": 5,
		"cost": 0
	},
	{
		"id": 4,
		"name": "玻璃 (Glass)",
		"trigger": {"type": "tile_by_tile", "from": 4, "to": 2, "prob": 0.05},
		"score": 10,
		"cost": 3
	},
	{
		"id": 5,
		"name": "蘑菇 (Mushroom)",
		"trigger": {"type": "tile_by_tile", "from": 2, "to": 3, "prob": 0.05},
		"score": 5,
		"cost": 0
	}
]
