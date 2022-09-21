// ==========================================================
//  MIXBOX 2.0 (c) 2022 Secret Weapons. All rights reserved.
//  License: Creative Commons Attribution-NonCommercial 4.0
//  Authors: Sarka Sochorova and Ondrej Jamriska
// ==========================================================
//
//   BASIC USAGE
//
//      vec3 rgb = mixbox_lerp(rgb1, rgb2, t);
//
//   MULTI-COLOR MIXING
//
//      mat3 z1 = mixbox_rgb_to_latent(rgb1);
//      mat3 z2 = mixbox_rgb_to_latent(rgb2);
//      mat3 z3 = mixbox_rgb_to_latent(rgb3);
//
//      // mix 30% of rgb1, 60% of rgb2, and 10% of rgb3
//      mat3 z_mix = 0.3*z1 + 0.6*z2 + 0.1*z3;
//
//      vec3 rgb_mix = mixbox_latent_to_rgb(z_mix);
//
//   PIGMENT COLORS
//
//      Cadmium Yellow              0.996, 0.925, 0.000
//      Hansa Yellow                0.988, 0.827, 0.000
//      Cadmium Orange              1.000, 0.412, 0.000
//      Cadmium Red                 1.000, 0.153, 0.008
//      Quinacridone Magenta        0.502, 0.008, 0.180
//      Cobalt Violet               0.306, 0.000, 0.259
//      Ultramarine Blue            0.098, 0.000, 0.349
//      Cobalt Blue                 0.000, 0.129, 0.522
//      Phthalo Blue                0.051, 0.106, 0.267
//      Phthalo Green               0.000, 0.235, 0.196
//      Permanent Green             0.027, 0.427, 0.086
//      Sap Green                   0.420, 0.580, 0.016
//      Burnt Sienna                0.482, 0.282, 0.000
//
//   LICENSING
//
//      If you want to obtain commercial license, please
//      contact us at: mixbox@scrtwpns.com
//

vec3 _mixbox_eval_polynomial(vec3 _mixbox_c) {
	float _mixbox_c0 = _mixbox_c[0];
	float _mixbox_c1 = _mixbox_c[1];
	float _mixbox_c2 = _mixbox_c[2];
	float _mixbox_c3 = 1.0 - (_mixbox_c0 + _mixbox_c1 + _mixbox_c2);

	float _mixbox_c00 = _mixbox_c0 * _mixbox_c0;
	float _mixbox_c11 = _mixbox_c1 * _mixbox_c1;
	float _mixbox_c22 = _mixbox_c2 * _mixbox_c2;
	float _mixbox_c01 = _mixbox_c0 * _mixbox_c1;
	float _mixbox_c02 = _mixbox_c0 * _mixbox_c2;
	float _mixbox_c12 = _mixbox_c1 * _mixbox_c2;
	float _mixbox_c33 = _mixbox_c3 * _mixbox_c3;

	return (
		(_mixbox_c0 * _mixbox_c00) * vec3(+0.07717053, +0.02826978, +0.24832992) +
		(_mixbox_c1 * _mixbox_c11) * vec3(+0.95912302, +0.80256528, +0.03561839) +
		(_mixbox_c2 * _mixbox_c22) * vec3(+0.74683774, +0.04868586, +0.00000000) +
		(_mixbox_c3 * _mixbox_c33) * vec3(+0.99518138, +0.99978149, +0.99704802) +
		(_mixbox_c00 * _mixbox_c1) * vec3(+0.04819146, +0.83363781, +0.32515377) +
		(_mixbox_c01 * _mixbox_c1) * vec3(-0.68146950, +1.46107803, +1.06980936) +
		(_mixbox_c00 * _mixbox_c2) * vec3(+0.27058419, -0.15324870, +1.98735057) +
		(_mixbox_c02 * _mixbox_c2) * vec3(+0.80478189, +0.67093710, +0.18424500) +
		(_mixbox_c00 * _mixbox_c3) * vec3(-0.35031003, +1.37855826, +3.68865000) +
		(_mixbox_c0 * _mixbox_c33) * vec3(+1.05128046, +1.97815239, +2.82989073) +
		(_mixbox_c11 * _mixbox_c2) * vec3(+3.21607125, +0.81270228, +1.03384539) +
		(_mixbox_c1 * _mixbox_c22) * vec3(+2.78893374, +0.41565549, -0.04487295) +
		(_mixbox_c11 * _mixbox_c3) * vec3(+3.02162577, +2.55374103, +0.32766114) +
		(_mixbox_c1 * _mixbox_c33) * vec3(+2.95124691, +2.81201112, +1.17578442) +
		(_mixbox_c22 * _mixbox_c3) * vec3(+2.82677043, +0.79933038, +1.81715262) +
		(_mixbox_c2 * _mixbox_c33) * vec3(+2.99691099, +1.22593053, +1.80653661) +
		(_mixbox_c01 * _mixbox_c2) * vec3(+1.87394106, +2.05027182, -0.29835996) +
		(_mixbox_c01 * _mixbox_c3) * vec3(+2.56609566, +7.03428198, +0.62575374) +
		(_mixbox_c02 * _mixbox_c3) * vec3(+4.08329484, -1.40408358, +2.14995522) +
		(_mixbox_c12 * _mixbox_c3) * vec3(+6.00078678, +2.55552042, +1.90739502));
}

mat3 mixbox_rgb_to_latent(vec3 _mixbox_rgb) {
	_mixbox_rgb = clamp(_mixbox_rgb, 0.0, 1.0);

	float _mixbox_x = _mixbox_rgb.r * 63.0;
	float _mixbox_y = _mixbox_rgb.g * 63.0;
	float _mixbox_z = _mixbox_rgb.b * 63.0;

	float _mixbox_iz = floor(_mixbox_z);

	float _mixbox_x0 = mod(_mixbox_iz, 8.0) * 64.0;
	float _mixbox_y0 = floor(_mixbox_iz / 8.0) * 64.0;

	float _mixbox_x1 = mod(_mixbox_iz + 1.0, 8.0) * 64.0;
	float _mixbox_y1 = floor((_mixbox_iz + 1.0) / 8.0) * 64.0;

	vec2 _mixbox_uv0 = vec2(_mixbox_x0 + _mixbox_x + 0.5, _mixbox_y0 + _mixbox_y + 0.5) / 512.0;
	vec2 _mixbox_uv1 = vec2(_mixbox_x1 + _mixbox_x + 0.5, _mixbox_y1 + _mixbox_y + 0.5) / 512.0;

	vec3 _mixbox_c = mix(textureLod(mixbox_lut, _mixbox_uv0, 0.0).rgb, textureLod(mixbox_lut, _mixbox_uv1, 0.0).rgb, _mixbox_z - _mixbox_iz);

	return mat3(_mixbox_c, _mixbox_rgb - _mixbox_eval_polynomial(_mixbox_c), vec3(0.0));
}

vec3 mixbox_latent_to_rgb(mat3 _mixbox_latent) {
	return clamp(_mixbox_eval_polynomial(_mixbox_latent[0]) + _mixbox_latent[1], 0.0, 1.0);
}

vec4 mixbox_lerp(vec4 _mixbox_color1, vec4 _mixbox_color2, float _mixbox_t) {
	return vec4(mixbox_latent_to_rgb((1.0-_mixbox_t)*mixbox_rgb_to_latent(_mixbox_color1.rgb) + _mixbox_t*mixbox_rgb_to_latent(_mixbox_color2.rgb)), mix(_mixbox_color1.a, _mixbox_color2.a, _mixbox_t));
}
