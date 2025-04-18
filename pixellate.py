import os
import subprocess
from skimage import io
from pyxelate import Pyx, Pal
from PIL import Image

# Relevant setup for pyxelate and picture2pixel installation must be done before using this script.

def process_badapple(image_path, bitmap_path, output_dir):
    # Bad Apple Bitmapping Only
    old_img = Image.open(image_path)
    old_pixels = old_img.load()
    new_img = Image.new('RGB', [96, 64], 'black')
    new_pixels = new_img.load()

    for j in range(new_img.size[0]):
        if j < 5 or j > 89:
            continue
        for k in range(new_img.size[1]):
            if (old_pixels[j - 5,k] > (128,128,128)):
                new_pixels[j,k] = (255, 255, 255)
            else:
                new_pixels[j,k] = (0, 0, 0)
        
    new_img.save(bitmap_path)

    command = [
        'python', '-m', 'picture2pixel.convert2pixel', 
        bitmap_path, str(width), str(height), str(svd_r), output_dir
    ]
                
    subprocess.run(command)

def convert_image(bad_apple):
    # Directories for Input/Output
    source_dir = 'frames'
    input_dir = 'P2P_Input'  # Name of directory where input pixel art images are stored, labelled 0000, 0001, etc
    bitmap_dir = 'P2P_Bitmap' # Bad Apple Bitmapping Only
    output_dir = 'P2P_Output'  # Name of directory where output .p2p files will be saved

    # Parameters for picture2pixel library
    width = 96
    height = 64
    svd_r = 0

    frame_count = 8

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for i in range(frame_count):  # Replace ??? with the number of frames you want to convert
        image_name = f'{i:04d}.png'
        source_path = os.path.join(source_dir, image_name)
        image_path = os.path.join(input_dir, image_name)
        bitmap_path = os.path.join(bitmap_dir, f'{i:04d}.png')

        # Convert image to pixel art
        image = io.imread(source_path)
        pyx = Pyx(height = 64)
        pyx.fit(image)
        new_image = pyx.transform(image)
        io.imsave(image_path, new_image)

        if bad_apple:
            process_badapple(image_path, bitmap_bath, output_dir)
        else:
            command = [
                'python', '-m', 'picture2pixel.convert2pixel', 
                image_path, str(width), str(height), str(svd_r), output_dir
            ]
                
            subprocess.run(command)

def generate_code(input_folder, output_file):
    with open(output_file, 'w') as outfile:
        start_frame = 6301 # Starting frame number for bad apple
        
        for i in range(start_frame, start_frame + 180):
            if (i - start_frame) % 6 != 0:
                continue
            
            p2p_filename = f"{i:04}.p2p"
            p2p_path = os.path.join(input_folder, p2p_filename)
            if os.path.isfile(p2p_path):
                with open(p2p_path, 'r') as infile:
                    content = infile.read()
                if i == 0:
                    outfile.write(f"if (frame_count == {i}) begin\n")
                else:
                    outfile.write(f"else if (frame_count == {(i - start_frame) // 6 + 1}) begin\n")
                outfile.write(content)
                outfile.write("end\n")
            else:
                print(f"File {p2p_filename} does not exist in {input_folder}")

# Directories for Input/Output
input_folder = "P2P_Output"
output_file = "output.txt"

convert_image()
generate_code(input_folder = input_folder, output_file = output_file)

print("All images converted successfully using picture2pixel!")
