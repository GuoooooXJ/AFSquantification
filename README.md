# AFSquantification
A method to jointly quantify amplitude and frequency stability information in neural signals.

Using the AFS quantification based on staionary wavelet coefficients to estimate neural activities. The optimal minimaxi criterion has been utilized.

# How to use
To test the method in Matlab, make sure all codes are in the same folder. DBS.m is the main function to test the algrithm in DBS dataset (https://data.mrc.ox.ac.uk/stn-lfp-on-off-and-dbs) which compared AFS, amplitude and frequency stability.


Synestimate.m is the AFS function.
Estimation.m and controChart.m are called in Synestimate.m.
Bandpass.m is the bandpass filter.