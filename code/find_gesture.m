function percentage = find_gesture(E, P, Pi, ATest, ATrain, class)
% FIND_GESTURE() finds the proper prediction of gesture of test data
% Written by Qiong Wang at University of Pennsylvania
% 03/01/2014

sumProb = 0;
minProb = Inf;
for j = 1 : length(ATrain)
    prob = predict_hmm(ATrain{j}, P, E', Pi);
    if prob == -Inf
        continue;
    end
	if prob < minProb
		minProb = prob;
	end
	sumProb = sumProb + prob;
end
adaptiveThresh = 2 * sumProb / length(ATrain);
if adaptiveThresh < log(realmin)
    adaptiveThresh = log(realmin);
end

% fprintf('\n\n********************************************************************\n');
% fprintf('Testing %i sequences for a log likelihood greater than %f\n',length(ATest), adaptiveThresh);
% fprintf('********************************************************************\n\n');

count = 0;
predictProb = zeros(length(ATest),1);
for j = 1 : length(ATest)
	predictProb(j, 1) = predict_hmm(ATest{j}, P, E', Pi);
    if abs(predictProb(j, 1))  < 2
        predictProb(j, 1) = predictProb(j, 1) + log(realmin);
    end
	if (predictProb(j, 1) >= adaptiveThresh)
		count = count + 1;
% 		fprintf('Log likelihood: %f > %f (threshold) -- FOUND %s GESTURE!\n',predictProb(j,1),adaptiveThresh,class);
	else
% 		fprintf('Log likelihood: %f < %f (threshold) -- NO %s GESTURE.\n',predictProb(j,1),adaptiveThresh,class);
	end
end
percentage = 100 * count / length(ATest);
fprintf('\n Recognition precision for class "%s": %f percent \n', class, percentage);

end