import TextMapReduce
import sys

"""
Word Count Example in the Simple Python MapReduce Framework
"""

mr = TextMapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # value: line of text loaded as record
    value = record
    words = value.lower().split()
    words = [item.replace('!', '').replace('.', '').replace(',', '').replace('-', '').replace(':', '').replace('/', '').
                 replace("'", '').replace('"', '').replace('?', '').replace('_', '').replace('[', '').replace(']', '').
                 replace(';', '').replace('(', '').replace(')', '').replace('{', "").replace('}', '').replace('~', '').
                 replace('`', '').replace('@', '').replace('#', '').replace('$', '').replace('%', '').replace('^', '').
                 replace('&', '').replace('*', '').replace('+', '').replace('=', '').replace('|', '').replace('<', '').
                 replace('>', '') for item in words]
    for w in words:
        mr.emit_intermediate(w, 1)

def reducer(key, list_of_values):
    # key: word
    # value: list of occurrence counts
    total = 0
    for v in list_of_values:
      total += v
    mr.emit((key, total))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1], "r", encoding='utf-8')
  mr.execute(inputdata, mapper, reducer)
