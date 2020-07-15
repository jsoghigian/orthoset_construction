#note that this file splits based on a period because of very long headers created by Orthograph.
from Bio import SeqIO
import argparse

parser = argparse.ArgumentParser(description="Splits the fasta file into individual contigs")
parser.add_argument('-f', action='store', dest='fasta_file', help='Input fasta file')
parser.add_argument('-t', action='store', dest='extension', help='Output extension')
result = parser.parse_args()

f_open = open(result.fasta_file, "r")

for rec in SeqIO.parse(f_open, "fasta"):
   id = rec.id
   id_trim = id.split('.',2)[0]
   id_filename = id.split('.',2)[0] + "." + result.extension
   seq = rec.seq
   id_file = open(id_filename, "w")
   id_file.write(">"+str(id_trim)+"\n"+str(seq))
   id_file.close()

f_open.close()
