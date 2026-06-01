process FILTER_BED {

    publishDir "${params.outdir}/filtered", mode: 'copy'
    tag "${sample}"

    input:
    tuple val(sample), path(bed)

    output:
    tuple val(sample), path("*.filtered.bed")

    script:
    """
    python ${baseDir}/bin/filter_bed.py \
        ${bed} \
        ${bed.simpleName}.filtered.bed \
        ${params.min_mapq}
    """

    stub:
    """
    touch ${bed.simpleName}.filtered.bed
    """
}