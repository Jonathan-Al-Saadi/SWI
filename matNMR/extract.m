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
%extract.m lets the user extract a part from a 2D contour plot by drawing a box around it
%13-10-'98

try
  QmatNMR.MouseButton = 0;
  
  if (any(get(QmatNMR.AxisHandle2D3D,'view')==[0 90]))
    ZoomMatNMR 2D3DViewer off;		%disable the zoom function
    set(QmatNMR.c10, 'value', 0);
    QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
    QTEMP1.Zoom = 0;
    set(QmatNMR.Fig2D3D, 'userdata', QTEMP1);
  end;  
  
  view(2);			%make sure it is in 2D view --> turn rotate3d off !
  Rotate3DmatNMR off;
  set(QmatNMR.c16, 'value', 0);
  
  set(QmatNMR.Fig2D3D, 'Pointer', 'crosshair');
  
  			%initialize extraction routine (same as integrating routine initially)
  Extract2D(1);
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end