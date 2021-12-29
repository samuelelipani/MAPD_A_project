import serial # pip install serial e pip install pyserial, in quest'ordine
import numpy as np

segnale = np.loadtxt("segnale.txt")

# Sistema la porta
with serial.Serial('/dev/ttyUSB11', baudrate=115200) as ser :
    with open("output.txt","w") as fh :
        for n in segnale :
            # send
            if n < 0 :
                x = chr(256+n)
            else :
                x = chr(n)
            #x = x.encode("utf-8") # questo rompe ord ma potrebbe servire con serial, non si sa mai
            ser.write(x)
            # receive
            y = ser.read()
            if y > 127 :
                y = ord(x) - 256
            else :
                pass
            # save to file
            fh.write(str(y)+"\n")
            print y
