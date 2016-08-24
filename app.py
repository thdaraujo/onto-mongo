from __future__ import print_function
import os
import sys
import xmltodict, json
from flask import Flask, redirect, url_for, request, render_template
from pymongo import MongoClient

app = Flask(__name__)

client = MongoClient(
    os.environ['DB_PORT_27017_TCP_ADDR'],
    27017)
db = client.lattes


@app.route('/')
def lattes():

    _items = db.lattes.find()
    items = [item for item in _items]

    #print(items[0], file=sys.stderr)

    return render_template('lattes.html', items=items)


@app.route('/new', methods=['POST'])
def new():

    item_doc = {
        'name': request.form['name'],
        'description': request.form['description']
    }
    #TODO no uploads
    #db.lattes.insert_one(item_doc)

    return redirect(url_for('lattes'))

@app.route('/load', methods=['POST'])
def load():
    file_path = request.form['path']
    print(file_path, file=sys.stderr)

    with open(file_path) as file:
        data = file.read()
        obj = xmltodict.parse(data)
        db.lattes.insert_one(obj)

    return redirect(url_for('lattes'))


if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
