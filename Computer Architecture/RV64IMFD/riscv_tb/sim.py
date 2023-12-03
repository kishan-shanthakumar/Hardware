from pyyaml import yaml
import sys

mod = sys.argv(0)
tool = sys.argv(1)
di = yaml.safeload('module_dependency.yaml')

outfile = 'file_list.txt'