#!/usr/bin/env python3
#deconv_plot_essd.py
#Gabriele Tarchini - 24 March 2024

# This script generates FIGURE 12 of the DataPaper published in Earth Science System Data:
# A high-quality data set for seismological studies in the East Anatolian Fault Zone, Türkiye
# by L. Colavitti, D. Bindi, G. Tarchini, D. Scafidi, M. Picozzi and D. Spallarossa

####################################################
# SUMMARY:
# This script reads strong motion seismic data (SAC format) and corresponding
# Fourier Amplitude Spectra (FAS) from a seismic station in Turkey. It performs:
#
# - Extraction of FAS from a CSV file
# - Reading and processing of 3-component SAC waveform data (N-S, E-W, Z)
# - Instrument response removal using a station XML file (via ObsPy)
# - Detrending and tapering of waveforms
# - Plotting of:
#     * FAS curves (log-log scale)
#     * Time-domain waveforms with signal window overlay
#     * Combined figure with waveform and FAS for all components
####################################################

# INPUT FILES (REQUIRED):
# - ./230320154034/FAS_<station_code>_230320154034.txt : CSV file with FAS data
# - ./230320154034/sac/*.SAC                             : SAC waveform files
# - ./frequenze.txt                                      : Frequency array
# - ./xml/<station_code>.xml                             : Station metadata
#
# PARAMETERS:
# - station_code: seismic station identifier (e.g., 'HASA')
#
# OUTPUT:
# - Visualization of waveforms and spectra
# - Saved figure as <station_code>.pdf (600 dpi)
#
# DEPENDENCIES:
# - ObsPy
# - NumPy
# - pandas
# - matplotlib
# ==============================================================================

import obspy
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

station_code = 'HASA'

dati_fas = pd.read_csv('./230320154034/FAS_{0}_230320154034.txt'.format(station_code), sep=" ")
fas = dati_fas[['FAS_Z', 'FAS_NS', 'FAS_EW']]
fas_n = fas['FAS_NS'].to_numpy()
fas_e = fas['FAS_EW'].to_numpy()
fas_z = fas['FAS_Z'].to_numpy()

stream_n = obspy.read('./230320154034/sac/*.{0}..HHN.SAC'.format(station_code), debug_headers = True)
stream_e = obspy.read('./230320154034/sac/*.{0}..HHE.SAC'.format(station_code), debug_headers = True)
stream_z = obspy.read('./230320154034/sac/*.{0}..HHZ.SAC'.format(station_code), debug_headers = True)

stream = obspy.Stream(traces=[stream_n[0], stream_e[0], stream_z[0]])

tr_n = stream[0]
tr_e = stream[1]
tr_z = stream[2]

frequenze = pd.read_csv('./frequenze.txt', header = None)
f = frequenze[0].to_numpy()

T_S = float(format(float(format(dati_fas['TS'][0], '.3f')) + (34 - tr_n.stats.sac.nzsec), '.3f'))

len_n = float(format(dati_fas['LenNS'][0], '.1f'))
len_e = float(format(dati_fas['LenEW'][0], '.1f'))
len_z = float(format(dati_fas['LenZ'][0], '.1f'))

mask_start = T_S
mask_end_n = float(format(T_S + len_n, '.2f'))
mask_end_e = float(format(T_S + len_e, '.2f'))
mask_end_z = float(format(T_S + len_z, '.2f'))

freq = np.intersect1d(f, dati_fas['Freq'].values)

fig, (ax1, ax2, ax3) = plt.subplots(3, sharex=True, figsize=(10, 10))
ax1.plot(freq, fas_n)
ax2.plot(freq, fas_e, color='green')
ax3.plot(freq, fas_z, color='red')
ax1.set_title('FAS_NS', weight='bold')
ax2.set_title('FAS_EW', weight='bold')
ax3.set_title('FAS_Z', weight='bold')
fig.supxlabel('Frequency', weight='bold')
fig.supylabel('Amplitude', weight='bold')
fig.tight_layout()
plt.show()

#=============================================================================#

stream.plot()

t_n = np.arange(0, tr_n.stats.npts * tr_n.stats.delta, tr_n.stats.delta)
t_e = np.arange(0, tr_e.stats.npts * tr_e.stats.delta, tr_e.stats.delta)
t_z = np.arange(0, tr_z.stats.npts * tr_z.stats.delta, tr_z.stats.delta)

inv = obspy.read_inventory('./xml/{0}.xml'.format(station_code))

tr_n.detrend(type = 'linear')
tr_n.detrend(type = 'constant')
tr_n.taper(max_percentage = 0.05)

tr_n.remove_response(inventory = inv,
                   output='VEL',
                   pre_filt=(0.001, 0.005, 45, 50),
                   water_level=60,
                   zero_mean=True,
                   taper=True,
                   taper_fraction=0.05,
                   plot=True)
