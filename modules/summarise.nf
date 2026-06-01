process SUMMARISE {

    publishDir "${params.outdir}/summary", mode: 'copy'
    tag "${sample}"

    input:
    tuple val(sample), path(filtered), path(intersected)

    output:
    path "${sample}.summary.tsv"

    script:
    """
    python ${baseDir}/bin/summarise.py \
        ${sample} \
        ${filtered} \
        ${intersected} \
        ${sample}.summary.tsv
    """

    stub:
    """
    touch ${sample}.summary.tsv
    """

}