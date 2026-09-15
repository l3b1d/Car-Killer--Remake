shader_type canvas_item;

// Повзунок у вкладці Inspector для керування розмиттям (від 0.0 до 5.0)
uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;

void fragment() {
    // Зчитуємо колір самої картинки через textureLod з увімкненим mipmap-фільтром
    COLOR = textureLod(TEXTURE, UV, blur_amount);
}
