from flask import Flask, request, render_template
from yt_dlp import YoutubeDL
from flask import jsonify
import sqlite3

con = sqlite3.connect("data/videos.db", check_same_thread=False)
cur = con.cursor()
cur.execute("CREATE TABLE IF NOT EXISTS videos(client_ip, title, videoId, UNIQUE(client_ip, title, videoId))")

app = Flask(__name__, static_url_path='')


@app.route("/")
def home():
    return render_template('index.html')


@app.route("/youtube", methods=['POST'])
def get_youtube():
    client_ip = request.remote_addr
    video_name = request.json['text']

    if video_name == 'my videos':
        res = cur.execute(f"SELECT * FROM videos WHERE client_ip='{client_ip}'")
        data = res.fetchall()
        return jsonify({
            'items': [{'text': t, 'videoId': i} for _, t, i in data]
        }), 200

    with YoutubeDL() as ydl:
        videos = ydl.extract_info(f"ytsearch{1}:{video_name}", download=True)['entries']

        if videos:
            cur.execute(f"""INSERT OR IGNORE INTO videos VALUES ('{client_ip}', '{videos[0]['title']}', '{videos[0]['id']}')""")
            con.commit()

        return jsonify({
            'items': [{
                'text': videos[0]['title'] if videos else 'Video not found',
                'videoId': videos[0]['id'] if videos else ''
            }]
        }), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
