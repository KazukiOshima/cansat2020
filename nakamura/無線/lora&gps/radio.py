# -*- coding: utf-8 -*-
import time
import lora_setting
import gps


# LoRa送信用クラス
class radio(object):

    def __init__(self, lora_device, channel):
        self.sendDevice = lora_setting.LoraSettingClass(lora_device)
        self.channel = channel
        self.gps = gps.GPS()
        #self.channel = 15

    # ES920LRデータ送信メソッド
    #def lora_send(self):
    def sendData(self):
        # LoRa初期化
        self.sendDevice.reset_lora()
        # LoRa設定コマンド
        set_mode = ['1', 'd', self.channel, 'e', '0001', 'f', '0001', 'g', '0000',
                    'l', '2', 'n', '1', 'p', '1', 'y', 'z']
        # LoRa設定
        self.sendDevice.setup_lora(set_mode)
        # LoRa(ES920LR)データ送信
        while True:
            try:
                self.gps.gpsread()
                # 送るデータ
                data = str(self.gps.Time) + ","\
                       + str(self.gps.Lat) + ","\
                       + str(self.gps.Lon)
                print(data)
                self.sendDevice.cmd_lora(data)
               
            except KeyboardInterrupt:
                self.sendDevice.close()
            # 1秒待機
            time.sleep(1)
