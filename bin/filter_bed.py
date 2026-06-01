#!/usr/bin/env python3

"""
Filter BED records by mapping quality.

Retains only records with MAPQ >= specified threshold.
"""

from pathlib import Path
import argparse

def filter_records(infile, min_mapq):
    """
    Generator yielding BED records with MAPQ >= min_mapq.
    """

    for line in infile:
        cols = line.rstrip().split("\t")

        if int(cols[4]) >= min_mapq:
            yield line

def parse_args():
    parser = argparse.ArgumentParser(
        description="Filter BED records by MAPQ"
    )

    parser.add_argument(
        "input_bed",
        type=Path,
        help="Input BED file"
    )

    parser.add_argument(
        "output_bed",
        type=Path,
        help="Output filtered BED file"
    )

    parser.add_argument(
        "min_mapq",
        type=int,
        help="Minimum MAPQ threshold"
    )

    return parser.parse_args()


if __name__ == "__main__":

    args = parse_args()

    with open(args.input_bed) as infile, open(args.output_bed, "w") as outfile:

        for line in filter_records(infile, args.min_mapq):
            outfile.write(line) 