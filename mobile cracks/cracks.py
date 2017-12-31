from PIL import Image

im = Image.open('image.png')
im_grey = im.convert('LA') # convert to grayscale
width,height = im.size

total=0
for i in range(0,width):
    for j in range(0,height):
        total += im.getpixel((i,j))[0]

mean = total / (width * height)
if mean < 10:
    print("free of any cracks")
elif mean > 10 and mean < 50:
        print("moderately cracked")
else:
    print("heavily cracked")
