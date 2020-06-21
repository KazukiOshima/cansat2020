# -*- coding: utf-8 -*-
import time
import lora_setting

import gps #0620_1

# LoRa送信用クラス
class radio(object):

    def __init__(self, lora_device, channel):
        self.sendDevice = lora_setting.LoraSettingClass(lora_device)
        self.channel = channel
        channel = 15
        self.lora_device = "/dev/ttySOFT0"  # ES920LRデバイス名
        self.gps = gps.GPS()#0620_1
        
    def setup(self):
        self.gps.setupGPS()
        
        # LoRa初期化
        self.sendDevice.reset_lora()
        # LoRa設定コマンド
        
        set_mode = ['1', 'd', self.channel, 'e', '0001', 'f', '0001', 'g', '0000',
                    'l', '2', 'n', '1', 'p', '1', 'y', 'z']
                    
        # LoRa設定
        self.sendDevice.setup_lora(set_mode)
        

    # ES920LRデータ送信メソッド
    #def lora_send(self):
    def sendData(self):        
        # LoRa(ES920LR)データ送信
        self.gps.gpsread()
        
        data = str(self.gps.Time) + ","\
               + str(self.gps.Lat) + ","\
               + str(self.gps.Lon)
        
        print('<-- SEND -- [ {} ]'.format(data))
        self.sendDevice.cmd_lora('{}'.format(data))
        
        # 1秒待機
        time.sleep(1)            

#radio = radio("/dev/ttySOFT0", 15)
#radio.setup()
#radio.sendData()  