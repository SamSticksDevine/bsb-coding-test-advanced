#!/usr/bin/env python3

import sys
import argparse


def count_lines(file_path):
    """Count number of records in a BED file."""
    with open(file_path) as f:
        return sum(1 for _ in f)

def parse_args():

    parser = argparse.ArgumentParser(
        description="Summarise INDUCE-seq AsiSI break counts"
    )

    parser.add_argument(
        "sample_id",
        type=str,
        help="Sample identifier"
    )

    parser.add_argument(
        "filtered_bed",
        type=str,
        help="Filtered BED file (all breaks)"
    )

    parser.add_argument(
        "intersected_bed",
        type=str,
        help="BED file of AsiSI-overlapping breaks"
    )

    parser.add_argument(
        "output_tsv",
        type=str,
        help="Output summary TSV file"
    )

    return parser.parse_args()

if __name__ == "__main__":
   
    args = parse_args()

    total_breaks = count_lines(args.filtered_bed)
    asisi_breaks = count_lines(args.intersected_bed)

    # avoid division by zero (safe guard)
    if total_breaks == 0:
        norm = 0
    else:
        norm = asisi_breaks / (total_breaks / 1000)

    with open(args.output_tsv, "w") as out:

        out.write(
            "sample\tasisi_breaks\ttotal_breaks\tnormalised\n"
        )

        out.write(
            f"{args.sample_id}\t{asisi_breaks}\t{total_breaks}\t{norm:.4f}\n"
        )