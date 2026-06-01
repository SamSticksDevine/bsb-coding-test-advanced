process FILTER_BED {

    tag "${bed.simpleName}"

    input:
    path bed

    output:
    path "*.filtered.bed"

    script:
    """
    python ${projectDir}/bin/filter_bed.py \
        ${bed} \
        ${bed.simpleName}.filtered.bed
    """
}