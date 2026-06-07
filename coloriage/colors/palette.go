package colors

type Foreground struct {
	Base   Color
	Dim    Color
	Dimmer Color
}

type Background struct {
	Dark   Color
	Base   Color
	Dim    Color
	Dimmer Color
	Border Color
}

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

	Fg  Foreground
	Bg  Background
	Sel Sel
}

type Theme struct {
	Light Palette
	Dark  Palette
}
