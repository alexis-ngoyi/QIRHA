from rembg import remove
from PIL import Image
import os

list = [
    'app'
]

for i in list:
    input_path = i + '.png'
    output_path = i + '.png'

    inp = Image.open(input_path)
    output = remove(inp)

    output.save(output_path)
    # os.unlink(input_path)


# Made with heart
# Image background remover
