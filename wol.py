from flask import Flask, jsonify
from flask_cors import CORS
from wakeonlan import send_magic_packet

app = Flask(__name__)
CORS(app)  # Permite cereri de pe orice domeniu, ajustează conform necesităților

@app.route('/api/wake', methods=['POST'])
def wake():           #MAC-ul desktopului
    send_magic_packet('1c:86:0b:21:01:3f')
    return jsonify(success=True, message='Calculatorul a fost trezit!')

if __name__ == '__main__': 
    app.run(host='0.0.0.0', port=2006) # Portul pe care va fi hostat serverul API