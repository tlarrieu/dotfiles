package colors

type Sel struct {
	Base Color
	Dim  Color
}

type Palette struct {
	Black   CompositeColor
	Blue    CompositeColor
	Cyan    CompositeColor
	Green   CompositeColor
	Magenta CompositeColor
	Orange  CompositeColor
	Pink    CompositeColor
	Red     CompositeColor
	White   CompositeColor
	Yellow  CompositeColor

	Accent CompositeColor

	Fg  CompositeColor
	Bg  CompositeColor
	Sel Sel
}

type Theme struct {
	Light Palette
	Dark  Palette
}
