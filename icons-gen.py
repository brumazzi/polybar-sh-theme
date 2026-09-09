import fontforge
import os

base_dir = "./raw-svgs"
folders = os.listdir(base_dir)
styles = ["Mono"]

for folder in folders:
    font = fontforge.font()
    for style in styles:
        try:
            font.fontname = f"{folder}-{style}"
            font.fullname = f"{folder} {style}"
            font.familyname = f"{folder}"
            font.weight = style

            font.os2_weight = 600

            svg_dir = f"{base_dir}/{folder}/{style.lower()}"

            code = 0x41
            for filename in sorted(os.listdir(svg_dir)):
                if filename.lower().endswith(".svg"):
                    fullpath = os.path.join(svg_dir, filename)
                    
                    glyph = font.createChar(code)
                    glyph.importOutlines(fullpath)
                    
                    glyph.removeOverlap()
                    glyph.correctDirection()
                    glyph.simplify()
                    glyph.round()
                    
                    if folder == "ProgressBar":
                        glyph.width = 512+128
                    else:
                        glyph.width = 1024
                    
                    code += 1

            font.em = 1024
            font.ascent = 800
            font.descent = 200

            font.generate(f"{folder}-{style}.ttf")
            # font.generate(f"CryptCoins-{style}.ttf")
            # font.generate(f"CryptCoins-{style}.woff")
            # font.generate(f"CryptCoins-{style}.woff2")

            print(f"CryptCoins-{style}.ttf Generated! {code - 0xE001} symbols generated!")
        except Exception as e:
            print(f"Fail to build {folder}-{style}: {e}")
