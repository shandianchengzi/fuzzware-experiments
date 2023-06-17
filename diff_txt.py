import sys
import os

from collections import Counter

def get_duplicate_counts(lst):
    counts = Counter(lst)
    duplicates = []
    for element, count in counts.items():
        duplicates.append(str((element, count))+'\n')
    return duplicates

def readfile(file):
    with open(file, "r") as f:
        content = f.readlines()
    return content

def diff(file1, file2):
    f1 = set(readfile(file1))
    f2 = set(readfile(file2))
    return f2-f1, f2|f1, f2

f1 = "all_edges.txt"
f2 = "now_edges.txt"
f3 = "new_edges.txt"
f4 = "whole_edges.txt"
project_dir = "/home/shandian/fuzzware/fuzzware-experiments/02-comparison-with-state-of-the-art/P2IM/Gateway/fuzzware-project-run-01"
input_list = os.path.join(project_dir, "stats/input_creation_timings.txt")

os.system(f"rm {f1} {f3} {f4}")
os.system(f"touch {f1} {f3} {f4}")
for input_info in readfile(input_list):
    input_time, input_file = input_info.split('\t')
    input_file_path = os.path.join(project_dir, input_file)
    os.system(f"rm {f2}")
    os.system(f"fuzzware replay -p {project_dir} {input_file_path}")
    new_edges, new_all_edges, edges = diff(f1, f2)

    with open(f1, "w") as f:
        f.writelines(list(new_all_edges))

    with open(f3, "a") as f:
        f.write(input_time+"\t"+input_file_path+"".join(new_edges))
        if len(new_edges) == 0:
            f.write("NONEWEDGE!!!\n")
    
    with open(f4, "a") as f:
        f.write(input_time+"\t"+input_file_path+"".join(get_duplicate_counts(edges)))