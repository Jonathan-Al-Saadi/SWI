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
%
%matNMRSwapEcho1D
%
% syntax: MatrixOut = matNMRSwapEcho1d(MatrixIn, PositionEchoMaximum)
%
% allows time-shifting a whole-echo FID such that the maximum of the echo, denoted by <PositionEchoMaximum>
% is the first point of the new FID <MatrixOut>. All points before the maximum are put at the end of the FID.
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRSwapEcho1D(MatrixIn, PositionEchoMaximum)

%
%define an empty output variable by default
%
  MatrixOut = [];


%
%Check whether data is truly 1D
%
  if ((ndims(MatrixIn) == 2) & ~isa(MatrixIn, 'struct'))
    [SizeTD1, SizeTD2] = size(MatrixIn);
    if ((SizeTD1 ~= 1) & (SizeTD2 ~= 1))
      beep
      disp('matNMRSwapEcho1D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRSwapEcho1D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%Now swap the data.
%
  MatrixOut = [MatrixIn(PositionEchoMaximum:Size) MatrixIn(1:(PositionEchoMaximum-1))];
