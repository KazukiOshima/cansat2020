import time
import picamera

my_file = open('my_image.jpg','wb')
camera=picamera.PiCamera()
camera.start_preview()

time.sleep(3)
camera.capture(my_file)
my_file.close()
camera.close()
