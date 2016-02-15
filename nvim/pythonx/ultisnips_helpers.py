def camelize(string):
    return ''.join([x.capitalize() for x in string.split('_')])
