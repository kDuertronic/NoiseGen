clc;
clear;
close all;

%       SCRIPT FOR IIR FILTER COEFFICIENTS COMPUTING            %

%%              Input parameters            %%

fs1 = 3e3;                                                                  % sampling frequency for lower cut-off freqs
fs2 = 25e3;                                                                 % sampling frequency for medium cut-off freqs
fs3 = 25e4;                                                                 % sampling frequency for higher cut-off freqs

fc1 = 100;                                                                  % cut-off freqs
fc2 = 1000;
fc3 = 5000;
fc4 = 10000;
fc5 = 25000;
fc6 = 100000;

order = 4;                                                                  % order of filter

%%              Filter coefficients         %%

[b1, a1] = butter(order, fc1/(fs1/2), 'low');                               % numerator & denominator coeffs
[b2, a2] = butter(order, fc2/(fs1/2), 'low');
[b3, a3] = butter(order, fc3/(fs2/2), 'low');
[b4, a4] = butter(order, fc4/(fs2/2), 'low');
[b5, a5] = butter(order, fc5/(fs3/2), 'low');
[b6, a6] = butter(order, fc6/(fs3/2), 'low');

[sos1, g1] = tf2sos(b1, a1);                                                % conversion to two-biquad-section model
[sos2, g2] = tf2sos(b2, a2);
[sos3, g3] = tf2sos(b3, a3);
[sos4, g4] = tf2sos(b4, a4);
[sos5, g5] = tf2sos(b5, a5);
[sos6, g6] = tf2sos(b6, a6);

%%              Definition of signal        %%

data = readmatrix('box_muller.txt');                                        % loading signal samples from .txt file
data = data - mean(data);                                                   % subtracting mean value of signal
N = length(data);                                                           % number of signal samples
t1 = (0:(N - 1))/fs1;                                                       % time vectors for proper sampling freqs
t2 = (0:(N - 1))/fs2;
t3 = (0:(N - 1))/fs3;

figure();                                                                   % plots of signal and its histogram
subplot(2, 1, 1);
plot(t1, data);
grid minor;
title("Time representation of noise signal");
ylabel("Voltage [V]");
xlabel("Time [s]");
subplot(2, 1, 2);
histogram(data);
grid on;
ylabel("Frequency of repeatable samples");
xlabel("Signal value [V]");
title("Histogram of noise signal");

%%              Filter tests                %%

sos1(1,1:3) = sos1(1,1:3) * g1;                                               % multiplying coeffs by filter gain
sos2(1,1:3) = sos2(1,1:3) * g2;
sos3(1,1:3) = sos3(1,1:3) * g3;
sos4(1,1:3) = sos4(1,1:3) * g4;
sos5(1,1:3) = sos5(1,1:3) * g5;
sos6(1,1:3) = sos6(1,1:3) * g6;

sos1 = single(sos1);                                                        % conversion to 32bit float C type
sos2 = single(sos2);
sos3 = single(sos3);
sos4 = single(sos4);
sos5 = single(sos5);
sos6 = single(sos6);

y1 = sosfilt(sos1, data);                                                   % filtration of signal
y2 = sosfilt(sos2, data);
y3 = sosfilt(sos3, data);
y4 = sosfilt(sos4, data);
y5 = sosfilt(sos5, data);
y6 = sosfilt(sos6, data);

figure;                                                                     % PSD for each case
subplot(3, 2, 1);
pwelch(y1, [], [], [], fs1);
title("PSD of signal 1 - 100 Hz");
grid minor;
subplot(3, 2, 2);
pwelch(y2, [], [], [], fs1);
title("PSD of signal 2 - 1 kHz");
grid minor;
subplot(3, 2, 3);
pwelch(y3, [], [], [], fs2);
title("PSD of signal 3 - 5 kHz");
grid minor;
subplot(3, 2, 4);
pwelch(y4, [], [], [], fs2);
title("PSD of signal 4 - 10 kHz");
grid minor;
subplot(3, 2, 5);
pwelch(y5, [], [], [], fs3);
title("PSD of signal 5 - 25 kHz");
grid minor;
subplot(3, 2, 6);
pwelch(y6, [], [], [], fs3);
title("PSD of signal 6 - 100 kHz");
grid minor;