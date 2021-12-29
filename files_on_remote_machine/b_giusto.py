import serial # pip install serial e pip install pyserial, in quest'ordine
from tqdm import tqdm
#import numpy as np

#segnale = np.loadtxt("segnale.txt")
#segnale = open("./input.txt","r")
segnale = open("./inputf.txt","r")

# Sistema la porta
ser = serial.Serial('/dev/ttyUSB11', baudrate=115200, timeout=5)
fh = open("./output.txt","w")
for n in tqdm(segnale) :
    # send
    n = int(n.strip())
    if n < 0 :
        x = chr(255+n)
    else :
        x = chr(n)
    #x = x.encode("utf-8") # questo rompe ord ma potrebbe servire con serial, non si sa mai
    ser.write(x)
    # receive
    y = ser.read()
    y = ord(y)
    if y > 127 :
        a = y - 256
    else :
        a = y
    # save to file
    fh.write(str(a)+"\n")
    #print a

segnale.close()
fh.close()
