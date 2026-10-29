#!/usr/bin/env python3
"""Compose Google Play feature graphic — one background, clean layers."""

from __future__ import annotations

import math
from pathlib import Path

from collections import deque

from PIL import Image, ImageDraw, ImageFilter, ImageFont

TARGET_W, TARGET_H = 1024, 500

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent
SOURCE = ROOT / "store_assets" / "feature_graphic_source.png"
LOGO = REPO / "docs" / "assets" / "logo.png"
OUT_PNG = ROOT / "store_assets" / "feature_graphic.png"
OUT_JPG = ROOT / "store_assets" / "feature_graphic.jpg"

TAGLINE = (
    "Yordam toping va yordam bering: Xizmatlar bozori — barchasi YordamBor'da."
)

PHONE_CROP = (842, 41, 1408, 1024)
PHONE_MARGIN_TOP = 16
PHONE_MARGIN_BOTTOM = 16
PHONE_MARGIN_RIGHT = 20
# ~1 cm text/phone tightening (both sides).
LAYOUT_TIGHTEN_PX = 38
# Extra phone-only shift toward text (~1 cm).
PHONE_SHIFT_LEFT_PX = 38
PHONE_SUPERSAMPLE = 2


def load_font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    ttc = "/System/Library/Fonts/HelveticaNeue.ttc"
    idx = 1 if bold else 0
    if Path(ttc).exists():
        try:
            return ImageFont.truetype(ttc, size, index=idx)
        except OSError:
            return ImageFont.truetype(ttc, size)
    return ImageFont.load_default()


def build_background() -> Image.Image:
    base = Image.new("RGB", (TARGET_W, TARGET_H))
    px = base.load()
    for y in range(TARGET_H):
        ty = y / TARGET_H
        for x in range(TARGET_W):
            tx = x / TARGET_W
            spot = max(0.0, 1.0 - math.hypot(tx - 0.26, ty - 0.38) * 1.35)
            r = int(8 + ty * 12 + spot * 24)
            g = int(42 + ty * 32 + spot * 38)
            b = int(40 + ty * 28 + spot * 34)
            px[x, y] = (min(r, 68), min(g, 132), min(b, 124))

    canvas = base.convert("RGBA")
    overlay = Image.new("RGBA", (TARGET_W, TARGET_H), (0, 0, 0, 0))
    d = ImageDraw.Draw(overlay)
    d.ellipse((-40, -60, 420, 320), fill=(120, 220, 210, 42))
    canvas.alpha_composite(overlay.filter(ImageFilter.GaussianBlur(radius=36)))
    return canvas


def resize_h(img: Image.Image, height: int) -> Image.Image:
    w = round(img.width * height / img.height)
    return img.resize((w, height), Image.Resampling.LANCZOS)


