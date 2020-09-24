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
%restorepeaklist2.m restores all peaks and lines after a change of the axis vectors
%the difference with restorepeaklist3.m is that there the plot must be redrawn. That
%deletes the existing lines and therefore new handles must be created then.
%25-08-'98

try
  					%Check whether there is a peak list to restore
  QTEMP1 = size(QmatNMR.PeakList, 1);
  if (QTEMP1 > 0)
    %first put the first peak in the plot and then loop over the other values
        					%put text labels in new positions
    set(QmatNMR.PeakList(1, 4), 'Position', [QmatNMR.PeakList(1, 1:2) 0]);
  
    for QTel = 2:QTEMP1
        					%put text labels in new positions
      set(QmatNMR.PeakList(QTel, 4), 'Position', [QmatNMR.PeakList(QTel, 1:2) 0]);
      
      if (QmatNMR.PeakList(QTel, 5) > 0)		%draw lines between the last 2 peaks if needed
        set(QmatNMR.PeakList(QTel, 5), 'xdata', QmatNMR.PeakList( (QTel-1):(QTel), 1 ), 'ydata', QmatNMR.PeakList( (QTel-1):(QTel), 2 ));
      end
      
    end
  
    disp('Original peak list was restored');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end