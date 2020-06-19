# -*- coding: utf-8 -*-
import sys

import radio
#import lora_recv
import gps#追加

gps = gps.GPS()#追加

def main(argc, argv):
    lora_device = "/dev/ttyS0"  # ES920LRデバイス名
    if argc < 2:
        print('Usage: python %s send' % (argv[0]))
        #print('       [send | recv] ... mode select')
        sys.exit()
    if argv[1] != 'send': #and argv[1] != 'recv':
        print('Usage: python %s send' % (argv[0]))
        #print('       [send | recv] ... mode select')
        sys.exit()
    

    # チャンネル番号を入力
    channel = input('channel:')

    # 送信側の場合
    if argv[1] == 'send':
        
        gps.setupGPS() #追加
        
        lr_send = radio.radio(lora_device, channel)
        lr_send.sendData()
       


if __name__ == '__main__':
    main(len(sys.argv), sys.argv)
    sys.exit()