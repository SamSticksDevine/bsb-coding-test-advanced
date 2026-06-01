process INTERSECT_BED {

    publishDir "${params.outdir}/intersected", mode: 'copy'
    tag "${sample}"

    input:
    tuple val(sample), path(filtered_bed)
    path asisi

    output:
    tuple val(sample), path("*.intersected.bed")

    script:
    """
    bedtools intersect \
        -a ${filtered_bed} \
        -b ${asisi} \
        -wa \
        > ${filtered_bed.simpleName}.intersected.bed
    """

    stub:
    """
    touch ${filtered_bed.simpleName}.intersected.bed
    """
}