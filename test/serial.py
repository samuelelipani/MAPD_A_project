import serial # pip install serial e pip install pyserial, in quest'ordine

segnale = open("segnale.txt","r")

ser = serial.Serial('/dev/ttyUSB11', baudrate=115200)
fh = open("output.txt","w")
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
    y = ord(y)
    if y > 127 :
        a = ord(y) - 256
    else :
        a = y
    # save to file
    fh.write(str(a)+"\n")
    print a
fh.close()
segnale.close()
