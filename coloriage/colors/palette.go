package colors

type Palette struct {
	Black   CompositeColor
	Blue    CompositeColor
	Cyan    CompositeColor
	Green   CompositeColor
	Magenta CompositeColor
	Red     CompositeColor
	White   CompositeColor
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
