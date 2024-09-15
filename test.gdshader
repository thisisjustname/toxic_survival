shader_type canvas_item;

group_uniforms noise_uniforms;
uniform sampler2D lightning_noise : repeat_enable;
uniform sampler2D background_noise : repeat_enable;
group_uniforms;

group_uniforms color_uniforms;
uniform sampler2D color_gradient;
uniform bool use_color_gradient = false;
uniform float color_effect_mod : hint_range(0.0, 3.0, 0.05) = 0.5;
group_uniforms;

uniform float intensive : hint_range(0.0, 5.0, 0.05) = 1.5;
uniform float lightning_thin : hint_range(0.5, 10.0) = 5.0;
uniform int number_lightning = 4;
uniform float speed = 1.0;
uniform float border_thickness : hint_range(0.0, 0.5) = 0.2;
uniform float outside_extend : hint_range(0.0, 0.2) = 0.05;
uniform vec4 lightning_color : source_color = vec4(0.2, 0.4, 1.0, 1.0);

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float create_border(vec2 uv) {
    vec2 border_dist = abs(uv - 0.5);
    float border = max(border_dist.x, border_dist.y);
    float inner_edge = smoothstep(0.5 - border_thickness - outside_extend, 0.5 - outside_extend, border);
    float outer_edge = smoothstep(0.5 - outside_extend, 0.5, border);
    return inner_edge - outer_edge;
}

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    vec4 old_color = lightning_color;
    if (use_color_gradient) {
        old_color = texture(color_gradient, UV);
    }

    vec4 lightning_effect = vec4(0.0);
    float time = TIME * speed;
    float border = create_border(UV);

    for (int i = 0; i < number_lightning; i++){
        float angle = random(vec2(time + float(i))) * 6.28318; // Random angle
        vec2 dir = vec2(cos(angle), sin(angle)); // Direction vector

        vec2 noise_coords = vec2(
            dot(UV - 0.5, dir) * 4.0 + time * 0.4 * (0.5 + fract(sin(float(i) * 50.0))),
            0.5
        );

        vec2 offset = (texture(lightning_noise, noise_coords).rg - vec2(0.5)) * intensive * 0.1;
        vec2 uv_off = UV + offset;

        float dist = abs(dot(uv_off - 0.5, dir)) * lightning_thin;

        float color_lower_bound = 0.1 + 0.5 * (float(i) - 0.5);
        float color_mod = smoothstep(color_lower_bound, 1.0, texture(background_noise, uv_off).x);

        vec4 new_color = old_color * color_mod / (dist + 0.1); // Prevent division by zero
        new_color *= texture(background_noise, uv_off + vec2(time * 0.1)).r;

        lightning_effect += new_color * border;
    }

    lightning_effect = clamp(lightning_effect, 0.0, 1.0);
    lightning_effect.a *= border * intensive;
    COLOR = mix(texture_color, lightning_effect, lightning_effect.a);
}