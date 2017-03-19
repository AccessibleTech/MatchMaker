from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hello World!'


@app.route('/devices')
def devices():
    from gattlib import DiscoveryService

    service = DiscoveryService("hci0")
    devices = service.discover(2)

    return '\n'.join("name: {}, address: {}".format(name, address)
                     for address, name in devices.items())


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
