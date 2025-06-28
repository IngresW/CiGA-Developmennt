# CiGA-Developmennt

1、修改时间流速：res://Scripts/time_ui.gd
	max_time 为单轮时间
	current_time为当前时间
	如需修改可以一并修改，每回合结束时，current_time被赋值为max_time
	
2、修改地图：res://Scripts/grid.gd
	第25行：var map为地图，修改地图大小（20*20）需要一并修改上方宽高，且必定出现显示错误，不建议改

3、修改地块间影响权重：res://Scripts/gridcell.gd
	第20行：Tile_React_Weights 为影响权重，其中横纵坐标i，j分别表示：
		i号地块被j号地块影响时，j号地块对i号地块的影响权重

4、修改地块间影响规则：res://Scripts/gridcell.gd
	第32行：Tile_React_Rules 为影响结果，其中横纵坐标i，j分别表示：
		i号地块被j号地块影响后，会变为[i][j]号地块

5、修改元素与地块影响规则：res://Scripts/gridcell.gd
	第60行：func element_react(elementID: int)函数后会修改地块，两层match分别代表：
		第一层match为地块判断，即要对第i类地块进行元素交互
		第二层match为元素判断，即使用第j类元素进行反应，（0地、1火、2水、3风、4冰），本项目所有元素Id都是前面这5个数字
		结果在第二次match中得出
