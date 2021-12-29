import serial # pip install serial e pip install pyserial, in quest'ordine
from tqdm import tqdm
from time import sleep
from os import system
#import numpy as np

#segnale = np.loadtxt("segnale.txt")
#segnale = open("./input/input.txt","r")

# Sistema la porta
ser = serial.Serial('/dev/ttyUSB11', baudrate=115200, timeout=5)
print "la porta seriale aperta:", ser.is_open
indici = range(2,5) 

for i in indici :
    print "ricompilo la fpga"
    system("sh compile.sh")
    print "apro i file n.", str(i)
    segnale = open("./input/input"+str(i)+".txt","r")
    fh = open("./output/output"+str(i)+".txt","w")
    for n in tqdm(segnale) :
        # send
        n = int(n.strip())
        if n < 0 :
            x = chr(256+n)
        else :
            x = chr(n)
        #x = x.encode("utf-8") # questo rompe ord ma potrebbe servire con serial, non si sa mai
        ser.write(x)
        # receive
        y = ser.read()
        try :
            y = ord(y)
            stop = False
        except :
            print "non sono riuscito a finire il file", i
            break
            stop = True
            
        if y > 127 :
            a = y - 256
        else :
            a = y
        # save to file
        fh.write(str(a)+"\n")
        #print a
    if stop :
        print "chiudo tristemente il file", i, "e abbandono"
        break
    
    print "chiudo i file n.", str(i)
    fh.close()
    segnale.close()
    #print "ricompilo la fpga tra 5 secondi"
    #sleep(5)
    #system("sh compile.sh")
    #print "aspetto 10 secondi prima di procedere"
    #sleep(10)
