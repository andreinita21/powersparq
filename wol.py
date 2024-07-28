from flask import Flask, jsonify
from flask_cors import CORS
from wakeonlan import send_magic_packet
import os
import signal
import subprocess

app = Flask(__name__)
CORS(app) 

@app.route('/api/wake', methods=['POST'])
def wake():
    send_magic_packet('1c:86:0b:21:01:3f')
    return jsonify(success=True, message='Calculatorul a fost trezit!')

@app.route('/api/restart-websockify', methods=['POST'])
def restart_websockify():
    try:
        # Find all WebSockify processes
        process = subprocess.Popen(['pgrep', '-f', 'websockify'], stdout=subprocess.PIPE)
        stdout, stderr = process.communicate()

        # Kill all found processes
        for pid in stdout.splitlines():
            os.kill(int(pid), signal.SIGTERM)

        # Restart WebSockify
        subprocess.Popen(['nohup', 'python3', '-m', 'websockify', '--web=/var/www/html/vnc', '6080', '192.168.100.190:5900', '&'])

        return jsonify({"status": "success", "message": "WebSockify processes restarted"}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=2006)