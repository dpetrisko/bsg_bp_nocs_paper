#!/usr/bin/env python

import glob
import os

synth_report_path = "current_build/synth/bsg_chip/reports"
synth_report = "bsg_chip.mapped.qor.rpt"
pnr_report_path = "current_build/pnr/bsg_chip/reports"
place_design_report = "place_opt.report_design"
place_util_report = "place_opt.report_utilization"
pnr_design_report = "chip_finish.report_design"
pnr_util_report = "chip_finish.report_utilization"
pnr_qor_report = "chip_finish.report_qor"

if __name__ == '__main__':
    print('networks,dims,flit_width,aux_type,shift_els,side_length,synth_cell_area,synth_phys_area,place_cell_area,place_util,pnr_cell_area,pnr_util,pnr_drc,pnr_buffer,pnr_tns')
    for d in glob.glob('bsg_14.*'):
        fields = d.replace('bsg_14.', '').replace('.',',').replace('-','.')

        report = d + '/' + synth_report_path + '/' + synth_report
        try:
            with open(report, 'r') as f:
                lines = f.read().splitlines()

                synth_area = filter(lambda l: 'Cell Area' in l, lines)[0].split()[-1]
                synth_parea = filter(lambda l: 'Black Box' in l, lines)[0].split()[-1]
        except:
            synth_area = 0
            synth_parea = 0

        report = d + '/' + pnr_report_path + '/' + place_design_report
        try:
            with open(report, 'r') as f:
                lines = f.read().splitlines()
                place_area = filter(lambda l: 'Standard cells' in l, lines)[0].split()[4]
        except:
            place_area = 0

        report = d + '/' + pnr_report_path + '/' + place_util_report
        try:
            with open(report, 'r') as f:
                lines = f.read().splitlines()

                place_util = lines[-1]
        except:
            place_util = 0

        report = d + '/' + pnr_report_path + '/' + pnr_design_report
        try:
            with open(report, 'r') as f:
                lines = f.read().splitlines()
                pnr_area = filter(lambda l: 'Chip Area' in l, lines)[0].split()[-1]
                pnr_wires = filter(lambda l: 'Total wire' in l, lines)[0].split()[-2]
                pnr_drcs = filter(lambda l: 'DRCs' in l, lines)[0].split()[-1]
                pnr_buffer = filter(lambda l: 'Buffer/inverter' in l, lines)[0].split()[-3]
        except:
            pnr_area = 0
            pnr_wires = 0
            pnr_drcs = 0
            pnr_buffer = 0

        report = d + '/' + pnr_report_path + '/' + pnr_util_report
        try:
            with open(report, 'r') as f:
                lines = f.read().splitlines()

                pnr_util = lines[-1]
        except:
            pnr_util = 0

        report = d + '/' + pnr_report_path + '/' + pnr_qor_report
        try:
            with open(report, 'r') as f:
                lines = f.read().splitlines()
                pnr_tns = filter(lambda l: 'Design             (Setup)' in l, lines)[0].split()[3]
        except:
            pnr_tns = 0

        print("{},{},{},{},{},{},{},{},{}".format(fields, synth_area, synth_parea, place_area, place_util, pnr_area, pnr_util, pnr_drcs, pnr_buffer, pnr_tns))
