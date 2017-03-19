from flask import Flask, jsonify

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hello World!'


@app.route('/devices')
def devices():
    from gattlib import DiscoveryService

    service = DiscoveryService("hci0")
    devices = service.discover(2)

    res = {}
    for address, name in devices.items():
        print("name: {}, address: {}".format(name, address))
        if name.startswith('edison'):
            res[name] = address

    return jsonify(res)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
