"""
second  -> float? int?
lat,lon -> ketasuu ikutsu? (2019:6keta?)
print   -> l.33,34
"""
import serial
import microGPS_nm_0525
import threading
import time


gps = microGPS_nm_0525.MicropyGPS(9, 'dd') # MicroGPSオブジェクトを生成する。
                                     # 引数はタイムゾーンの時差と出力フォーマット
                                     

def run_gps(): # GPSモジュールを読み、GPSオブジェクトを更新する
    s = serial.Serial('/dev/serial0', 9600, timeout=10) #9600:tuushinsokudo
    s.readline() # 最初の1行は中途半端なデーターが読めることがあるので、捨てる
    while True:
        sentence = s.readline().decode('utf-8') # GPSデーターを読み、文字列に変換する
        if sentence[0] != '$': # 先頭が'$'でなければ捨てる
            continue
        for x in sentence: # 読んだ文字列を解析してGPSオブジェクトにデーターを追加、更新する
            gps.update(x)
            
def thread_gps():
    gpsthread = threading.Thread(target=run_gps, args=()) # 上の関数を実行するスレッドを生成
    gpsthread.daemon = True
    gpsthread.start() # スレッドを起動

def read_gps():
    while True:
        if gps.clean_sentences > 20: # ちゃんとしたデーターがある程度たまったら出力する
            h = gps.timestamp[0] if gps.timestamp[0] < 24 else gps.timestamp[0] - 24
            #print('TIME: {0}:{1}:{2} ,' .format(h, gps.timestamp[1], gps.timestamp[2]),'LAT: {0:.6f},' .format(gps.latitude[0]), 'LON: {0:.6f},' .format(gps.longitude[0]))        
            print('time:%02d:%02d:%02d, ' % (h, gps.timestamp[1], gps.timestamp[2]),'lat:%2.6f, ' % (gps.latitude[0]), 'lon:%2.6f'% (gps.longitude[0]))        
        time.sleep(1.0)


thread_gps()
read_gps()