import mne
import numpy
from NeuralynxIO import neuralynx_io
from trcio import write_raw_trc
from os import listdir 
from os.path import isfile, join, abspath
from scipy import signal
from scipy.io import savemat,loadmat
import multiprocessing


trunc_lfplist=[]
lfppath='/data/downstate/testdata/487_3_0030/micro'
lfpncsfiles = [f for f in listdir(lfppath) if isfile(join(lfppath, f))]
lfpncsfiles = sorted(lfpncsfiles, key=str.lower);
for x in range(len(lfpncsfiles)):
    if lfpncsfiles[x][0]=='G':
        trunc_lfplist.append(str(lfpncsfiles[x][4:len(lfpncsfiles[x])]))
    else:
        trunc_lfplist.append(lfpncsfiles[x])

for x in range(len(lfpncsfiles)):
    trunc_lfplist[x]=trunc_lfplist[x][0:len(trunc_lfplist[x])-9]

ncsfilepath=[]
for x in range(0,len(lfpncsfiles)):
    ncsfilepath.append(join(lfppath,lfpncsfiles[x]))

lfpdata_np=loadmat("/data/downstate/testdata/487_3_0030/matnlxout6.mat")
lfpdata=lfpdata_np['eeg']

lfpdata *= 1e-7 #1e-6
n_channels = 80
sampling_freq = 2000
ch_names = trunc_lfplist
ch_types='eeg'
info = mne.create_info(ch_names=ch_names, ch_types=ch_types, sfreq=sampling_freq)
MNE_lfp = mne.io.RawArray(lfpdata,info) 
MNE_lfp_t=MNE_lfp
#MNE_lfp_t.crop(2400,3000).load_data() 
write_raw_trc(MNE_lfp_t,'/data/downstate/testdata/487_3_0030/micro/TRC/487_3microb6_test.TRC')

print("done")