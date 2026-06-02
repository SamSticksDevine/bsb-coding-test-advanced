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

    // Validate required parameters early to fail fast
    if (!params.breaks) { error('ERROR: <breaks> not specified!') }
    if (!params.asisi_sites) { error('ERROR: <asisi_sites> not specified!') }
    if (!params.min_mapq) { error('ERROR: <min_mapq> not specified!') }

    // Create sample-channel pairs for downstream parallel processing
    breaks = Channel.fromPath("${params.breaks}/*.bed")
        .map { file ->
            def sample = file.name.replace(".breakends.bed", "")
            tuple(sample, file)
        }

    // Broadcast AsiSI sites file to all processes
    asisi = Channel.value(file(params.asisi_sites))

    // Step 1: filter low-quality reads
    filtered = FILTER_BED(breaks)

    // Step 2: intersect filtered reads with restriction sites
    intersected = INTERSECT_BED(filtered, asisi)

    // Join filtered + intersected outputs for downstream summarisation
    filtered_intersect = filtered.join(intersected)

    // Step 3: compute per-sample summary statistics
    summaries = SUMMARISE(filtered_intersect)

    // Step 4: collect all sample outputs into a single report
    COLLECT_RESULTS(summaries.collect())
}