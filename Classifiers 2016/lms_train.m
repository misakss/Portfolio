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


function [a,b, boys, girls]=lms_train(data,empty)

	% Define two arrays to store the data for boys and girls
	[boys, girls] = build_datasets(data);
    
    if isempty(boys) | isempty(girls)
        a=1.0005;
        b=a;
    else
	% Estimate the a and b paramteres of the LMS classifier, where =ax+b

	x=[ boys(:,1:2) ; girls(:,1:2) ];
	t=[ones(size(boys,1),1);-ones(size(girls,1),1)];
	N=length(x);
	X=[ones(N,1) x];
	W=pinv(X)*t;
	a=-W(2)/W(3);
	b=-W(1)/W(3);

	% Plot data
	
    if nargin<2
        figure(1); 
        plot_samples('LMS Classifier with training data', boys, girls, a, b );
    end
    end
end