def build_logo(size: int) -> Image.Image:
    """Crisp teal rounded icon + white handshake."""
    src = Image.open(LOGO).convert("RGBA").resize((size * 2, size * 2), Image.Resampling.LANCZOS)
    spx = src.load()
    sw = src.width
    teal_samples = [spx[sw // 2, sw // 2][:3], spx[sw // 4, sw // 4][:3]]
    sr = sum(c[0] for c in teal_samples) // len(teal_samples)
    sg = sum(c[1] for c in teal_samples) // len(teal_samples)
    sb = sum(c[2] for c in teal_samples) // len(teal_samples)

    logo = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    pad = max(1, size // 32)
    ImageDraw.Draw(logo).rounded_rectangle(
        (pad, pad, size - pad - 1, size - pad - 1),
        radius=size // 4,
        fill=(sr, sg, sb, 255),
    )

    handshake = Image.new("RGBA", (size * 2, size * 2), (0, 0, 0, 0))
    hpx = handshake.load()
    for y in range(src.height):
        for x in range(src.width):
            r, g, b, a = spx[x, y]
            lum = r + g + b
            if lum > 520 and min(r, g, b) > 150:
                hpx[x, y] = (255, 255, 255, min(255, lum - 400))
    handshake = handshake.resize((size, size), Image.Resampling.LANCZOS)
    logo.alpha_composite(handshake)
    return logo


def is_studio_bg(r: int, g: int, b: int) -> bool:
    """Background pixels from the v3 source artwork."""
    if r <= 12 and 35 <= g <= 145 and 35 <= b <= 145:
        return True
    if r <= 8 and g >= 90 and b >= 95 and g - r > 70:
        return True
    return False


def is_phone_pixel(r: int, g: int, b: int) -> bool:
    """Bezel / device pixels that must never be keyed out."""
    lum = r + g + b
    if lum >= 195 and min(r, g, b) >= 35:
        return True
    if lum >= 150 and r >= 30 and abs(r - g) <= 28 and abs(g - b) <= 28:
        return True
    return False


def flood_key_out(rgba: Image.Image, tolerance: int = 36) -> Image.Image:
    """Remove studio background connected to edge seeds (teal only)."""
    px = rgba.load()
    w, h = rgba.size
    visited: set[tuple[int, int]] = set()
    seeds: list[tuple[int, int]] = []

    for x in range(w):
        for y in (0, h - 1):
            if is_studio_bg(*px[x, y][:3]):
                seeds.append((x, y))
    for y in range(h):
        for x in (0, w - 1):
            if is_studio_bg(*px[x, y][:3]):
                seeds.append((x, y))

    for sx, sy in seeds:
        if (sx, sy) in visited:
            continue
        target = px[sx, sy][:3]
        queue: deque[tuple[int, int]] = deque([(sx, sy)])
        while queue:
            x, y = queue.popleft()
            if (x, y) in visited:
                continue
            if x < 0 or y < 0 or x >= w or y >= h:
                continue
            r, g, b, a = px[x, y]
            if is_phone_pixel(r, g, b):
                continue
            if (
                abs(r - target[0]) > tolerance
                or abs(g - target[1]) > tolerance
                or abs(b - target[2]) > tolerance
            ):
                continue
            visited.add((x, y))
            px[x, y] = (r, g, b, 0)
            queue.extend([(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)])

    return rgba


def defringe_phone(rgba: Image.Image, passes: int = 3) -> Image.Image:
    """Strip dark studio-teal pixels touching transparency."""
    px = rgba.load()
    w, h = rgba.size

    def edge_teal(r: int, g: int, b: int) -> bool:
        return r <= 18 and 38 <= g <= 132 and 38 <= b <= 132

    for _ in range(passes):
        to_clear: list[tuple[int, int]] = []
        for y in range(h):
            for x in range(w):
                r, g, b, a = px[x, y]
                if a == 0 or is_phone_pixel(r, g, b) or not edge_teal(r, g, b):
                    continue
                if any(
                    nx < 0 or ny < 0 or nx >= w or ny >= h or px[nx, ny][3] == 0
                    for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1))
                ):
                    to_clear.append((x, y))
        for x, y in to_clear:
            px[x, y] = (0, 0, 0, 0)

    return rgba


def keep_significant_components(
    rgba: Image.Image, min_size: int = 500, *, crop: bool = True
) -> Image.Image:
    """Keep the phone body plus large attached fragments (e.g. bottom corner)."""
    px = rgba.load()
    w, h = rgba.size
    visited: set[tuple[int, int]] = set()
    components: list[list[tuple[int, int]]] = []

    for sy in range(h):
        for sx in range(w):
            if px[sx, sy][3] == 0 or (sx, sy) in visited:
                continue
            component: list[tuple[int, int]] = []
            queue: deque[tuple[int, int]] = deque([(sx, sy)])
            while queue:
                x, y = queue.popleft()
                if x < 0 or y < 0 or x >= w or y >= h:
                    continue
                if (x, y) in visited or px[x, y][3] == 0:
                    continue
                visited.add((x, y))
                component.append((x, y))
                queue.extend([(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)])
            components.append(component)

    cleaned = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    cpx = cleaned.load()
    for component in components:
        if len(component) >= min_size:
            for x, y in component:
                cpx[x, y] = px[x, y]

    if not crop:
        return cleaned

    bbox = cleaned.getbbox()
    return cleaned.crop(bbox) if bbox else cleaned


def bridge_phone_from_raw(raw: Image.Image, mask: Image.Image, gap: int = 10) -> Image.Image:
    """Fill small gaps between phone fragments using original source pixels."""
    raw_px = raw.load()
    out = mask.copy()
    opx = out.load()
    w, h = raw.size
    dilated = mask.split()[3].filter(ImageFilter.MaxFilter(gap * 2 + 1))
    dpx = dilated.load()

    for y in range(h):
        for x in range(w):
            if dpx[x, y] < 64:
                continue
            if opx[x, y][3] > 220:
                continue
            r, g, b, a = raw_px[x, y]
            if a < 128 or is_studio_bg(r, g, b):
                continue
            if is_phone_pixel(r, g, b):
                opx[x, y] = (r, g, b, 255)

    return out


def cleanup_studio_flecks(rgba: Image.Image) -> Image.Image:
    """Remove studio pixels sitting on the cutout edge only."""
    px = rgba.load()
    w, h = rgba.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            if not (is_studio_bg(r, g, b) or (r <= 18 and g >= 60 and b >= 60)):
                continue
            on_edge = any(
                nx < 0 or ny < 0 or nx >= w or ny >= h or px[nx, ny][3] == 0
                for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1))
            )
            if on_edge:
                px[x, y] = (0, 0, 0, 0)
    return rgba


