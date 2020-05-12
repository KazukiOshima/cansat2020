import cv2
import numpy as np

def find_rect_of_target_color(image): #set image as an argument
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV_FULL) #convert RGB to HSV
    h = hsv[:,:,0] #Hue
    s = hsv[:,:,1] #Saturation (purity)
    #v = hsv[:,:,2]
    mask = np.zeros(h.shape,dtype = np.uint8) #datatype = 8bit
    mask[((h<20)|(h>200))&(s>180)]=255 #mask as red if meet the condition
    contours,_=cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    
    try:
        if len(contours) > 0:
            max_cnt = max(contours, key=lambda x: cv2.contourArea(x))
            M = cv2.moments(max_cnt)
            cx = int(M["m10"]/M["m00"])
            cy = int(M["m01"]/M["m00"])
            print('centriod coordinates:','[',cx,':',cy,']')
        else:
            cx = 0
            cy = 0
            print('No red object detected')
            pass
    except:
        cx = 0
        cy = 0
        print('No red object detected')
        pass
    rects = []
    for contour in contours:
        approx = cv2.convexHull(contour)
        rect = cv2.boundingRect(approx)
        rects.append(np.array(rect))
    return rects,cx,cy

if __name__ == '__main__':
    capture = cv2.VideoCapture(0) #ste 0 as an identical camera number
    try:
        while cv2.waitKey(30)<0: #wait for key pressed for 30ms
            _, frame = capture.read()
            rects,cx,cy = find_rect_of_target_color(frame)
            if len(rects) > 0:
                rect = max(rects, key = (lambda x: x[2] * x[3]))
                cv2.rectangle(frame, tuple(rect[0:2]),tuple(rect[0:2]+rect[2:4]),(0,0,255), thickness=2)
                #thickness:line width
                if cx!=0 and cy!=0:
                    cv2.drawMarker(frame,(cx,cy), color=(0,0,255),markerType=cv2.MARKER_TILTED_CROSS, thickness=2)
                else:
                    pass
                cv2.imshow('red',frame)
            
    except KeyboardInterrupt:
        capture.release()
        cv2.destroyAllWindows()
