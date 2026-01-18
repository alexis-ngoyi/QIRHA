from rembg import remove
from PIL import Image
import os

list = [
    'bazard1',
    'bazard2',
    'bazard3',
    'bazard4',
    'bazard5',
    'bazard6'
]

for i in list:
    input_path = i + '.jpg'
    output_path = i + '.png'

    inp = Image.open(input_path)
    output = remove(inp)

    output.save(output_path)
    os.unlink(input_path)


# Made with heart
# Image background remover
