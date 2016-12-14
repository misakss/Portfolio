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


function plot_lms( header, boys, girls, a, b )

	
	% Plot data samples
    plot(boys(:,1),boys(:,2),'r*')
    hold on
    plot(girls(:,1),girls(:,2),'bo')



    % Plot a green line representing the classifier

    samples=[ boys(:,1:2) ; girls(:,1:2) ];
    xx=[min(samples(:,1)):0.5:max(samples(:,1))]';
    yy=a*xx+b;

    hold on
    plot(xx,yy,'g')

    hx = xlabel('$height$','FontSize',15);
    set(hx,'Interpreter','Latex');
    hy = ylabel('$weight$','FontSize',15);
    set(hy,'Interpreter','Latex');
    %title( header,'Interpreter','Latex','FontSize',15);

    title(header)
    legend('Boys','Girls','Location','Best');
    axis([150 200 50 110 ]);
    % axis([min(samples(:,1)) max(samples(:,1)) min(samples(:,2)) max(samples(:,2)) ]);
end


