import serial # pip install serial e pip install pyserial, in quest'ordine
#import numpy as np
import time

#segnale = np.loadtxt("segnale.txt")
segnale = open("./input2.txt","r")

# Sistema la porta
ser = serial.Serial('/dev/ttyUSB11', baudrate=115200, timeout=5)
#print ser.is_open
#ser.reset_input_buffer()
#time.sleep(2)
#print ser.name
fh = open("./output.txt","w")
for n in segnale :
    # send
    n = int(n)
    if n < 0 :
        x = chr(256+n)
    else :
        x = chr(n)
    #x = x.encode("utf-8") # questo rompe ord ma potrebbe servire con serial, non si sa mai
    #print "invio", x
    ser.write(x)
    #time.sleep(0.1)
    # receive
    #print "leggo"
    y = ser.read() # default = legge fino ad 1 byte alla volta
    #y = int(y)
    #print "y:",y
    #print type(y)
    y = ord(y)
    if y > 127 :
        a = y - 256
    else :
        a = y
    # save to file
    fh.write(str(a)+"\n")
    print a
    
#ser.reset_output_buffer()
fh.close()
