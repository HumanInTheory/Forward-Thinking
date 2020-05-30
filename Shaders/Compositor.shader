shader_type canvas_item;

uniform vec2 viewportSize = vec2(192., 108.);
uniform vec4 worldModulate : hint_color;
uniform vec4 subworldModulate : hint_color;

uniform sampler2D portalMask;
uniform sampler2D worldView;
uniform sampler2D subworldView;

bool onMaskOutline(vec2 uv) {
	vec2 pixelSize = vec2(1.)/viewportSize;
	bool outline =
		texture(portalMask, uv + vec2(1.,0.) * pixelSize).a > 0.5
		|| texture(portalMask, uv + vec2(-1.,0.) * pixelSize).a > 0.5
		|| texture(portalMask, uv + vec2(0.,1.) * pixelSize).a > 0.5
		|| texture(portalMask, uv + vec2(0.,-1.) * pixelSize).a > 0.5;
	return outline;
}

void fragment() {
	vec4 worldColor = texture(worldView, UV) * worldModulate;
	vec4 subworldColor = texture(subworldView, UV) * subworldModulate;
	vec4 mask = texture(portalMask, UV);
	
	vec4 color = mix(worldColor, subworldColor, mask.a > 0.5 ? 1. : 0.);
	if(mask.a < 0.5 && onMaskOutline(UV)) color = vec4(1.);
	
	COLOR = color;
}