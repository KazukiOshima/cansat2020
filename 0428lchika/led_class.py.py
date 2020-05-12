import RPI.GPIO as GPIO
from time import sleep

GPIO.setmode(GPIO.BCM)
#25ピンをOUT
GPIO.setup(25, GPIO.OUT)

#led_class.py
class Led(object):
    #コンストラクタ
    #def_init_(self,width):
     #   self.width=width
     
    #関数
    def led_on(self):
        GPIO.output(25, GPIO.HIGH)
    def led_off(self):
        GPIO.output(25, GPIO.LOW)

#インスタンス
#led=Led()