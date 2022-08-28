clear
lfppath='/data/downstate/testdata/487_3_0030/micro/';
files = dir(fullfile(lfppath, '*.*'));
filenames={files.name}
filenames=filenames(3:numel(filenames))';
filenames=sort(filenames);

i=1;
lfp=[]
parfor j=1:numel(filenames)
    fname=strcat(lfppath,filenames{j})
    [timestamps,dataSamples, header] = getRawCSCData(fname,(((i-1)*(40000*600))+1),(i*(40000*600)));
    dataSamples=resample(dataSamples,1,20);
    dataSamples=dataSamples';
    lfp=vertcat(lfp,dataSamples);
    j
end;

for i=1:6
    lfp_temp=lfp(:,(1+((i-1)*(600*2000))):(i*(600*2000)));
    [eeg]=microica(lfp_temp);
    outfilename=[lfppath 'matnlxout' num2str(i) '.mat'];
    save(outfilename,'eeg');
end;

