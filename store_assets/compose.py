#!/usr/bin/env python3
"""Frames raw simulator screenshots with a headline into App Store sized images (headless Chrome renders the HTML).

Usage: python3 compose.py [iphone|ipad]     (default: both; skips shots whose raw capture is missing)
Raw captures live in raw/ (ios_<key>.png from the iPhone 6.9" simulator, ipad_<key>.png from the iPad 13" one); the
results go to ios_6.9in/ (1320x2868) and ios_ipad_13in/ (2048x2732).

On an iPad the app shows in a 500 pt column in the middle of the screen, so only that column (crop_x/crop_w, in
pixels) is framed, like a phone.
"""
import html
import pathlib
import subprocess
import sys

HERE = pathlib.Path(__file__).parent
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

DEVICES = {
    "iphone": dict(prefix="ios", folder="ios_6.9in", w=1320, h=2868, head=112, sub=54, head_top=170, frame_top=640,
                   frame_w=1020, crop_x=0, crop_w=None),
    "ipad": dict(prefix="ipad", folder="ios_ipad_13in", w=2048, h=2732, head=150, sub=74, head_top=150, frame_top=620,
                 frame_w=1300, crop_x=524, crop_w=1000),
}

# (key, headline, sub headline)
SHOTS = [
    ("00_balance", "Kövesd a büfé egyenleged", "Egy pillantással, bárhol"),
    ("01_login", "Lépj be egyszerűen", "E-mail, Google vagy Apple fiókkal"),
    ("02_register", "Regisztrálj percek alatt", "Új fiók néhány lépésben"),
    ("03_topup", "Töltsd fel az egyenleged", "Gyorsan és biztonságosan"),
    ("04_profile", "A fiókod a kezedben", "Értesítések, jelszó és nyelv"),
]

PAGE = """<!doctype html><html><head><meta charset="utf-8"><style>
html,body{{margin:0;width:{w}px;height:{h}px;overflow:hidden}}
body{{background:linear-gradient(165deg,#8a9d63 0%,#6f8148 55%,#566535 100%);font-family:'Trebuchet MS','Helvetica Neue',Arial,sans-serif;position:relative}}
.t{{position:absolute;top:{head_top}px;left:60px;right:60px;text-align:center;color:#fff}}
.t h1{{margin:0;font-size:{head}px;line-height:1.08;font-weight:800;letter-spacing:-1px}}
.t p{{margin:28px 0 0;font-size:{sub}px;font-weight:400;opacity:.9}}
.phone{{position:absolute;top:{frame_top}px;left:{left}px;width:{frame_w}px;border:16px solid #101010;border-bottom:none;border-radius:{radius}px {radius}px 0 0;background:#101010;box-shadow:0 40px 120px rgba(0,0,0,.35);overflow:hidden}}
.phone img{{display:block;width:{img_w}px;margin-left:{img_left}px;border-radius:{inner}px {inner}px 0 0}}
</style></head><body>
<div class="t"><h1>{head_text}</h1><p>{sub_text}</p></div>
<div class="phone"><img src="{img}"></div>
</body></html>"""


def render(device, key, head, sub):
    d = DEVICES[device]
    src = HERE / "raw" / f"{d['prefix']}_{key}.png"
    if not src.exists():
        print(f"skip {device} {key}: {src.name} is missing")
        return
    full_w = d["w"]  # raw captures have the full screen width in pixels
    if d["crop_w"]:
        scale = d["frame_w"] / d["crop_w"]
        img_w, img_left = round(full_w * scale), -round(d["crop_x"] * scale)
    else:
        img_w, img_left = d["frame_w"], 0
    out_dir = HERE / d["folder"]
    out_dir.mkdir(exist_ok=True)
    page = HERE / f".{device}_{key}.html"
    page.write_text(PAGE.format(
        w=d["w"], h=d["h"], head=d["head"], sub=d["sub"], head_top=d["head_top"], frame_top=d["frame_top"],
        frame_w=d["frame_w"], left=(d["w"] - d["frame_w"] - 32) // 2, radius=130, inner=112, img_w=img_w,
        img_left=img_left, head_text=html.escape(head), sub_text=html.escape(sub), img=src.as_uri()), encoding="utf-8")
    out = out_dir / f"{key}.png"
    subprocess.run([CHROME, "--headless=new", "--disable-gpu", "--hide-scrollbars", "--force-device-scale-factor=1",
                    f"--window-size={d['w']},{d['h']}", f"--screenshot={out}", page.as_uri()],
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    page.unlink()
    print("wrote", out)


if __name__ == "__main__":
    for device in (sys.argv[1:] or DEVICES):
        for shot in SHOTS:
            render(device, *shot)
