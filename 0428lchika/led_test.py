#led_test.py
import led_class

#インスタンス生成
led=led_class.Led()

try:
    while True:
        led_on(self)
        sleep(0.5)
        led_off(self)
        sleep(0.5)

except KeyboardInterrupt:
    pass

GPIO.cleanup()