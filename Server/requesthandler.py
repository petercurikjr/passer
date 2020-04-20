#view.py
#this file handles POST requests from iOS Passer app.
#after recieving a sixdigit code with uuid of the user's device, Flask builds a dict out of it and writes it to in memory cache in json format for a limited time (2 min)

from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_caching import Cache
from datetime import datetime

app = Flask(__name__) #create a flask app
cors = CORS(app) #enables my website to GET from this server. for more, see enable-cors.org/server_flask.html

cache = Cache(app, config = {'CACHE_TYPE': 'simple'})  #COFIGURATE cache and create Cache instance
dic = {}

@app.route('/', methods=['POST']) #requests to allow
@cache.cached(timeout=0.001)
def processDataFromApp():
    incomingData = request.get_json()
    sixdigitCode = incomingData['sixdigitCode']
    uuid = incomingData['deviceID']
    dateStr = datetime.now().strftime('%d/%m/%Y %H:%M:%S')
    data = [sixdigitCode,dateStr]
    dic[uuid] = data
    verifyTimeStamps(datetime.now());
    return jsonify(dic)

@app.route('/verify_from_website', methods=['POST'])
def processDataFromWeb():
    incomingData = request.get_json()
    sixdigitTyped = incomingData['sixdigitTyped']
    return str(verify(sixdigitTyped))

def verify(sixdigitTyped):
    for item in dic.keys():
        sixdigitFromCache = dic[item][0]
        if sixdigitFromCache == sixdigitTyped:
            return True
    return False

def verifyTimeStamps(currentDate):
    for item in list(dic.keys()):
        dateFromCache = datetime.strptime(dic[item][1], '%d/%m/%Y %H:%M:%S')
        delta = currentDate - dateFromCache
        minutesDelta = delta.seconds / 60
        if minutesDelta > 1.99:
            del dic[item]


if __name__ == '__main__':
    app.run(debug=True)
