import sys

def ParseFields(line):
    fields = {}
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields


if __name__ == "__main__":
    infile="/work/projects/melanomics/data/activeDriver/gene_symbol_to_refseq.tab"
    var_file = "/work/projects/melanomics/analysis/genome/variants2/filter/patient_2/somatic/patient_2.somatic.testvariants.annotated.short.aachanging"

    transcripts = set()
    with open(infile) as f:
        next(f)
        for line in f:
            line = line.split()
            transcript = line[-1][1:-1]
            transcripts.add(transcript)


    num_transcript_found = 0
    num_genes = 0
    num_no_annotation = 0
    num_transcript_not_found = 0

    with open(var_file) as f:
        var = ParseFields(next(f))

        for line in f:
            line = line.split("\t")
            aa_changes = line[var['AAChange.refGene']]
            num_genes += 1
            if not aa_changes or aa_changes=="UNKNOWN":
                num_no_annotation += 1
                continue

            aa_changes = aa_changes.split(",")
            #print aa_changes

            transcript_found = False

            for change in aa_changes:
                change = change.split(":")
                transcript = change[1]
                if transcript in transcripts:
                    print change[0], change[-1]
                    transcript_found = True

            if transcript_found:
                num_transcript_found += 1
            else:
                sys.stderr.write("[WARNING]: Transcript not found - %s\n" % aa_changes[0])
                num_transcript_not_found += 1

sys.stderr.write("SUMMARY:\n")
sys.stderr.write("Number of genes = %d\n" % num_genes)
sys.stderr.write("Number of transcripts found = %d\n" % num_transcript_found)
sys.stderr.write("Number of transcripts not found = %d\n" % num_transcript_not_found)
sys.stderr.write("Number of transcripts not annotated = %d\n" % num_no_annotation)






