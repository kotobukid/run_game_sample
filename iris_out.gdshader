shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5); // ColorRectの中心を基準とする
uniform float radius : hint_range(0, 1.0) = 0.25; // ローカル座標系に合わせた範囲に調整

void fragment() {
	// ローカル座標系に基づく位置を取得
	vec2 screen_pos = UV; // UVを直接使用
	float dist = distance(screen_pos, center);
	if (dist > radius) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0); // 水色で塗りつぶす
	} else {
		discard; // 中心からradius以内は透明にする
	}
}
