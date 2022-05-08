n_samples = 240;
t = linspace(0,24,n_samples);

tr_test_weekdays1 = zeros(n_samples,1);
tr_test_weekends1 = zeros(n_samples,1);
tr_test_weekdays2 = zeros(n_samples,1);
tr_test_weekends2 = zeros(n_samples,1);
for i=1:n_samples
    tr_test_weekdays1(i) = weekdays1(t(i));
    tr_test_weekends1(i) = weekend1(t(i));
    tr_test_weekdays2(i) = weekdays2(t(i));
    tr_test_weekends2(i) = weekend2(t(i));
end

plot(t,tr_test_weekdays1,t,tr_test_weekends1)
hold on
plot(t,tr_test_weekdays2,t,tr_test_weekends2)


function h = weekend1(x)
term1 = 0.02779 * exp(-((x-4.687)/0.3328)^2);
term2 = 0.1302 * exp(-((x-5.841)/2.755)^2);
term3 = 0.2285 * exp(-((x-14.23)/8.285)^2);
term4 = -0.06644 * exp(-((x-3.656)/0.9236)^2);
term5 = 2.698 * exp(-((x-3.777)/4.321)^2);
term6 = -2.02 * exp(-((x-3.629)/4.178)^2);
term7 = 8.16 * 10^6*exp(-((x-106.8)/20.03)^2);
result = term1+term2+term3+term4+term5+term6+term7;
h = result;
end

function g = weekdays1(x)
term1 = 3.263 * 10^6*exp(-((x-75.27)/12.56)^2);
term2 = 0.0781 * exp(-((x-3.85)/0.4829)^2);
term3 = 0.6616 * exp(-((x-4.971)/1.77)^2);
term4 = 0.1097 * exp(-((x-2.996)/0.862)^2);
term5 = 0.2584 * exp(-((x-1.868)/1.543)^2);
term6 = 0.1822 * exp(-((x-3.221)/5.972)^2);
term7 = 0.1652 * exp(-((x-(-2.871))/84)^2);
result = term1+term2+term3+term4+term5+term6+term7;
g = result;
end

%% DU-2
function h = weekend2(x)
term1 = 0.04779 * exp(-((x-4.687)/0.3328)^2);
term2 = 0.802 * exp(-((x-5.841)/2.755)^2);
term3 = 0.1285 * exp(-((x-14.23)/8.285)^2);
term4 = -0.1644 * exp(-((x-3.656)/0.9236)^2);
term5 = 3.698 * exp(-((x-3.777)/4.321)^2);
term6 = -3.12 * exp(-((x-3.629)/4.178)^2);
term7 = 8.56 * 10^6*exp(-((x-106.8)/20.03)^2);
result = term1+term2+term3+term4+term5+term6+term7;
h = result;
end

function g = weekdays2(x)
term1 = 3.563 * 10^6*exp(-((x-75.27)/12.56)^2);
term2 = 0.0881 * exp(-((x-3.85)/0.4829)^2);
term3 = 0.5616 * exp(-((x-4.971)/1.77)^2);
term4 = 0.2097 * exp(-((x-2.996)/0.862)^2);
term5 = 0.3584 * exp(-((x-1.868)/1.543)^2);
term6 = 0.4822 * exp(-((x-3.221)/5.972)^2);
term7 = 0.0652 * exp(-((x-(-2.871))/84)^2);
result = term1+term2+term3+term4+term5+term6+term7;
g = result;
end




