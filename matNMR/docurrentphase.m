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
%docurrentphase.m handles the phase correction when jumping to another slice/column while setting the
%phase in a 2D spectrum. 
%5-12-'97

try
  QmatNMR.z = -((1:QmatNMR.Size1D)-QmatNMR.fase1startIndex)/(QmatNMR.Size1D);
  QmatNMR.i = sqrt(-1)*pi/180;
  if QmatNMR.fase2	%there is a second-order phase correction
    QmatNMR.z2 = -2*(((1:QmatNMR.Size1D)-floor(QmatNMR.Size1D/2)-1)/(QmatNMR.Size1D)).^2;
    QmatNMR.Spec1D = QmatNMR.Spec1D .* exp(QmatNMR.i*(QmatNMR.fase0 + QmatNMR.fase1*QmatNMR.z + QmatNMR.fase2*QmatNMR.z2));
  
  else
    QmatNMR.Spec1D = QmatNMR.Spec1D .* exp(QmatNMR.i*(QmatNMR.fase0 + QmatNMR.fase1*QmatNMR.z));
  end
  
  QmatNMR.dph0 = 0;
  QmatNMR.dph1 = 0;
  QmatNMR.dph2 = 0;
  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end