def smooth_phone_alpha(rgba: Image.Image) -> Image.Image:
    """Anti-alias jagged extraction edges without softening the screen."""
    alpha = rgba.split()[3]
    soft = alpha.filter(ImageFilter.GaussianBlur(1.0))
    apx = alpha.load()
    spx = soft.load()
    merged = Image.new("L", rgba.size)
    mpx = merged.load()
    for y in range(rgba.height):
        for x in range(rgba.width):
            hard = apx[x, y]
            if hard > 245:
                mpx[x, y] = 255
            elif hard < 8:
                mpx[x, y] = 0
            else:
                mpx[x, y] = spx[x, y]
    rgba.putalpha(merged)
    return rgba


def harden_bezel_alpha(rgba: Image.Image) -> Image.Image:
    """Force full opacity on frame pixels so corners stay crisp."""
    px = rgba.load()
    w, h = rgba.size
    for y in range(int(h * 0.74), h):
        for x in range(min(int(w * 0.28), w)):
            r, g, b, a = px[x, y]
            if a > 48 and r + g + b > 380:
                px[x, y] = (r, g, b, 255)
            elif a < 96:
                px[x, y] = (0, 0, 0, 0)
    return rgba


def repair_bezel_corner(rgba: Image.Image) -> Image.Image:
    """Rebuild a smooth bottom-left rounded frame corner."""
    px = rgba.load()
    w, h = rgba.size

    samples: list[tuple[int, int, int]] = []
    for y in range(int(h * 0.9), h):
        for x in range(18, min(50, w)):
            r, g, b, a = px[x, y]
            if a > 220 and r + g + b > 680:
                samples.append((r, g, b))
    if len(samples) < 3:
        return rgba

    fill = (
        sum(c[0] for c in samples) // len(samples),
        sum(c[1] for c in samples) // len(samples),
        sum(c[2] for c in samples) // len(samples),
    )

    left_x = w
    top_y = h
    for y in range(int(h * 0.86), h):
        for x in range(min(int(w * 0.2), w)):
            r, g, b, a = px[x, y]
            if a > 180 and r + g + b > 560:
                left_x = min(left_x, x)
                top_y = min(top_y, y)
    if left_x >= w or top_y >= h:
        return rgba

    radius = max(14, min(19, int(h * 0.036)))
    cx = left_x + radius
    cy = top_y + radius

    for y in range(max(0, top_y - 6), h):
        dy = max(0, y - cy)
        if dy <= radius:
            arc_x = int(cx - math.sqrt(max(0.0, radius * radius - dy * dy)))
            start_x = min(left_x, arc_x)
        else:
            start_x = left_x

        for x in range(max(0, start_x - 1), min(int(w * 0.18), w)):
            r, g, b, a = px[x, y]
            outside_corner = x < cx and y > cy and math.hypot(x - cx, y - cy) > radius + 0.5
            if outside_corner:
                px[x, y] = (0, 0, 0, 0)
                continue

            on_frame = x <= left_x + radius and y >= top_y - 1
            in_arc = math.hypot(x - cx, y - cy) <= radius + 0.6
            if on_frame and (x <= left_x + 1 or in_arc) and (a < 220 or r + g + b < 540):
                px[x, y] = (*fill, 255)

    return rgba


