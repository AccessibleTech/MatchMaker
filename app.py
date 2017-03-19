from os import environ
import time

from gattlib import DiscoveryService
from upm import pyupm_grove as grove

led = grove.GroveLed(int(environ.get('LED_COLOR', 2)))

time.sleep(.25)
service = DiscoveryService("hci0")

while True:
    devices = service.discover(5)

    for address, name in devices.items():
        if name.startswith('edison') or address.startswith('58:A8:39:00'):
            print("Edison detected - name: {}, address: {}".format(name, address))
            # Turn the LED on and off 10 times, pausing 1/4 second
            # between transitions
            for i in range(0, 10):
                led.on()
                time.sleep(.25)
                led.off()
                time.sleep(.25)