plt.show()

tr_n_backup = tr_n.copy()
tr_n.data *= 100

tr_e.detrend(type = 'linear')
tr_e.detrend(type = 'constant')
tr_e.taper(max_percentage = 0.05)

tr_e.remove_response(inventory = inv,
                   output='VEL',
                   pre_filt=(0.001, 0.005, 45, 50),
                   water_level=60,
                   zero_mean=True,
                   taper=True,
                   taper_fraction=0.05,
                   plot=True)
plt.show()

tr_e_backup = tr_e.copy()
tr_e.data *= 100

tr_z.detrend(type = 'linear')
tr_z.detrend(type = 'constant')
tr_z.taper(max_percentage = 0.05)

tr_z.remove_response(inventory = inv,
                   output='VEL',
                   pre_filt=(0.001, 0.005, 45, 50),
                   water_level=60,
                   zero_mean=True,
                   taper=True,
                   taper_fraction=0.05,
                   plot=True)
plt.show()

tr_z_backup = tr_z.copy()
tr_z.data *= 100

fig, axs = plt.subplots(3, 2, figsize=(10, 10))
axs[0, 0].plot(t_n[:(min(len(t_n), len(tr_n)))], tr_n[:(min(len(t_n), len(tr_n)))], 'k', linewidth=0.5)
axs[1, 0].plot(t_e[:(min(len(t_e), len(tr_e)))], tr_e[:(min(len(t_e), len(tr_e)))], 'k', linewidth=0.5)
axs[2, 0].plot(t_z[:(min(len(t_z), len(tr_z)))], tr_z[:(min(len(t_z), len(tr_z)))], 'k', linewidth=0.5)
axs[0, 0].grid(color='grey', alpha=0.25)
axs[1, 0].grid(color='grey', alpha=0.25)
axs[2, 0].grid(color='grey', alpha=0.25)
axs[0, 1].plot(freq, fas_n, 'k', linewidth=1)
axs[0, 1].set_xscale('log')
axs[0, 1].set_yscale('log')
axs[0, 1].grid(which='both', axis='x', color='grey', alpha=0.25)
axs[0, 1].grid(color='grey', axis='y', alpha=0.25)
axs[1, 1].plot(freq, fas_e, 'k', linewidth=1)
axs[1, 1].set_xscale('log')
axs[1, 1].set_yscale('log')
axs[1, 1].grid(which='both', axis='x', color='grey', alpha=0.25)
axs[1, 1].grid(color='grey', axis='y', alpha=0.25)
axs[2, 1].plot(freq, fas_z, 'k', linewidth=1)
axs[2, 1].set_xscale('log')
axs[2, 1].set_yscale('log')
axs[2, 1].grid(which='both', axis='x', color='grey', alpha=0.25)
axs[2, 1].grid(color='grey', axis='y', alpha=0.25)
axs[0, 0].axvspan(mask_start, mask_end_n, color='grey', alpha=0.3)
axs[1, 0].axvspan(mask_start, mask_end_e, color='grey', alpha=0.3)
axs[2, 0].axvspan(mask_start, mask_end_z, color='grey', alpha=0.3)
axs[0, 0].set_title('N-S', weight='bold', fontname='Arial', fontsize='25')
axs[1, 0].set_title('E-W', weight='bold', fontname='Arial', fontsize='25')
axs[2, 0].set_title('Z', weight='bold', fontname='Arial', fontsize='25')
axs[0, 1].set_title('FAS N-S', weight='bold', fontname='Arial', fontsize='25')
axs[1, 1].set_title('FAS E-W', weight='bold', fontname='Arial', fontsize='25')
axs[2, 1].set_title('FAS Z', weight='bold', fontname='Arial', fontsize='25')
axs[2, 0].set_xlabel('Time [s]', weight='bold', fontname='Arial', fontsize='20')
axs[0, 0].set_ylabel('A(t)', weight='bold', fontname='Arial', fontsize='15')
axs[1, 0].set_ylabel('A(t)', weight='bold', fontname='Arial', fontsize='15')
axs[2, 0].set_ylabel('A(t)', weight='bold', fontname='Arial', fontsize='15')
axs[2, 1].set_xlabel('Frequency [Hz]', weight='bold', fontname='Arial', fontsize='20')
axs[0, 1].set_ylabel('A(f)', weight='bold', fontname='Arial', fontsize='15')
axs[1, 1].set_ylabel('A(f)', weight='bold', fontname='Arial', fontsize='15')
axs[2, 1].set_ylabel('A(f)', weight='bold', fontname='Arial', fontsize='15')
fig.tight_layout()
plt.show()

fig.savefig('{0}.pdf'.format(station_code), dpi=600)

