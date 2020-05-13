import RPi.GPIO as GPIO
import time 

GPIO.setmode(GPIO.BCM)

#GPIO.setwarnings(False)

led_pin = 4
GPIO.setup(led_pin, GPIO.OUT)

led1 = GPIO.PWM(led_pin, 50)
led1.start(0)

for loop in range(5):
    for i in range(0,100,20):
        led1.ChangeDutyCycle(i)
        time.sleep(0.01)
        
    for i in range(100,0,-20):
        led1.ChangeDutyCycle(i)
        time.sleep(0.05)
        
led1.stop()
GPIO.cleanup()  
