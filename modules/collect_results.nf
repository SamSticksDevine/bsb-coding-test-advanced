process COLLECT_RESULTS {

    publishDir "${params.outdir}", mode: 'copy'


    input:
    path summaries

    output:
    path "induce_seq_chr21_asisi_summary.tsv"

    script:
    """
    # take header from first file
    head -n 1 ${summaries[0]} > induce_seq_chr21_asisi_summary.tsv

    # append all data rows (skip headers)
    for f in ${summaries.join(' ')}; do
        tail -q -n +2 \$f >> induce_seq_chr21_asisi_summary.tsv
    done
    """    
    
    stub:
    """
    touch induce_seq_chr21_asisi_summary.tsv
    """
}