import yaml
import sys

[mod, tool] = sys.argv[1:]
di = yaml.safe_load('module_dependency.yaml')

outfile = 'file_list.txt'