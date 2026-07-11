package colors

type Palette struct {
	Blue    CompositeColor
	Cyan    CompositeColor
	Green   CompositeColor
	Magenta CompositeColor
	Red     CompositeColor
	Yellow  CompositeColor

	Accent CompositeColor

	Fg  CompositeColor
	Bg  CompositeColor
	Sel CompositeColor
}

type Theme struct {
	Light Palette
	Dark  Palette
}
