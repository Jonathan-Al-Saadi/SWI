%
%
%
% matNMR v. 3.9.94 - A processing toolbox for NMR/EPR under MATLAB
%
% Copyright (c) 1997-2009  Jacco van Beek
% jabe@users.sourceforge.net
%
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%
% --> gpl.txt
%
% Should yo be too lazy to do this, please remember:
%    - The code may be altered under the condition that all changes are clearly marked 
%      with your name and the date and that none of the names currently present in the 
%      code are removed.
%
% Furthermore:
%    -Please update the BugFixes.txt (i.e. the changelog file)!
%    -Please inform me of useful changes and annoying bugs!
%
% Jacco
%
%
% ====================================================================================
%
%
%Diffprint.m offers the possibility to print the results of a Diffusion fit on an array.
%All ui-controls are removed except for the parameter buQmatNMR.TTons which remain
%shown in the plot.
%30-09-'97

try
  global QmatNMR
  
  %find the right axis
  QTEMP = findobj(allchild(0), 'tag', 'DiffFitAxis');
  set(get(QTEMP, 'parent'), 'currentaxes', QTEMP)
  
  %define the string that needs to be plotted and put it in the screen
  QTEMP1 = 0;
  if (mod((length(QmatNMR.DiffFitResults.Parameters)-2), 2) == 0)
    npeaks = ((length(QmatNMR.DiffFitResults.Parameters)-2) / 2);
  
    s1 = sprintf('   Diffusion Fit Results :\n\n   Number of Exponentials  =  %d\n   Chi^2 =  %4.5e\n', npeaks, QmatNMR.DiffFitResults.Error);
    snew = s1;
    
    for teller = 1:npeaks
      s2 = sprintf('\n   Exponential %d:   Coefficient = %0.3g\n %s %6.3g %s\n', ...
                   teller, QmatNMR.DiffFitResults.Parameters(1+((teller-1)*2)),'                            \bfD             =',QmatNMR.DiffFitResults.Parameters(2+((teller-1)*2)),' \rm');
      snew = strcat(snew, s2);
      s1 = str2mat(s1, s2); 
    end
    
    s3 = sprintf('   Constant  =  %0.5g\n   Amplitude =  %0.7g\n\n\n', QmatNMR.DiffFitResults.Parameters(length(QmatNMR.DiffFitResults.Parameters)-1), QmatNMR.DiffFitResults.Parameters(length(QmatNMR.DiffFitResults.Parameters)));
    snew = strcat(snew, s3);
  
    QmatNMR.Xlim = get(QTEMP, 'xlim');
    QmatNMR.Ylim = get(QTEMP, 'ylim');
    
    %
    %place the text with the parameters in the middle of the axis
    %
    QTEMP4.posdata = [0 0 0];
    QTEMP1 = text('Parent', QTEMP, ...
         'BackGroundColor', QmatNMR.ColorScheme.Text1Back, ...
         'Color', QmatNMR.ColorScheme.Text1Fore, ...
         'EraseMode', 'normal', ...
         'units', 'normalized', ...
         'Position', [0.2 0.4 0], ...
         'String', snew,...
         'hittest', 'on', ...
         'fontsize', QmatNMR.TextSize-3, ...
         'userdata', QTEMP4, ...
         'buttondownfcn', 'ZoomMatNMR FitWindow off; MoveAxis');
  end
  
  %print the plot to the default printer
  %print -dps2 -noui
  pause(5)
  %delete the text object
  if (QTEMP1 > 0)
    delete(QTEMP1);
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