def final_corner_touchup(rgba: Image.Image) -> Image.Image:
    """Repair bottom-left bezel gaps without extending past the phone silhouette."""
    px = rgba.load()
    w, h = rgba.size
    fill = (252, 252, 252)
    y0 = int(h * 0.84)

    soft_alpha = 125

    soft_edge: list[int] = []
    solid_edge: list[int] = []
    for y in range(h):
        soft = w
        solid = w
        for x in range(min(int(w * 0.25), w)):
            a = px[x, y][3]
            if soft >= w and a >= soft_alpha:
                soft = x
            if solid >= w and a > 200:
                solid = x
        soft_edge.append(soft)
        solid_edge.append(solid)

    for y in range(y0, h):
        left = soft_edge[y]
        if left >= w:
            continue

        screen_x = w
        for x in range(left + 1, min(left + 4, w)):
            r, g, b, a = px[x, y]
            if a > 200 and r + g + b < 120:
                screen_x = x
                break
            if a > 200 and g > r + 15 and b > r + 10 and g > 90:
                screen_x = x
                break

        limit = min(screen_x if screen_x < w else left + 2, left + 2)

        for x in range(left, limit):
            r, g, b, a = px[x, y]
            if a > 200 and r + g + b < 120:
                break
            if g > r + 15 and b > r + 10 and g > 90:
                break
            if a < 250 or r + g + b < 735:
                px[x, y] = (*fill, 255)

        for x in range(0, solid_edge[y]):
            if 0 < px[x, y][3] < soft_alpha:
                px[x, y] = (0, 0, 0, 0)

        for x in range(left, min(left + 2, w)):
            r, g, b, a = px[x, y]
            if a == 0:
                break
            if 0 < a < 250 and r + g + b > 450:
                px[x, y] = (*fill, 255)

    return rgba


def connect_left_bezel_arc(rgba: Image.Image) -> Image.Image:
    """Fill the one inward bulge on the left bezel (y≈385–395) without painting outside the phone."""
    px = rgba.load()
    w, h = rgba.size
    white = (252, 252, 252)
    inner = (0, 0, 0)
    scan = min(int(w * 0.12), w)

    def min_opaque(y: int, threshold: int = 125) -> int:
        if y < 0 or y >= h:
            return w
        for x in range(scan):
            if px[x, y][3] >= threshold:
                return x
        return w

    y = 0
    while y < h:
        if min_opaque(y) >= 3 and px[0, y][3] < 125:
            y_start = y
            while y < h and min_opaque(y) >= 3 and px[0, y][3] < 125:
                y += 1
            y_end = y - 1
            if min_opaque(y_start - 1) == 0 and min_opaque(y_end + 1) == 0:
                for yy in range(y_start, y_end + 1):
                    left = min_opaque(yy)
                    for x in range(0, left):
                        if px[x, yy][3] >= 250:
                            continue
                        if x <= 1:
                            px[x, yy] = (*white, 255)
                        elif x == 2:
                            px[x, yy] = (*inner, 255)
                        else:
                            px[x, yy] = (*white, 255)
        else:
            y += 1

    return rgba


def clean_left_edge(rgba: Image.Image) -> Image.Image:
    """Remove stray dark pixels on the bottom-left silhouette."""
    px = rgba.load()
    w, h = rgba.size
    for y in range(int(h * 0.72), h):
        for _ in range(12):
            xs = [x for x in range(min(int(w * 0.28), w)) if px[x, y][3] > 128]
            if not xs:
                break
            x = min(xs)
            if sum(px[x, y][:3]) < 480:
                px[x, y] = (0, 0, 0, 0)
            else:
                break
    return rgba


def sharpen_image(img: Image.Image, radius: float = 0.9, percent: int = 130) -> Image.Image:
    if img.mode != "RGB":
        rgb = img.convert("RGB")
    else:
        rgb = img
    return rgb.filter(ImageFilter.UnsharpMask(radius=radius, percent=percent, threshold=2))


def build_phone_shadow(phone: Image.Image, phone_x: int, phone_y: int) -> Image.Image:
    """Layered contact + ambient shadow aligned to the tilted phone."""
    shadow = Image.new("RGBA", (TARGET_W, TARGET_H), (0, 0, 0, 0))
    d = ImageDraw.Draw(shadow)
    w, h = phone.size
    base_y = phone_y + h - 6
    left = phone_x + round(w * 0.08)
    right = phone_x + w - 6

    d.ellipse((left, base_y - 2, right, base_y + 16), fill=(0, 0, 0, 105))
    contact = shadow.filter(ImageFilter.GaussianBlur(radius=4))

    ambient = Image.new("RGBA", (TARGET_W, TARGET_H), (0, 0, 0, 0))
    da = ImageDraw.Draw(ambient)
    da.ellipse(
        (phone_x - 8, base_y + 4, phone_x + w + 26, base_y + 52),
        fill=(0, 0, 0, 55),
    )
    ambient = ambient.filter(ImageFilter.GaussianBlur(radius=16))

    contact.alpha_composite(ambient)
    return contact


def extract_phone(img: Image.Image) -> Image.Image:
    keyed = flood_key_out(img.copy())
    defringed = defringe_phone(keyed)
    mask = keep_significant_components(defringed, crop=False)
    bridged = bridge_phone_from_raw(img, mask)
    cleaned = cleanup_studio_flecks(bridged)
    repaired = repair_bezel_corner(cleaned)
    smoothed = smooth_phone_alpha(repaired)
    hardened = harden_bezel_alpha(smoothed)
    repaired = repair_bezel_corner(hardened)
    final_phone = clean_left_edge(repaired)
    bbox = final_phone.getbbox()
    return final_phone.crop(bbox) if bbox else final_phone


