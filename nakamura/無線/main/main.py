import time
import gps
import radio

class cansat(object):
    def __init__(self):
        self.gps = gps.GPS()
        self.radio = radio.radio("/dev/ttySOFT0", 15)

    def setup(self):
        #self.gps.setupGPS()
        self.radio.setup()

    def main(self):
        self.radio.sendData()
    """
    def writeData(self):
        self.gps.gpsread()
        timer = 1000*(time.time() - start_time)
        timer = int(timer)
        datalog = str(timer) + ","\
                  + str(self.gps.Time) + ","\
                  + str(self.gps.Lat) + ","\
                  + str(self.gps.Lon)
    
        with open("test.txt",mode = 'a') as test:
            test.write(datalog + '\n')
            """

cansat = cansat() 
cansat.setup()
#cansat.main()

while True:
    try:
        cansat.main()
    except KeyboardInterrupt:
            self.sendDevice.close()
            