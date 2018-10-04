import datetime
import json
import csv

def parse_date(value, param='date'):
    params = {
            'date': '%Y-%m-%d',
            'hour': '%H:%M:%S',
            'dayweek': '%w',
            'weekyear': '%U'
            }
    return datetime.datetime.fromtimestamp(value/1000000).strftime(params[param])

social_networks = {
        'twitter': 'twitter.com',
        'facebook': 'facebook.com',
        'instagram': 'instagram.com',
        'whatsapp': 'whatsapp.com'
        }

def get_social_name(url):
    for key in social_networks.keys():
        if social_networks[key] in url:
            return key

def valid_social_network(url):
    for v in social_networks.values():
        if v in url:
            return True

def filter_history(day, history_array):
    max = 0
    maxweek = -1
    ha = list(filter(lambda x: x[4] == str(day), history_array))
    weeks = set([x[5] for x in ha])
    for week in weeks:
        counts = len(list(filter(lambda x: x[5] == str(week), history_array)))
        if counts >= max:
            max = counts
            maxweek = week
    return list(filter(lambda x: x[5] == str(maxweek), ha))
            


inputfile = open('BrowserHistory.json')
data = json.load(inputfile)
history = data['Browser History']

outputfile = open('BrowserHistory.csv', 'w')
writer = csv.writer(outputfile)
history_array = [
        [
            elem['title'],
            elem['url'],
            parse_date(elem['time_usec'], 'date'),
            parse_date(elem['time_usec'], 'hour'),
            parse_date(elem['time_usec'], 'dayweek'),
            parse_date(elem['time_usec'], 'weekyear'),
            get_social_name(elem['url'])
        ] for elem in history if valid_social_network(elem['url'])]

ha_monday = filter_history(1, history_array)
ha_tuesday = filter_history(2, history_array)
ha_wednesday = filter_history(3, history_array)
ha_thursday = filter_history(4, history_array)
ha_friday = filter_history(5, history_array)
ha_saturday = filter_history(6, history_array)
ha_sunday = filter_history(0, history_array)

ha = ha_monday + ha_tuesday + ha_wednesday + ha_thursday + ha_friday + ha_saturday + ha_sunday

for row in ha:
    if row[4] == "0":
        row[4] = 7

for x in ha:
    outputfile.write("{},{},{},{},{}\n".format(x[6],x[2],x[3],x[4],x[5]))
