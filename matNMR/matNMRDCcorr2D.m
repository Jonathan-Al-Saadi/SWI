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
% matNMRDCcorr2D
%
% syntax: MatrixOut = matNMRDCcorr2D(MatrixIn, Dimension, NoiseRange)
%
% Performs a DC offset correction by deducting the mean of the part of the spectrum 
% defined by <NoiseRange> from the 2D spectrum. <Dimension> specifies in which direction
% the action is applied.
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRDCcorr2D(MatrixIn, Dimension, NoiseRange)

%
%define an empty output variable by default
%
  MatrixOut = [];


%
%Check whether data is truly 2D
%
  if ((ndims(MatrixIn) == 2) & ~isa(MatrixIn, 'struct'))
    [SizeTD1, SizeTD2] = size(MatrixIn);

  else
    beep
    disp('matNMRDCcorr2D ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Check parameters
%
if ((Dimension ~= 1) & (Dimension ~= 2))
  beep
  disp('matNMRDCcorr2D ERROR: Dimension must be 1 or 2. Aborting ...');
  return
end


%
%The DC offset correction
%
  MatrixOut = MatrixIn;
  if (Dimension == 1)
    for QTEMP40 = 1:SizeTD1
      QTEMP = MatrixIn(QTEMP40, :);
      MatrixOut(QTEMP40, :) = QTEMP - mean(real(QTEMP(NoiseRange))) - sqrt(-1)*mean(imag(QTEMP(NoiseRange)));
    end
    
  elseif (Dimension == 2)
    for QTEMP40 = 1:SizeTD2
      QTEMP = MatrixIn(:, QTEMP40);
      MatrixOut(:, QTEMP40) = QTEMP - mean(real(QTEMP(NoiseRange))) - sqrt(-1)*mean(imag(QTEMP(NoiseRange)));
    end
  end