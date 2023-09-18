extends RichTextLabel

var points: int:
	get:
		return points
	set(val):
		points = val
		self.text = "Points: " + str(points)
