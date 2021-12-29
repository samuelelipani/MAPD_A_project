import serial

ser = serial.Serial("/dev/ttyUSB11", baudrate=115200)
print ser.is_open

ser.reset_input_buffer()
ser.reset_output_buffer()
ser.cancel_read()
ser.cancel_write()
ser.flush()
ser.close
