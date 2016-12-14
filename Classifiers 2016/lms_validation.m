% Copyright ©  2013  Lesley-Ann DUFLOT and Xavier Giro-i-Nieto
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.


function [far,frr]=lms_test(data,a,b,empty)

	true_boys=0;
	true_girls=0;
	false_boys=0;
	false_girls=0;

	% For each element in the dataset
	for i=1:size(data,1)

		% Read features
		x=data(i,1);
		y=data(i,2);

		% Estimate yp given x
		yp = a*x + b;
	    
		% If the estimated class is boy 
        if y*sign(a)<yp*sign(a)
			% ...and it is actually a boy
			if data(i,3)==0
				true_boys=true_boys+1;
            % ...but it is not a boy
			else
				false_boys=false_boys+1;
			end
		% If the estimated class is girl...
		else
			% ...and it is actually a girl
			if data(i,3)==1
				true_girls=true_girls+1;
            % ...but it is not a girl
			else
				false_girls=false_girls+1;
			end
		end
	end

	% Computation of False Acceptance Rate (FAR) and False Rejection Rate (FRR)
    total_girls = true_girls + false_girls;
    if total_girls > 0
        far = false_girls/total_girls;
    else
        far = 0;
    end
    
    total_boys = true_boys + false_boys;
    if total_boys > 0
        frr = false_boys/total_boys;
    else
        frr = 0;
    end
    
	% Define two arrays to store the data for boys and girls
	[boys, girls] = build_datasets(data);

	% Plot data
	
    if nargin<4
        figure(2);
        plot_samples('LMS Classifier with test data', boys, girls, a, b );
    end
end
