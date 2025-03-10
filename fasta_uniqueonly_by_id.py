#!/usr/bin/python
##updated 2025-03-10 to address changes in how OrthoDB is handling duplicate names and things in its taxonomy files. For now, this script will ONLY keep genes originating from taxa that have a _0 - it may throw errors where taxa have no tax ID with a _0 and instead only _1 or _2, but these same rare/for viruses from what I can tell.
from Bio import SeqIO
import sys
import collections

input=list(SeqIO.parse(sys.argv[1], "fasta"))

#input=list(SeqIO.parse("fix.fasta", "fasta"))

record_ids = list()

for seq_record in input:
    seq_record2=seq_record.id
    new=seq_record2.split('_')
    newid=seq_record2.split(':')
    seq_record.id=newid[0]
    record_ids.append(new[0])

newrcords=set(record_ids)
to_keep = [x + "_0" for x in newrcords]


#print(record_ids)

# seen = {}
# dupes = list()

# for x in record_ids:
    # if x not in seen:
        # seen[x] = 1
    # else:
        # if seen[x] == 1:
            # dupes.append(x)
        # seen[x] += 1



for seq_record in input:
    if seq_record.id in to_keep:
     print(seq_record.format("fasta"))

#to_keep = list((set(record_ids)-set(dupes)))


#for seq_record in input:
#    if seq_record.id not in dupes:
#     print(seq_record.format("fasta"))


# my_list = list(set(record_ids))
#
#for seq_record in input:
#     if seq_record.id in to_keep:
#      print(seq_record.format("fasta"))
#
# for text in my_list:
#     if text in record_ids:
#         print(text)
