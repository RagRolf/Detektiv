shader_type canvas_item;

uniform sampler2D MASK_TEXTURE;  // Declare the mask texture uniform

void fragment() {
    vec4 color = texture(TEXTURE, UV);  // Sample the main texture
    vec4 mask_color = texture(MASK_TEXTURE, UV);  // Sample the mask texture
    color.a *= mask_color.r;  // Use red channel of mask for alpha masking
    COLOR = color;  // Set the final fragment color
}