def render_phone(source: Image.Image) -> Image.Image:
    crop = source.crop(PHONE_CROP)
    max_phone_h = TARGET_H - PHONE_MARGIN_TOP - PHONE_MARGIN_BOTTOM
    if PHONE_SUPERSAMPLE <= 1:
        raw = resize_h(crop, max_phone_h)
        return extract_phone(raw)

    raw_hi = resize_h(crop, max_phone_h * PHONE_SUPERSAMPLE)
    phone_hi = extract_phone(raw_hi)
    phone_hi = phone_hi.filter(
        ImageFilter.UnsharpMask(radius=1.4, percent=120, threshold=2)
    )
    target_w = max(1, round(phone_hi.width / PHONE_SUPERSAMPLE))
    target_h = max(1, round(phone_hi.height / PHONE_SUPERSAMPLE))
    phone = phone_hi.resize((target_w, target_h), Image.Resampling.LANCZOS)
    phone = final_corner_touchup(phone)
    return connect_left_bezel_arc(phone)


def wrap_text(draw: ImageDraw.ImageDraw, text: str, font, max_w: int) -> list[str]:
    words = text.split()
    lines: list[str] = []
    line = ""
    for word in words:
        trial = f"{line} {word}".strip()
        if draw.textbbox((0, 0), trial, font=font)[2] <= max_w:
            line = trial
        else:
            if line:
                lines.append(line)
            line = word
    if line:
        lines.append(line)
    return lines


def compose(source: Path) -> Image.Image:
    src = Image.open(source).convert("RGBA")
    canvas = build_background()

    icon_size = 108
    icon = build_logo(icon_size)
    shift = LAYOUT_TIGHTEN_PX // 2
    icon_x = 64 + shift
    title_font = load_font(58, bold=True)
    subtitle_font = load_font(27)
    tag_font = load_font(22)

    measure = ImageDraw.Draw(canvas)
    tag_lines = wrap_text(measure, TAGLINE, tag_font, 480)
    title_row_h = 90
    tag_gap = 18
    tag_block_h = len(tag_lines) * 34
    content_h = max(icon_size, title_row_h) + tag_gap + tag_block_h
    block_y = (TARGET_H - content_h) // 2

    canvas.alpha_composite(icon, (icon_x, block_y))

    draw = ImageDraw.Draw(canvas)
    text_x = icon_x + icon_size + 22
    text_y = block_y + (icon_size - title_row_h) // 2
    draw.text((text_x, text_y), "YordamBor", font=title_font, fill=(255, 255, 255, 255))
    draw.text(
        (text_x, text_y + 58),
        "Xizmatlar makoni",
        font=subtitle_font,
        fill=(210, 244, 240, 255),
    )

    tag_y = block_y + icon_size + tag_gap
    for i, line in enumerate(tag_lines):
        draw.text((icon_x, tag_y + i * 34), line, font=tag_font, fill=(238, 250, 248, 255))

    phone = render_phone(src)
    phone_x = TARGET_W - phone.width - PHONE_MARGIN_RIGHT - shift - PHONE_SHIFT_LEFT_PX
    phone_y = (TARGET_H - phone.height) // 2

    rgb = sharpen_image(canvas.convert("RGB")).convert("RGBA")
    rgb.alpha_composite(build_phone_shadow(phone, phone_x, phone_y))
    rgb.alpha_composite(phone, (phone_x, phone_y))
    return rgb.convert("RGB")


def main() -> None:
    if not SOURCE.exists():
        raise SystemExit(f"Missing source: {SOURCE}")
    if not LOGO.exists():
        raise SystemExit(f"Missing logo: {LOGO}")

    result = compose(SOURCE)
    assert result.size == (TARGET_W, TARGET_H)

    OUT_PNG.parent.mkdir(parents=True, exist_ok=True)
    result.save(OUT_PNG, format="PNG", optimize=True, dpi=(72.0, 72.0))
    result.save(OUT_JPG, format="JPEG", quality=95, subsampling=0, dpi=(72.0, 72.0))

    for path in (OUT_PNG, OUT_JPG):
        check = Image.open(path)
        print(f"✓ {path.name}: {check.size[0]}×{check.size[1]} px, {path.stat().st_size // 1024} KB")


if __name__ == "__main__":
    main()
