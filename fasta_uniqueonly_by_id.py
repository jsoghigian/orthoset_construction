#!/usr/bin/python

from Bio import SeqIO
import sys
import collections

input=list(SeqIO.parse(sys.argv[1], "fasta"))

#input=list(SeqIO.parse("fix.fasta", "fasta"))

record_ids = list()

for seq_record in input:
    record_ids.append(seq_record.id)

#print(record_ids)

seen = {}
dupes = list()

for x in record_ids:
    if x not in seen:
        seen[x] = 1
    else:
        if seen[x] == 1:
            dupes.append(x)
        seen[x] += 1



for seq_record in input:
    if seq_record.id not in dupes:
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
