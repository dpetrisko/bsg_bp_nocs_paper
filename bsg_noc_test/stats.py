#!/usr/bin/env python

import glob
import os

synth_report_path = "current_build/synth/bsg_chip/reports"
synth_report = "bsg_chip.mapped.qor.rpt"
pnr_report_path = "current_build/pnr/bsg_chip/reports"
pnr_design_report = "chip_finish.report_design"
pnr_util_report = "chip_finish.report_utilization"

if __name__ == '__main__':
    print('networks,dims,flit_width,num_aux,aux_type,aux_width,aux_els,synth_area,pnr_area,wire_length,util,drcs')
    for d in glob.glob('bsg_14.*'):
        fields = d.replace('bsg_14.', '').replace('.',',')

        report = d + '/' + synth_report_path + '/' + synth_report
        try:
            with open(report, 'r') as f:
                lines = f.read().splitlines()

                synth_area = filter(lambda l: 'Cell Area' in l, lines)[0].split(' ')[-1]
        except:
            synth_area = 0

        report = d + '/' + pnr_report_path + '/' + pnr_design_report
        try:
            with open(report, 'r') as f:
                lines = f.read().splitlines()

                pnr_area = filter(lambda l: 'Chip Area' in l, lines)[0].split(' ')[-1]
                pnr_wires = filter(lambda l: 'Total wire' in l, lines)[0].split(' ')[-2]
                pnr_drcs = filter(lambda l: 'DRCs' in l, lines)[0].split(' ')[-1]
        except:
            pnr_area = 0
            pnr_wires = 0
            pnr_drcs = 0

        report = d + '/' + pnr_report_path + '/' + pnr_util_report
        try:
            with open(report, 'r') as f:
                lines = f.read().splitlines()

                pnr_util = lines[-1]
        except:
            pnr_util = 0



        print("{},{},{},{},{},{}".format(fields, synth_area, pnr_area, pnr_wires, pnr_util, pnr_drcs))
