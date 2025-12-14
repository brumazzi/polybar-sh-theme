import fontforge
import os

font = fontforge.font()

# styles = ["Mono", "Branded"] # have error to generate Branded fonts
styles = ["Mono"]

for style in styles:
    font.fontname = f"CryptCoins-{style}"
    font.fullname = f"Crypt Coins {style}"
    font.familyname = "Crypt Coins"
    font.weight = style

    font.os2_weight = 600

    svg_dir = f"./web3icons/raw-svgs/tokens/{style.lower()}"

    code = 0xE001
    for filename in sorted(os.listdir(svg_dir)):
        if filename.lower().endswith(".svg"):
            fullpath = os.path.join(svg_dir, filename)
            
            glyph = font.createChar(code)
            glyph.importOutlines(fullpath)
            
            glyph.removeOverlap()
            glyph.correctDirection()
            glyph.simplify()
            glyph.round()
            
            glyph.width = 1024
            
            code += 1

    font.em = 1024
    font.ascent = 800
    font.descent = 200

    font.generate(f"CryptCoins-{style}.ttf")
    # font.generate(f"CryptCoins-{style}.woff")
    # font.generate(f"CryptCoins-{style}.woff2")

    print(f"CryptCoins-{style}.ttf Generated! {code - 0xE001} symbols generated!")
