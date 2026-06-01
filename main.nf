#!/usr/bin/env nextflow

/* ==============================================================================
INDUCE-seq Analysis
Processes BED files from INDUCE-seq experiments to output summarised DNA double strand breaks at AsiSI restriction sites on chromosome 21.
=================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Argument check
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

nextflow.enable.dsl=2

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Module load
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

include { FILTER_BED } from './modules/filter_bed'
include { INTERSECT_BED } from './modules/intersect_bed'
include { SUMMARISE } from './modules/summarise'
include { COLLECT_RESULTS } from './modules/collect_results'

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Main workflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

workflow {

    if (!params.breaks) { error('ERROR: <breaks> not specified!') }
    if (!params.asisi_sites) { error('ERROR: <asisi_sites> not specified!') }
    if (!params.min_mapq) { error('ERROR: <min_mapq> not specified!') }

    breaks = Channel.fromPath("${params.breaks}/*.bed")
        .map { file ->
            def sample = file.name.replace(".breakends.bed", "")
            tuple(sample, file)
        }

    asisi = Channel.value(file(params.asisi_sites))

    filtered = FILTER_BED(breaks)

    intersected = INTERSECT_BED( filtered, asisi )
    
    filtered_intersect = filtered.join(intersected)

    summaries = SUMMARISE( filtered_intersect )

    COLLECT_RESULTS(summaries.collect())
}