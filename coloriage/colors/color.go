package colors

import (
	"encoding/json"
	"fmt"
)

type Color struct {
	red   uint8
	green uint8
	blue  uint8
	alpha uint8
}

func (color *Color) UnmarshalJSON(data []byte) (err error) {
	var hex string
	err = json.Unmarshal(data, &hex)

	if err == nil {
		*color, err = FromHex(hex)
	}

	return
}

func (c Color) String() string { return ToHex(c) }

func FromHex(s string) (c Color, err error) {
	c.alpha = 0xff
	switch len(s) {
	case 7:
		_, err = fmt.Sscanf(s, "#%02x%02x%02x", &c.red, &c.green, &c.blue)
	case 4:
		_, err = fmt.Sscanf(s, "#%1x%1x%1x", &c.red, &c.green, &c.blue)
		// Double the hex digits:
		c.red *= 17
		c.green *= 17
		c.blue *= 17
	default:
		err = fmt.Errorf("invalid length, must be 7 or 4")
	}
	return
}

func ToHex(c Color) string {
	if c.alpha != 0xff {
		return fmt.Sprintf("#%02x%02x%02x%02x", c.red, c.green, c.blue, c.alpha)
	} else {
		return fmt.Sprintf("#%02x%02x%02x", c.red, c.green, c.blue)
	}
}

func scale(x uint8) float32 {
	return float32(x) / 0xff
}

func blend(a, b uint8, f float32) uint8 {
	return uint8(((scale(a)-scale(b))*f + scale(b)) * 0xff)
}

func Blend(c1, c2 Color, f float32) Color {
	return Color{
		blend(c1.red, c2.red, f),
		blend(c1.green, c2.green, f),
		blend(c1.blue, c2.blue, f),
		c1.alpha,
	}
}

type CompositeColor struct {
	Base   Color
	Dim    Color
	Dimmer Color
}

func Compose(color, bg Color) CompositeColor {
	return CompositeColor{
		color,
		Blend(color, bg, 0.2),
		Blend(color, bg, 0.15),
	}
}
