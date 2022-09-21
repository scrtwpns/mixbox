# ==========================================================
#  MIXBOX 2.0 (c) 2022 Secret Weapons. All rights reserved.
#  License: Creative Commons Attribution-NonCommercial 4.0
#  Authors: Sarka Sochorova and Ondrej Jamriska
# ==========================================================
#
#   BASIC USAGE
#
#      var color_mix = Mixbox.lerp(color1, color2, t)
#
#   MULTI-COLOR MIXING
#
#      var z1 = Mixbox.rgb_to_latent(color1)
#      var z2 = Mixbox.rgb_to_latent(color2)
#      var z3 = Mixbox.rgb_to_latent(color3)
#
#      var z_mix = []
#      z_mix.resize(Mixbox.LATENT_SIZE)
#
#      for i in z_mix.size():          # mix together:
#          z_mix[i] = (0.3*z1[i] +     # 30% of color1
#                      0.6*z2[i] +     # 60% of color2
#                      0.1*z3[i])      # 10% of color3
#
#      var color_mix = Mixbox.latent_to_rgb(z_mix)
#
#   PIGMENT COLORS
#
#      Cadmium Yellow              0.996, 0.925, 0.000
#      Hansa Yellow                0.988, 0.827, 0.000
#      Cadmium Orange              1.000, 0.412, 0.000
#      Cadmium Red                 1.000, 0.153, 0.008
#      Quinacridone Magenta        0.502, 0.008, 0.180
#      Cobalt Violet               0.306, 0.000, 0.259
#      Ultramarine Blue            0.098, 0.000, 0.349
#      Cobalt Blue                 0.000, 0.129, 0.522
#      Phthalo Blue                0.051, 0.106, 0.267
#      Phthalo Green               0.000, 0.235, 0.196
#      Permanent Green             0.027, 0.427, 0.086
#      Sap Green                   0.420, 0.580, 0.016
#      Burnt Sienna                0.482, 0.282, 0.000
#
#   LICENSING
#
#      If you want to obtain commercial license, please
#      contact us at: mixbox@scrtwpns.com
#

const lut = preload("mixbox.res").__data__

const LATENT_SIZE = 7

static func clamp01(value : float) -> float:
	return clamp(value, 0.0, 1.0)

static func eval_polynomial(c0 : float, c1 : float, c2 : float, c3 : float) -> Color:
	var r = 0.0
	var g = 0.0
	var b = 0.0

	var c00 = c0 * c0
	var c11 = c1 * c1
	var c22 = c2 * c2
	var c33 = c3 * c3
	var c01 = c0 * c1
	var c02 = c0 * c2
	var c12 = c1 * c2

	var w = 0.0
	w = c0*c00; r += +0.07717053*w; g += +0.02826978*w; b += +0.24832992*w;
	w = c1*c11; r += +0.95912302*w; g += +0.80256528*w; b += +0.03561839*w;
	w = c2*c22; r += +0.74683774*w; g += +0.04868586*w; b += +0.00000000*w;
	w = c3*c33; r += +0.99518138*w; g += +0.99978149*w; b += +0.99704802*w;
	w = c00*c1; r += +0.04819146*w; g += +0.83363781*w; b += +0.32515377*w;
	w = c01*c1; r += -0.68146950*w; g += +1.46107803*w; b += +1.06980936*w;
	w = c00*c2; r += +0.27058419*w; g += -0.15324870*w; b += +1.98735057*w;
	w = c02*c2; r += +0.80478189*w; g += +0.67093710*w; b += +0.18424500*w;
	w = c00*c3; r += -0.35031003*w; g += +1.37855826*w; b += +3.68865000*w;
	w = c0*c33; r += +1.05128046*w; g += +1.97815239*w; b += +2.82989073*w;
	w = c11*c2; r += +3.21607125*w; g += +0.81270228*w; b += +1.03384539*w;
	w = c1*c22; r += +2.78893374*w; g += +0.41565549*w; b += -0.04487295*w;
	w = c11*c3; r += +3.02162577*w; g += +2.55374103*w; b += +0.32766114*w;
	w = c1*c33; r += +2.95124691*w; g += +2.81201112*w; b += +1.17578442*w;
	w = c22*c3; r += +2.82677043*w; g += +0.79933038*w; b += +1.81715262*w;
	w = c2*c33; r += +2.99691099*w; g += +1.22593053*w; b += +1.80653661*w;
	w = c01*c2; r += +1.87394106*w; g += +2.05027182*w; b += -0.29835996*w;
	w = c01*c3; r += +2.56609566*w; g += +7.03428198*w; b += +0.62575374*w;
	w = c02*c3; r += +4.08329484*w; g += -1.40408358*w; b += +2.14995522*w;
	w = c12*c3; r += +6.00078678*w; g += +2.55552042*w; b += +1.90739502*w;

	return Color(r, g, b)

