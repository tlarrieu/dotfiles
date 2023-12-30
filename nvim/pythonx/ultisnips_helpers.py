def camelize(string):
    return ''.join([x.capitalize() for x in string.split('_')])

def downcase(string):
    return ''.join([x.lower() for x in string.split('_')])
