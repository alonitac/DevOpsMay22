from matplotlib.image import imread, imsave


def rgb2gray(rgb):

    r, g, b = rgb[:,:,0], rgb[:,:,1], rgb[:,:,2]
    gray = 0.2989 * r + 0.5870 * g + 0.1140 * b

    return gray


def open_img(img_path):
    return rgb2gray(imread(img_path)).tolist()


def save_img(img, filename):
    imsave(filename, img, cmap='gray')