static func rgb_to_latent(color : Color) -> Array:
	var r = clamp01(color.r)
	var g = clamp01(color.g)
	var b = clamp01(color.b)

	var x = r * 63.0
	var y = g * 63.0
	var z = b * 63.0

	var ix = int(x)
	var iy = int(y)
	var iz = int(z)

	var tx = x - ix
	var ty = y - iy
	var tz = z - iz

	var xyz = ix + iy*64 + iz*64*64

	var c0 = 0.0
	var c1 = 0.0
	var c2 = 0.0

	var w = 0.0
	w = (1.0-tx)*(1.0-ty)*(1.0-tz); c0 += w*lut[xyz+ 192]; c1 += w*lut[xyz+262336]; c2 += w*lut[xyz+524480];
	w = (    tx)*(1.0-ty)*(1.0-tz); c0 += w*lut[xyz+ 193]; c1 += w*lut[xyz+262337]; c2 += w*lut[xyz+524481];
	w = (1.0-tx)*(    ty)*(1.0-tz); c0 += w*lut[xyz+ 256]; c1 += w*lut[xyz+262400]; c2 += w*lut[xyz+524544];
	w = (    tx)*(    ty)*(1.0-tz); c0 += w*lut[xyz+ 257]; c1 += w*lut[xyz+262401]; c2 += w*lut[xyz+524545];
	w = (1.0-tx)*(1.0-ty)*(    tz); c0 += w*lut[xyz+4288]; c1 += w*lut[xyz+266432]; c2 += w*lut[xyz+528576];
	w = (    tx)*(1.0-ty)*(    tz); c0 += w*lut[xyz+4289]; c1 += w*lut[xyz+266433]; c2 += w*lut[xyz+528577];
	w = (1.0-tx)*(    ty)*(    tz); c0 += w*lut[xyz+4352]; c1 += w*lut[xyz+266496]; c2 += w*lut[xyz+528640];
	w = (    tx)*(    ty)*(    tz); c0 += w*lut[xyz+4353]; c1 += w*lut[xyz+266497]; c2 += w*lut[xyz+528641];

	c0 /= 255.0
	c1 /= 255.0
	c2 /= 255.0

	var c3 = 1.0 - (c0 + c1 + c2)

	var c00 = c0 * c0
	var c11 = c1 * c1
	var c22 = c2 * c2
	var c33 = c3 * c3
	var c01 = c0 * c1
	var c02 = c0 * c2
	var c12 = c1 * c2

	var rmix = 0.0
	var gmix = 0.0
	var bmix = 0.0

	w = c0*c00; rmix += +0.07717053*w; gmix += +0.02826978*w; bmix += +0.24832992*w;
	w = c1*c11; rmix += +0.95912302*w; gmix += +0.80256528*w; bmix += +0.03561839*w;
	w = c2*c22; rmix += +0.74683774*w; gmix += +0.04868586*w; bmix += +0.00000000*w;
	w = c3*c33; rmix += +0.99518138*w; gmix += +0.99978149*w; bmix += +0.99704802*w;
	w = c00*c1; rmix += +0.04819146*w; gmix += +0.83363781*w; bmix += +0.32515377*w;
	w = c01*c1; rmix += -0.68146950*w; gmix += +1.46107803*w; bmix += +1.06980936*w;
	w = c00*c2; rmix += +0.27058419*w; gmix += -0.15324870*w; bmix += +1.98735057*w;
	w = c02*c2; rmix += +0.80478189*w; gmix += +0.67093710*w; bmix += +0.18424500*w;
	w = c00*c3; rmix += -0.35031003*w; gmix += +1.37855826*w; bmix += +3.68865000*w;
	w = c0*c33; rmix += +1.05128046*w; gmix += +1.97815239*w; bmix += +2.82989073*w;
	w = c11*c2; rmix += +3.21607125*w; gmix += +0.81270228*w; bmix += +1.03384539*w;
	w = c1*c22; rmix += +2.78893374*w; gmix += +0.41565549*w; bmix += -0.04487295*w;
	w = c11*c3; rmix += +3.02162577*w; gmix += +2.55374103*w; bmix += +0.32766114*w;
	w = c1*c33; rmix += +2.95124691*w; gmix += +2.81201112*w; bmix += +1.17578442*w;
	w = c22*c3; rmix += +2.82677043*w; gmix += +0.79933038*w; bmix += +1.81715262*w;
	w = c2*c33; rmix += +2.99691099*w; gmix += +1.22593053*w; bmix += +1.80653661*w;
	w = c01*c2; rmix += +1.87394106*w; gmix += +2.05027182*w; bmix += -0.29835996*w;
	w = c01*c3; rmix += +2.56609566*w; gmix += +7.03428198*w; bmix += +0.62575374*w;
	w = c02*c3; rmix += +4.08329484*w; gmix += -1.40408358*w; bmix += +2.14995522*w;
	w = c12*c3; rmix += +6.00078678*w; gmix += +2.55552042*w; bmix += +1.90739502*w;

	return [
		c0,
		c1,
		c2,
		c3,
		r - rmix,
		g - gmix,
		b - bmix,
	]

static func latent_to_rgb(latent) -> Color:
	var rgb = eval_polynomial(latent[0], latent[1], latent[2], latent[3])
	return Color(
		clamp01(rgb.r + latent[4]),
		clamp01(rgb.g + latent[5]),
		clamp01(rgb.b + latent[6])
	);

static func lerp(color1 : Color, color2 : Color, t : float) -> Color:
	var latent1 = rgb_to_latent(color1)
	var latent2 = rgb_to_latent(color2)

	var latent_mix = []

	latent_mix.resize(LATENT_SIZE)

	for i in latent_mix.size():
		latent_mix[i] = (1.0-t)*latent1[i] + t*latent2[i]

	var color_mix = latent_to_rgb(latent_mix)

	color_mix.a = (1.0-t)*color1.a + t*color2.a

	return color_mix
