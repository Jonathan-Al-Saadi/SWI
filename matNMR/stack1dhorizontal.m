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
%stack1dhorizontal.m makes a 1D stack plot of the current 2D spectrum by glueing all columns 
%into one large 1D vector and plotting it. If the spectrum is zoomed only the zoomed area is taken !
%
%1-5-'97
%name changed on 07-07-2004  

try
  watch;
  
  if (QmatNMR.Dim == 0) | (QmatNMR.PlotType ~= 1)
    disp('matNMR NOTICE: Cannot make a horziontal stack plot from a 1D view. Please select a row/column from a 2D.');
    Arrowhead
  
  elseif (QmatNMR.DisplayMode == 3)
    disp('matNMR NOTICE: Cannot make a horizontal stack plot in display mode "both"');
    Arrowhead
  
  else
    %get the axis handle
    QmatNMR.TEMPAxis = gca;
  
    QmatNMR.TEMPDim = QmatNMR.Dim;		%temporary variable
  
    %
    %first determine the exact limits based on the current zoom settings
    %
    %
    %NOTE: DO NOT USE QmatNMR.numX variables anywhere else and DO NOT RENAME them, without also
    %changing the dual display routine.
    %
    QmatNMR.num3 = round( abs(QmatNMR.totaalX / QmatNMR.Rincr)  );	%the span of the range we want to stack
      
    if (QmatNMR.Rincr>0)					%determine the starting point in the data matrix
      QmatNMR.num4 = round( (QmatNMR.xmin - QmatNMR.Rnull) / QmatNMR.Rincr );	%from the current axis limits and the axis vector
   
    else
      QmatNMR.num4 = round( (QmatNMR.xmin+QmatNMR.totaalX - QmatNMR.Rnull) / QmatNMR.Rincr );
    end
  
  
    %
    %make sure that the range doesn't extend beyond the size of the matrix
    %
    if (QmatNMR.num4 < 1)
      QmatNMR.num3 = QmatNMR.num3 + QmatNMR.num4;
      QmatNMR.num4 = 1;
    end
    if (QmatNMR.num4 + QmatNMR.num3 > QmatNMR.Size1D)
      QmatNMR.num3 = QmatNMR.Size1D - QmatNMR.num4;
    end
  
  
    %
    %take a certain number of points extra as NaN
    %
    QmatNMR.num9 = ceil(0.10 * QmatNMR.num3);
    if (QmatNMR.num9<10)					%to create empty spaces between the slices
      QmatNMR.num9 = 2*QmatNMR.num9;
    end
  
  
    %
    %then select the proper parts from the 2D and reshape into a 1D
    %
    if (QmatNMR.Dim == 1)
      [QmatNMR.num2 QTEMP20] = size(QmatNMR.Spec2D);
  
      QmatNMR.num  = (length(QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3+QmatNMR.num9))*QmatNMR.num2);	%this is the total number of points (data points + extra)*NrSlices
  
      %
      %We need to flip the spectrum according to the axis increment and the FIDstatus
      %Also, extract the part we need, based on the current zoom limits
      %
      if (QmatNMR.FIDstatus == 1)			%means it's a spectrum
        if (QmatNMR.Rincr > 0)			%ascending axis
          QTEMP1 = QmatNMR.Spec2D;
          QmatNMR.num10 = QTEMP1(1:QmatNMR.num2, QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3)).';	%these are the data points we want to show
        
        else						%descending axis
          QTEMP1 = QmatNMR.Spec2D;
          QmatNMR.num10 = QTEMP1(1:QmatNMR.num2, QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3)).';	%these are the data points we want to show
        end  
      
      else						%it's an FID
        if (QmatNMR.Rincr > 0)			%ascending axis
          QTEMP1 = fliplr(QmatNMR.Spec2D);
          QmatNMR.num10 = QTEMP1(1:QmatNMR.num2, sort(QmatNMR.Size1D + 1 - (QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3)))).';	%these are the data points we want to show
        
        else						%descending axis
          QTEMP1 = QmatNMR.Spec2D;
          QmatNMR.num10 = QTEMP1(1:QmatNMR.num2, QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3)).';	%these are the data points we want to show
        end  
      end  
      QmatNMR.num10( (QmatNMR.num3+2):(QmatNMR.num3+1+QmatNMR.num9), :) = NaN + sqrt(-1)*NaN;	%these are the extra points as NaN
  
    else
      [QTEMP20 QmatNMR.num2] = size(QmatNMR.Spec2D);
  
      QmatNMR.num  = (length(QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3+QmatNMR.num9))*QmatNMR.num2);	%this is the total number of points (data points + extra)*NrSlices
  
      %
      %We need to flip the spectrum according to the axis increment and the FIDstatus
      %Also, extract the part we need, based on the current zoom limits
      %
      if (QmatNMR.FIDstatus == 1)			%means it's a spectrum
        if (QmatNMR.Rincr > 0)			%ascending axis
          QTEMP1 = QmatNMR.Spec2D;
          QmatNMR.num10 = QTEMP1(QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3), 1:QmatNMR.num2);      %these are the data points we want to show
        
        else						%descending axis
          QTEMP1 = QmatNMR.Spec2D;
          QmatNMR.num10 = QTEMP1(QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3), 1:QmatNMR.num2);      %these are the data points we want to show
        end  
      
      else						%it's an FID
        if (QmatNMR.Rincr > 0)			%ascending axis
          QTEMP1 = flipud(QmatNMR.Spec2D);
          QmatNMR.num10 = QTEMP1(sort(QmatNMR.Size1D + 1 - (QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3))), 1:QmatNMR.num2);      %these are the data points we want to show
        
        else						%descending axis
          QTEMP1 = QmatNMR.Spec2D;
          QmatNMR.num10 = QTEMP1(QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3), 1:QmatNMR.num2);      %these are the data points we want to show
        end  
      end  
      QmatNMR.num10( (QmatNMR.num3+2):(QmatNMR.num3+1+QmatNMR.num9), :) = NaN + sqrt(-1)*NaN;      	%these are the extra points as NaN
    end
    QTEMP1 = [];
  
  
    %
    %take the current display mode into account
    %
    switch (QmatNMR.DisplayMode)
      case 1    %Real spectrum
        QmatNMR.num10 = real(QmatNMR.num10);
      
      case 2    %Imaginary spectrum
        QmatNMR.num10 = imag(QmatNMR.num10);
  
      case 3    %Both Real and Imaginary spectrum together
        disp('matNMR NOTICE: cannot do horizontal stack plot in "both" mode. Only showing real part!');
        QmatNMR.num10 = real(QmatNMR.num10);
  
      case 4    %Absolute spectrum
        QmatNMR.num10 = abs(QmatNMR.num10);
  
      case 5    %Power spectrum
        QmatNMR.num10 = abs(QmatNMR.num10).^2;
  
      otherwise
        disp('matNMR ERROR: unknown value for QDisplayMode!');
        disp('matNMR ERROR: Abort ...');
        return
    end	   
  
  						%set some parameters for plotting
    QmatNMR.texie = 'user-defined axis';
    QmatNMR.RulerXAxis = 1; 		%since this is a user-defined axis in points!
    
    %
    %add this to the processing history
    %
    QmatNMR.History = str2mat(QmatNMR.History, 'Horizontal stack plot created from the current view');
  
    if (QmatNMR.Dim == 0)
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
  
    elseif (QmatNMR.Dim == 1)
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
    else
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 401);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 700, QmatNMR.Dim, QmatNMR.SF1D, QmatNMR.SW1D, QmatNMR.xmin, QmatNMR.totaalX, QmatNMR.ymin, QmatNMR.totaalY);	%code for stack1d, dimension, QmatNMR.xmin, QmatNMR.xmin+QmatNMR.totaalX, QmatNMR.ymin, QmatNMR.ymin+QmatNMR.totaalY
    
    if (QmatNMR.RecordingPlottingMacro | QmatNMR.RecordingMacro)
      if (QmatNMR.Dim == 0)
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
  
      elseif (QmatNMR.Dim == 1)
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 401);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 700, QmatNMR.Dim, QmatNMR.SF1D, QmatNMR.SW1D, QmatNMR.xmin, QmatNMR.totaalX, QmatNMR.ymin, QmatNMR.totaalY);  	%code for stack1d, dimension, QmatNMR.xmin, QmatNMR.xmin+QmatNMR.totaalX, QmatNMR.ymin, QmatNMR.ymin+QmatNMR.totaalY
    end
  
  
    if (~QmatNMR.BusyWithMacro)		%unless we are processing a macro, we reset the mouse pointer and the 1D undo matrix
      %clear the previous 1D undo matrix
      QmatNMR.UnDoMatrix1D = GenerateMatNMRStructure;
      
      Arrowhead;
    end
  
  
    %
    %Create the plot
    %
    QmatNMR.Stack1DHorizontalAxis = 1:QmatNMR.num;
    QmatNMR.Stack1DHorizontalSpec = real(reshape(fliplr(QmatNMR.num10), 1, QmatNMR.num));
    QTEMP8 = plot(QmatNMR.Stack1DHorizontalAxis, QmatNMR.Stack1DHorizontalSpec, [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]);
  
    set(QTEMP8, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', ...
                'MoveLine', 'hittest', 'on', 'Tag', QmatNMR.LineTag);
  
    set(QmatNMR.TEMPAxis, 'FontSize', QmatNMR.TextSize, ...
         'FontName', QmatNMR.TextFont, ...
         'FontAngle', QmatNMR.TextAngle, ...
         'FontWeight', QmatNMR.TextWeight, ...
         'LineWidth', QmatNMR.LineWidth, ...
         'Color', QmatNMR.ColorScheme.AxisBack, ...
         'xcolor', QmatNMR.ColorScheme.AxisFore, ...
         'ycolor', QmatNMR.ColorScheme.AxisFore, ...
         'zcolor', QmatNMR.ColorScheme.AxisFore, ...
         'box', 'on', ...
         'tag', 'MainAxis', ...
         'userdata', 1, ...
         'view', [0 90], ...
         'visible', 'on', ...
         'xscale', 'linear', ...
         'yscale', 'linear', ...
         'zscale', 'linear', ...
         'xticklabelmode', 'auto', ...
         'yticklabelmode', 'auto', ...
         'zticklabelmode', 'auto', ...
         'XDir', 'reverse');		%CheckAxis.m determines whether the direction should be normal or reverse
  
  
    %
    %Now we set the axis limits. In case the display mode has been set to 'both' then we need to do
    %	take both the real and imaginary into account. This requires special care.
    %
      axis auto
      DetermineNewAxisLimits
      QmatNMR.xmin = 1;
      QmatNMR.totaalX = QmatNMR.num-1;
    
    
    %
    %set the axis limits properly and also set the ApplicationData such that the zoom function uses the new values
    %
    axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
    setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
  
  
    %
    %Finally adapt the tick labels to show the values in units of the axis in the other dimension
    %
    QmatNMR.num5 = QmatNMR.num3+1;	      %total number of data points per slice
    QmatNMR.num6 = round(QmatNMR.num2/20);    %if there are more than 20 points per slice then we try to limit the
    if (QmatNMR.num6 == 0)	      %number of ticks in the plot
      QmatNMR.num6 = 1;
    end
  
    %change the tick labels corresponding to the axis in the other dimension
    if (QmatNMR.TEMPDim == 1)	      %TD2
      %
      %in the following part we distinguish two cases: 1) all values in the axis vector are integers
      %and 2) there are decimals involved. In the latter case we restrict the output to two decimals!
      %
      QTEMP9 = QmatNMR.AxisTD1(end:-QmatNMR.num6:1);
      if (QTEMP9 == round(QTEMP9))
        set(QmatNMR.TEMPAxis, 'xtick', [(QmatNMR.num5/2):(QmatNMR.num5+QmatNMR.num9)*QmatNMR.num6:((QmatNMR.num2-1)*(QmatNMR.num5+QmatNMR.num9)+QmatNMR.num5/2+QmatNMR.num9)], 'xticklabel', QmatNMR.AxisTD1(end:-QmatNMR.num6:1));
      else		      %we need to restrict the output to two decimals to avoid crowding of the tick labels
        QTEMP12 = 0;
        for QTEMP11=1:length(QTEMP9)
          %check out if we can shorten the output by supplying typical
          %units
          if (log10(abs(QTEMP9(QTEMP11))) >= -19)
            QTEMP14 = 1e-18;
            QTEMP15 = 'a';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -16)
            QTEMP14 = 1e-15;
            QTEMP15 = 'f';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -13)
            QTEMP14 = 1e-12;
            QTEMP15 = 'p';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -10)
            QTEMP14 = 1e-9;
            QTEMP15 = 'n';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -7)
            QTEMP14 = 1e-6;
            QTEMP15 = 'mu';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -4)
            QTEMP14 = 1e-3;
            QTEMP15 = 'm';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -1)
            QTEMP14 = 1;
            QTEMP15 = '';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= 2)
            QTEMP14 = 1e3;
            QTEMP15 = 'k';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= 5)
            QTEMP14 = 1e6;
            QTEMP15 = 'M';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= 8)
            QTEMP14 = 1e9;
            QTEMP15 = 'G';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= 11)
            QTEMP14 = 1e12;
            QTEMP15 = 'T';
          end
          
          if (QTEMP11 == 1)
            QTEMP10 = sprintf('%0.1f%s', QTEMP9(QTEMP11)/QTEMP14, QTEMP15);
          else
            QTEMP10 = str2mat(QTEMP10, sprintf('%0.1f%s', QTEMP9(QTEMP11)/QTEMP14, QTEMP15));
          end
        end
  
        set(QmatNMR.TEMPAxis, 'xtick', [(QmatNMR.num5/2):(QmatNMR.num5+QmatNMR.num9)*QmatNMR.num6:((QmatNMR.num2-1)*(QmatNMR.num5+QmatNMR.num9)+QmatNMR.num5/2+QmatNMR.num9)], 'xticklabel', QTEMP10);
      end
  
    else  		      %TD1
      %
      %in the following part we distinguish two cases: 1) all values in the axis vector are integers
      %and 2) there are decimals involved. In the latter case we restrict the output to two decimals!
      %
      QTEMP9 = QmatNMR.AxisTD2(end:-QmatNMR.num6:1);
      if (QTEMP9 == round(QTEMP9))
        set(QmatNMR.TEMPAxis, 'xtick', [(QmatNMR.num5/2):(QmatNMR.num5+QmatNMR.num9)*QmatNMR.num6:((QmatNMR.num2-1)*(QmatNMR.num5+QmatNMR.num9)+QmatNMR.num5/2+QmatNMR.num9)], 'xticklabel', QmatNMR.AxisTD2(end:-QmatNMR.num6:1));
      else		      %we need to restrict the output to two decimals to avoid crowding of the tick labels
        QTEMP12 = 0;
        for QTEMP11=1:length(QTEMP9)
          %check out if we can shorten the output by supplying typical
          %units
          if (log10(abs(QTEMP9(QTEMP11))) >= -19)
            QTEMP14 = 1e-18;
            QTEMP15 = 'a';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -16)
            QTEMP14 = 1e-15;
            QTEMP15 = 'f';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -13)
            QTEMP14 = 1e-12;
            QTEMP15 = 'p';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -10)
            QTEMP14 = 1e-9;
            QTEMP15 = 'n';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -7)
            QTEMP14 = 1e-6;
            QTEMP15 = 'mu';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -4)
            QTEMP14 = 1e-3;
            QTEMP15 = 'm';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= -1)
            QTEMP14 = 1;
            QTEMP15 = '';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= 2)
            QTEMP14 = 1e3;
            QTEMP15 = 'k';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= 5)
            QTEMP14 = 1e6;
            QTEMP15 = 'M';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= 8)
            QTEMP14 = 1e9;
            QTEMP15 = 'G';
          end
          
          if (log10(abs(QTEMP9(QTEMP11))) >= 11)
            QTEMP14 = 1e12;
            QTEMP15 = 'T';
          end
          
          if (QTEMP11 == 1)
            QTEMP10 = sprintf('%0.1f%s', QTEMP9(QTEMP11)/QTEMP14, QTEMP15);
          else
            QTEMP10 = str2mat(QTEMP10, sprintf('%0.1f%s', QTEMP9(QTEMP11)/QTEMP14, QTEMP15));
          end
        end
  
        set(QmatNMR.TEMPAxis, 'xtick', [(QmatNMR.num5/2):(QmatNMR.num5+QmatNMR.num9)*QmatNMR.num6:((QmatNMR.num2-1)*(QmatNMR.num5+QmatNMR.num9)+QmatNMR.num5/2+QmatNMR.num9)], 'xticklabel', QTEMP10);
      end
    end
  
  
    %
    %horizontal stack means QmatNMR.PlotType = 2
    %
    QmatNMR.PlotType = 2;
  
  
    setfourmode
    title(['Horizontal Stack plot from current 2D spectrum ' strrep(QmatNMR.Spec2DName, '_', '\_')], 'Color', QmatNMR.ColorScheme.AxisFore);
    disp('Horizontal Stack plot finished');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end