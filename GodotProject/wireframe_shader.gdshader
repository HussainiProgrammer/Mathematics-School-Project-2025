shader_type spatial;
render_mode unshaded;

uniform vec4 color : source_color;

void fragment() {
    vec3 normalColor = abs(NORMAL);
    float edgeFactor = min(normalColor.r, min(normalColor.g, normalColor.b));
    edgeFactor = smoothstep(0.0, 0.3, edgeFactor); // Adjust for edge thickness

    vec3 final_color = mix(color.rgb, vec3(0.0), edgeFactor); // Darker edges
    ALBEDO = final_color;
}
