from pathlib import Path
from flask import Flask, render_template, flash, request, redirect
import os
from werkzeug.utils import secure_filename

ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


app = Flask(__name__, static_url_path='')


@app.route('/api', methods=['POST'])
def upload_file_api():
    if 'file' not in request.files:
        return 'no file attached', 400

    file = request.files['file']

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

        p = Path(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        run(
            source=p,
            project=ROOT / 'static/data',  # save results to project/name
            name='images',
            save_txt=True
        )

        with open(f'static/data/images/labels/{filename.split(".")[0]}.txt') as f:
            labels = f.read().splitlines()
            labels = [[float(i) for i in l.split(' ')] for l in labels]

        return labels

    return 'bad file', 400


@app.route('/', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        flash('No file part')
        return redirect(request.url)
    file = request.files['file']
    # If the user does not select a file, the browser submits an
    # empty file without a filename.
    if file.filename == '':
        flash('No selected file')
        return redirect(request.url)
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

        p = Path(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        run(
            source=p,
            project=ROOT / 'static/data',  # save results to project/name
            name='images'
        )

        return render_template('result.html', filename=str(p))


@app.route("/")
def home():
    return render_template('index.html')


if __name__ == "__main__":
    from detect import run, ROOT
    UPLOAD_FOLDER = ROOT / 'data/images'
    app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

    app.run(host='0.0.0.0', port=8081, debug=True)
