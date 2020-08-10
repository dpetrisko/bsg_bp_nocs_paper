#!/usr/bin/env python

import glob
import os

report_path = "current_build/synth/bsg_chip/reports"
area_report = "bsg_chip.mapped.area.rpt"

if __name__ == '__main__':
    print('networks,dims,flit_width,num_aux,aux_type,aux_width,aux_els,cell_area')
    for d in glob.glob('bsg_14.*'):
        report = d + '/' + report_path + '/' + area_report
        with open(report, 'r') as f:
            lines = f.read().splitlines()
            fields = d.replace('bsg_14.', '').replace('.',',')
            cell_area = filter(lambda l: 'Total cell area' in l, lines)[0].split(' ')[-1]
            print("{},{}".format(fields, cell_area))

