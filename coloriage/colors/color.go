package colors

import (
	"encoding/json"
	"errors"
	"fmt"
	"math"
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

func ToRGB(c Color) string {
	return fmt.Sprintf("%d,%d,%d", c.red, c.green, c.blue)
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

func Compose(color, bg Color, alpha1, alpha2 float32) CompositeColor {
	return CompositeColor{
		color,
		Blend(color, bg, alpha1),
		Blend(color, bg, alpha2),
	}
}

func RGBToHSV(color Color) (h, s, v float64) {
	r := float64(color.red) / 0xff
	g := float64(color.green) / 0xff
	b := float64(color.blue) / 0xff

	Cmax := max(r, g, b)
	Cmin := min(r, g, b)
	delta := Cmax - Cmin

	// Hue calculation:
	if delta == 0 {
		h = 0
	} else {
		switch Cmax {
		case r:
			h = 60 * (math.Mod((g-b)/delta, 6))
		case g:
			h = 60 * (((b - r) / delta) + 2)
		case b:
			h = 60 * (((r - g) / delta) + 4)
		}
		if h < 0 {
			h += 360
		}

	}
	// Saturation calculation:
	if Cmax == 0 {
		s = 0
	} else {
		s = delta / Cmax
	}
	// Value calculation:
	v = Cmax

	return h, s, v
}

func HSVToRGB(h, s, v float64) (color Color, err error) {
	if h < 0 || h >= 360 ||
		s < 0 || s > 1 ||
		v < 0 || v > 1 {
		return Color{}, errors.New("colors: inputs out of range")
	}
	// When 0 ≤ h < 360, 0 ≤ s ≤ 1 and 0 ≤ v ≤ 1:
	C := v * s
	X := C * (1 - math.Abs(math.Mod(h/60, 2)-1))
	m := v - C
	var r, g, b float64
	switch {
	case 0 <= h && h < 60:
		r, g, b = C, X, 0
	case 60 <= h && h < 120:
		r, g, b = X, C, 0
	case 120 <= h && h < 180:
		r, g, b = 0, C, X
	case 180 <= h && h < 240:
		r, g, b = 0, X, C
	case 240 <= h && h < 300:
		r, g, b = X, 0, C
	case 300 <= h && h < 360:
		r, g, b = C, 0, X
	}
	color.red = uint8(math.Round((r + m) * 0xff))
	color.green = uint8(math.Round((g + m) * 0xff))
	color.blue = uint8(math.Round((b + m) * 0xff))
	color.alpha = 0xff
	return color, nil
}

func Fan(color Color) CompositeColor {
	var h, s, v = RGBToHSV(color)
	dim, _ := HSVToRGB(h, s, v*0.92)
	dimer, _ := HSVToRGB(h, s, v*0.86)
	return CompositeColor{color, dim, dimer}
}
