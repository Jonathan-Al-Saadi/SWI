%LABELS  Create a dialog box for modifying titles and labels
%Labels creates a dialog box with edit uicontrols for modifying 
%axes' titles, xlabels, ylabels, and zlabels. To the right
%of these fields the axes present in the current figure
%are shown as blue patches, with the active axes shown with
%a white border.  The active axes may be changed simply by
%clicking on another of the blue patches.  At start and when
%axes are changed, the appropriate data for each field for
%the active axes will be loaded.  If an axes has no data for
%a particular field, the text in that field will remain unchanged.
%
%Thus if we set the Y label in one subplot to "Magnitude (db)" and
%then switch axes, to a subplot with no Y label, the Y label field
%will still contain the text "Magnitude (db)".  
%
%There are three buttons at the bottom of the dialog box, "OK",
%"Cancel", and "Apply".  Pressing "OK" sets the labels of the
%active axes to the values contained in the edit uicontrols and
%closes the dialog box.  "Cancel" simply closes the dialog box
%without modifying any labels.  "Apply" sets the labels of
%the active axes to the values in the edit uicontrols but does
%*not* close the dialog box.
%
%When the focus is held by the edit uicontrols, the tab key
%will switch between fields.  When it is not, hitting the
%return key is equivalent to pressing the OK button, hitting
%the escape key is equivalent to pressing the Cancel button,
%and hitting the "a" key is equivalent to pressing the Apply
%button.
%
%Keith Rogers 1/4/95

% Copyright (c) 1995 by Keith Rogers

%
% Adapted for matNMR by Jacco van Beek, 12-12-'96, 31-01-'00
%


try
  if (QmatNMR.command == 0)
    					%First check whether the window already exists ...
    QmatNMR.Ph = findobj(allchild(0),'tag','KLabels');
    
    if ~isempty(QmatNMR.Ph)
      figure(QmatNMR.Ph);
    else  
      figure(QmatNMR.Fig);
      QmatNMR.Tax = gca;
      QmatNMR.Ttit = get(QmatNMR.Tax,'title');
  
      QmatNMR.Tfigpos = [0.508854 0.0711111 0.479861 0.233333];
      QmatNMR.Ttitlefig = figure('units', 'normalized', ...
                          'Position',QmatNMR.Tfigpos,...
                          'Name','Title / Labels for 1D spectra',...
                          'Resize','on',...
                          'NumberTitle','off',...
                          'UserData', QmatNMR.Tfig,...
                          'KeyPressFcn','QmatNMR.command = 5; klabels',...
                          'CloseRequestFCN', 'QmatNMR.command = 3; klabels', ...
  			'color', QmatNMR.ColorScheme.Figure1Back, ...
                          'Tag', 'KLabels');
  
    %
    %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
    %
    set(QmatNMR.Ttitlefig, 'units', 'normalized', 'position', QmatNMR.Tfigpos);
  
      set(gca,'Visible','off');
      QmatNMR.Tedsize = [.1399 .1124];
      QmatNMR.Ttxtsize = Qtextlen('XLabel', 'normalized', QmatNMR.UIFontSize);
      QmatNMR.Tposition = [.0311 .7870 QmatNMR.Ttxtsize(1) QmatNMR.Tedsize(2)];
      uicontrol(QmatNMR.Ttitlefig,'parent', QmatNMR.Ttitlefig, ...
                          'backgroundcolor', QmatNMR.ColorScheme.Button12Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button12Fore, ...
                          'style','text',...
                          'string','Title:',...
                          'units','normalized',...
                          'position',QmatNMR.Tposition);
  						
      QmatNMR.Tposition(2) = .6184;
      uicontrol(QmatNMR.Ttitlefig,'parent', QmatNMR.Ttitlefig, ...
                          'backgroundcolor', QmatNMR.ColorScheme.Button12Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button12Fore, ...
                          'style','text',...
                          'string','Xlabel:',...
                          'units','normalized',...
                          'position',QmatNMR.Tposition);
  
      QmatNMR.Tposition(2) = .4497;
      uicontrol(QmatNMR.Ttitlefig,'parent', QmatNMR.Ttitlefig, ...
                          'backgroundcolor', QmatNMR.ColorScheme.Button12Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button12Fore, ...
                          'style','text',...
                          'string','Ylabel:',...
                          'units','normalized',...
                          'position',QmatNMR.Tposition);
  
      QmatNMR.Tposition(2) = .2811;
      uicontrol(QmatNMR.Ttitlefig,'parent', QmatNMR.Ttitlefig, ...
                          'backgroundcolor', QmatNMR.ColorScheme.Button12Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button12Fore, ...
                          'style','text',...
                          'string','Zlabel:',...
                          'units','normalized',...
                          'position',QmatNMR.Tposition);
  						
      
      QTEMP1 = get(get(QmatNMR.Tax,'title'),'string');
      if (size(QTEMP1, 1) > 1)
        QTEMP3 = deblank(QTEMP1(1, :));
        for QTEMP2=2:size(QTEMP1, 1)
          QTEMP3 = [QTEMP3 '\n' deblank(QTEMP1(QTEMP2, :))];
        end
      else
        QTEMP3 = QTEMP1;
      end
      QmatNMR.Tposition = [0.1265 .7870 .8367 .1012];
      QmatNMR.TitleEdit = uicontrol(QmatNMR.Ttitlefig,'style','edit',...
                          'parent', QmatNMR.Ttitlefig, ...
                          'backgroundcolor', QmatNMR.ColorScheme.Button1Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button1Fore, ...
                          'units','normalized',...
                          'string', QTEMP3,...
                          'position',QmatNMR.Tposition,...
                          'tag','title');
  						
      QTEMP1 = get(get(QmatNMR.Tax,'xlabel'),'string');
      if (size(QTEMP1, 1) > 1)
        QTEMP3 = deblank(QTEMP1(1, :));
        for QTEMP2=2:size(QTEMP1, 1)
          QTEMP3 = [QTEMP3 '\n' deblank(QTEMP1(QTEMP2, :))];
        end
      else
        QTEMP3 = QTEMP1;
      end
      QmatNMR.Tposition(2) = .6184;
      QmatNMR.XlabelEdit = uicontrol(QmatNMR.Ttitlefig,'style','edit',...
                          'parent', QmatNMR.Ttitlefig, ...
                          'backgroundcolor', QmatNMR.ColorScheme.Button1Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button1Fore, ...
                          'string', QTEMP3,...
                          'units','normalized',...
                          'position',QmatNMR.Tposition,...
                          'tag','xlabel');
  
      QTEMP1 = get(get(QmatNMR.Tax,'ylabel'),'string');
      if (size(QTEMP1, 1) > 1)
        QTEMP3 = deblank(QTEMP1(1, :));
        for QTEMP2=2:size(QTEMP1, 1)
          QTEMP3 = [QTEMP3 '\n' deblank(QTEMP1(QTEMP2, :))];
        end
      else
        QTEMP3 = QTEMP1;
      end
      QmatNMR.Tposition(2) = .4497;
      QmatNMR.YlabelEdit = uicontrol(QmatNMR.Ttitlefig,'style','edit',...
                          'parent', QmatNMR.Ttitlefig, ...
                          'backgroundcolor', QmatNMR.ColorScheme.Button1Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button1Fore, ...
                          'string', QTEMP3,...
                          'units','normalized',...
                          'position',QmatNMR.Tposition,...
                          'tag','ylabel');
  
      QTEMP1 = get(get(QmatNMR.Tax,'zlabel'),'string');
      if (size(QTEMP1, 1) > 1)
        QTEMP3 = deblank(QTEMP1(1, :));
        for QTEMP2=2:size(QTEMP1, 1)
          QTEMP3 = [QTEMP3 '\n' deblank(QTEMP1(QTEMP2, :))];
        end
      else
        QTEMP3 = QTEMP1;
      end
      QmatNMR.Tposition(2) = .2811;
      QmatNMR.ZlabelEdit = uicontrol(QmatNMR.Ttitlefig,'style','edit',...
                          'parent', QmatNMR.Ttitlefig, ...
                          'backgroundcolor', QmatNMR.ColorScheme.Button1Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button1Fore, ...
                          'string', QTEMP3,...
                          'units','normalized',...
                          'position',QmatNMR.Tposition,...
                          'tag','zlabel');
  
  
      QmatNMR.Tbuttonsize = objsize('pushbutton', 6);
      QmatNMR.Tposition = [.6347 .0618 .3107 .1124];
      QmatNMR.TOKbutton = uicontrol('Parent',QmatNMR.Ttitlefig,...
                          'parent', QmatNMR.Ttitlefig, ...
                          'style','pushbutton',...
                          'string','Apply and Close',...
                          'backgroundcolor', QmatNMR.ColorScheme.Button5Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button5Fore, ...
                          'units','normalized',...
                          'position',QmatNMR.Tposition,...
                          'callback','QmatNMR.command = 2; klabels');
  
      QmatNMR.Tposition = [.2530 .0618 .1553 .1124];
      QmatNMR.TCancelbutton = uicontrol(QmatNMR.Ttitlefig,...
                          'parent', QmatNMR.Ttitlefig, ...
                          'style','pushbutton',...
                          'string','Close',...
                          'units','normalized',...
                          'backgroundcolor', QmatNMR.ColorScheme.Button3Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button3Fore, ...
                          'position',QmatNMR.Tposition,...
                          'callback','QmatNMR.command = 3; klabels');
  						
      QmatNMR.Tposition = [.0621 .0618 .1553 .1124];
      QmatNMR.TApplybutton = uicontrol(QmatNMR.Ttitlefig,...
                          'parent', QmatNMR.Ttitlefig, ...
                          'style','pushbutton',...
                          'string','Apply',...
                          'units','normalized',...
                          'backgroundcolor', QmatNMR.ColorScheme.Button4Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button4Fore, ...
                          'position',QmatNMR.Tposition,...
                          'callback','QmatNMR.command = 4; klabels');
  
  
      QmatNMR.Tposition = [.4439 .0618 .1553 .1124];
      QmatNMR.TRefreshButton = uicontrol(QmatNMR.Ttitlefig, ....
                          'parent', QmatNMR.Ttitlefig, ...
                          'backgroundcolor', QmatNMR.ColorScheme.Button1Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button1Fore, ...
                          'style','pushbutton',...
                          'string','Refresh',...
                          'units','normalized',...
                          'position',QmatNMR.Tposition,...
                          'callback','QmatNMR.command = 6; klabels');
  
      %
      %Finally add a special button that makes the input window the full width of the screen if pressed
      %
      uicontrol(QmatNMR.Ttitlefig, ...
                          'parent', QmatNMR.Ttitlefig, ...
                          'Style', 'PushButton', ...
                          'Units', 'Normalized', ...
                          'Position', [.88 .91 0.12 0.09], ...
                          'String', 'Full Width', ...
                          'Callback', 'QTEMP=get(gcf, ''position''); set(gcf, ''position'', [0 QTEMP(2) 1 QTEMP(4)]);', ...
                          'backgroundcolor', QmatNMR.ColorScheme.Button5Back, ...
  			'foregroundcolor', QmatNMR.ColorScheme.Button5Fore);
  
      %
      %To avoid conflict with the very similar routine clabels.m, the handles to the buttons
      %are stored in the userdata of the figure window. That way I don't need to rewrite both
      %routines.
      %
      %Jacco, 20-02-'04
      %
      QmatNMR.TTEMP.Figure = QmatNMR.Ttitlefig;
      QmatNMR.TTEMP.TitleEdit = QmatNMR.TitleEdit;
      QmatNMR.TTEMP.QmatNMR.XlabelEdit = QmatNMR.XlabelEdit;
      QmatNMR.TTEMP.QmatNMR.YlabelEdit = QmatNMR.YlabelEdit;
      QmatNMR.TTEMP.QmatNMR.ZlabelEdit = QmatNMR.ZlabelEdit;
      set(QmatNMR.Ttitlefig, 'userdata', QmatNMR.TTEMP);
    end   			%finished making the figure window
    
  elseif (QmatNMR.command == 2)		%apply and close
    %first retrieve the necessary handles from the figure window userdata
    QmatNMR.Ph = findobj(allchild(0),'tag','KLabels');
    QmatNMR.TTEMP = get(QmatNMR.Ph, 'userdata');
    QmatNMR.Ttitlefig = QmatNMR.TTEMP.Figure;
    QmatNMR.TitleEdit = QmatNMR.TTEMP.TitleEdit;
    QmatNMR.XlabelEdit = QmatNMR.TTEMP.QmatNMR.XlabelEdit;
    QmatNMR.YlabelEdit = QmatNMR.TTEMP.QmatNMR.YlabelEdit;
    QmatNMR.ZlabelEdit = QmatNMR.TTEMP.QmatNMR.ZlabelEdit;
  
    figure(QmatNMR.Fig);
    set(get(gca, 'title'), 'string', strrep(get(QmatNMR.TitleEdit, 'string'), '\n', char(10)));
    set(get(gca, 'xlabel'), 'string', strrep(get(QmatNMR.XlabelEdit, 'string'), '\n', char(10)));
    set(get(gca, 'ylabel'), 'string', strrep(get(QmatNMR.YlabelEdit, 'string'), '\n', char(10)));
    set(get(gca, 'zlabel'), 'string', strrep(get(QmatNMR.ZlabelEdit, 'string'), '\n', char(10)));
    
    %
    %Add this action to a plotting macro if we're recording one
    %
    if (QmatNMR.RecordingPlottingMacro)
      %
      %The changing of the title and axis labels will be stored as two separate
      %processing actions, First the axis labels and then the title
      %
      QTEMP20 = findobj(QmatNMR.Fig, 'tag', 'MainAxis');
      
      %
      %AXIS LABELS
      %
      QTEMP1 = deblank(fliplr(deblank(fliplr(get(QmatNMR.XlabelEdit, 'string')))));
      QTEMP2 = deblank(fliplr(deblank(fliplr(get(QmatNMR.YlabelEdit, 'string')))));
      QTEMP3 = deblank(fliplr(deblank(fliplr(get(QmatNMR.ZlabelEdit, 'string')))));
      QmatNMR.uiInput4 = 1;	%current axis only
    
      %
      %then store the input strings
      %
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
      QTEMP11 = double(['QmatNMR.uiInput2 = ''' QTEMP2 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
      QTEMP11 = double(['QmatNMR.uiInput3 = ''' QTEMP3 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
  
      %
      %Finally we store the processing action
      %
      QTEMP12 = get(get(QTEMP20, 'parent'), 'userdata');	%to allow extraction of the subplot code
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 725, QTEMP12.SubPlots, 1, 1, 1, QmatNMR.uiInput4);
  
  
  
      %
      %TITLE
      %
      QTEMP1 = deblank(fliplr(deblank(fliplr(get(QmatNMR.TitleEdit, 'string')))));
      QmatNMR.uiInput2 = 1;
      
  
      %
      %then store the input strings
      %
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
  
      %
      %Finally we store the processing action
      %
      QTEMP12 = get(get(QTEMP20, 'parent'), 'userdata');	%to allow extraction of the subplot code
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 728, QTEMP12.SubPlots, QmatNMR.uiInput2);
    end
  
    %
    %close the figure
    %
    try
      delete(QmatNMR.Ttitlefig);
    end
    QmatNMR.Ttitlefig = [];
    refresh(QmatNMR.Fig);
  
  elseif (QmatNMR.command == 3)		%close
    %first retrieve the necessary handles from the figure window userdata
    QmatNMR.Ph = findobj(allchild(0),'tag','KLabels');
    QmatNMR.TTEMP = get(QmatNMR.Ph, 'userdata');
    QmatNMR.Ttitlefig = QmatNMR.TTEMP.Figure;
    QmatNMR.TitleEdit = QmatNMR.TTEMP.TitleEdit;
    QmatNMR.XlabelEdit = QmatNMR.TTEMP.QmatNMR.XlabelEdit;
    QmatNMR.YlabelEdit = QmatNMR.TTEMP.QmatNMR.YlabelEdit;
    QmatNMR.ZlabelEdit = QmatNMR.TTEMP.QmatNMR.ZlabelEdit;
  
    try
      delete(QmatNMR.Ttitlefig);
    end
    QmatNMR.Ttitlefig = [];
    refresh(QmatNMR.Fig);
  
  elseif (QmatNMR.command == 4) 		%apply
    %first retrieve the necessary handles from the figure window userdata
    QmatNMR.Ph = findobj(allchild(0),'tag','KLabels');
    QmatNMR.TTEMP = get(QmatNMR.Ph, 'userdata');
    QmatNMR.Ttitlefig = QmatNMR.TTEMP.Figure;
    QmatNMR.TitleEdit = QmatNMR.TTEMP.TitleEdit;
    QmatNMR.XlabelEdit = QmatNMR.TTEMP.QmatNMR.XlabelEdit;
    QmatNMR.YlabelEdit = QmatNMR.TTEMP.QmatNMR.YlabelEdit;
    QmatNMR.ZlabelEdit = QmatNMR.TTEMP.QmatNMR.ZlabelEdit;
  
    figure(QmatNMR.Fig);
    set(get(gca, 'title'), 'string', strrep(get(QmatNMR.TitleEdit, 'string'), '\n', char(10)));
    set(get(gca, 'xlabel'), 'string', strrep(get(QmatNMR.XlabelEdit, 'string'), '\n', char(10)));
    set(get(gca, 'ylabel'), 'string', strrep(get(QmatNMR.YlabelEdit, 'string'), '\n', char(10)));
    set(get(gca, 'zlabel'), 'string', strrep(get(QmatNMR.ZlabelEdit, 'string'), '\n', char(10)));
    figure(QmatNMR.Ttitlefig);
    refresh(QmatNMR.Fig);
    
    %
    %Add this action to a plotting macro if we're recording one
    %
    if (QmatNMR.RecordingPlottingMacro)
      %
      %The changing of the title and axis labels will be stored as two separate
      %processing actions, First the axis labels and then the title
      %
      QTEMP20 = findobj(QmatNMR.Fig, 'tag', 'MainAxis');
      
      %
      %AXIS LABELS
      %
      QTEMP1 = deblank(fliplr(deblank(fliplr(get(QmatNMR.XlabelEdit, 'string')))));
      QTEMP2 = deblank(fliplr(deblank(fliplr(get(QmatNMR.YlabelEdit, 'string')))));
      QTEMP3 = deblank(fliplr(deblank(fliplr(get(QmatNMR.ZlabelEdit, 'string')))));
      QmatNMR.uiInput4 = 1;	%current axis only
    
      %
      %then store the input strings
      %
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
      QTEMP11 = double(['QmatNMR.uiInput2 = ''' QTEMP2 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
      QTEMP11 = double(['QmatNMR.uiInput3 = ''' QTEMP3 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
  
      %
      %Finally we store the processing action
      %
      QTEMP12 = get(get(QTEMP20, 'parent'), 'userdata');	%to allow extraction of the subplot code
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 725, QTEMP12.SubPlots, 1, 1, 1, QmatNMR.uiInput4);
  
  
  
      %
      %TITLE
      %
      QTEMP1 = deblank(fliplr(deblank(fliplr(get(QmatNMR.TitleEdit, 'string')))));
      QmatNMR.uiInput2 = 1;
      
  
      %
      %then store the input strings
      %
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
  
      %
      %Finally we store the processing action
      %
      QTEMP12 = get(get(QTEMP20, 'parent'), 'userdata');	%to allow extraction of the subplot code
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 728, QTEMP12.SubPlots, QmatNMR.uiInput2);
    end
  
  
  elseif (QmatNMR.command == 5)		%key-press function (handles returns etc)
    %first retrieve the necessary handles from the figure window userdata
    QmatNMR.Ph = findobj(allchild(0),'tag','KLabels');
    QmatNMR.TTEMP = get(QmatNMR.Ph, 'userdata');
    QmatNMR.Ttitlefig = QmatNMR.TTEMP.Figure;
    QmatNMR.TitleEdit = QmatNMR.TTEMP.TitleEdit;
    QmatNMR.XlabelEdit = QmatNMR.TTEMP.QmatNMR.XlabelEdit;
    QmatNMR.YlabelEdit = QmatNMR.TTEMP.QmatNMR.YlabelEdit;
    QmatNMR.ZlabelEdit = QmatNMR.TTEMP.QmatNMR.ZlabelEdit;
  
    if(get(QmatNMR.Ttitlefig,'currentcharacter')-0==13)		%apply on ENTER
      QmatNMR.command = 4;
      klabels;
  
    elseif (get(QmatNMR.Ttitlefig,'currentcharacter')-0==27)	%close on ESC
      QmatNMR.command = 3;
      klabels;
  
    elseif(get(QmatNMR.Ttitlefig,'currentcharacter')-0=='a') 	%apply on 'a'
      QmatNMR.command = 4;
      klabels;
    end
  
  elseif (QmatNMR.command == 6)		%refresh buttons
    %first retrieve the necessary handles from the figure window userdata
    QmatNMR.Ph = findobj(allchild(0),'tag','KLabels');
    QmatNMR.TTEMP = get(QmatNMR.Ph, 'userdata');
    QmatNMR.Ttitlefig = QmatNMR.TTEMP.Figure;
    QmatNMR.TitleEdit = QmatNMR.TTEMP.TitleEdit;
    QmatNMR.XlabelEdit = QmatNMR.TTEMP.QmatNMR.XlabelEdit;
    QmatNMR.YlabelEdit = QmatNMR.TTEMP.QmatNMR.YlabelEdit;
    QmatNMR.ZlabelEdit = QmatNMR.TTEMP.QmatNMR.ZlabelEdit;
  
    QTEMP1 = get(get(get(QmatNMR.Fig, 'currentaxes'),'XLabel'),'string');
    if (size(QTEMP1, 1) > 1)
      QTEMP3 = deblank(QTEMP1(1, :));
      for QTEMP2=2:size(QTEMP1, 1)
        QTEMP3 = [QTEMP3 '\n' deblank(QTEMP1(QTEMP2, :))];
      end
    else
      QTEMP3 = QTEMP1;
    end
    set(QmatNMR.XlabelEdit, 'string', QTEMP3);

    QTEMP1 = get(get(get(QmatNMR.Fig, 'currentaxes'),'YLabel'),'string');
    if (size(QTEMP1, 1) > 1)
      QTEMP3 = deblank(QTEMP1(1, :));
      for QTEMP2=2:size(QTEMP1, 1)
        QTEMP3 = [QTEMP3 '\n' deblank(QTEMP1(QTEMP2, :))];
      end
    else
      QTEMP3 = QTEMP1;
    end
    set(QmatNMR.YlabelEdit, 'string', QTEMP3);

    QTEMP1 = get(get(get(QmatNMR.Fig, 'currentaxes'),'ZLabel'),'string');
    if (size(QTEMP1, 1) > 1)
      QTEMP3 = deblank(QTEMP1(1, :));
      for QTEMP2=2:size(QTEMP1, 1)
        QTEMP3 = [QTEMP3 '\n' deblank(QTEMP1(QTEMP2, :))];
      end
    else
      QTEMP3 = QTEMP1;
    end
    set(QmatNMR.ZlabelEdit, 'string', QTEMP3);

    QTEMP1 = get(get(get(QmatNMR.Fig, 'currentaxes'),'Title'),'string');
    if (size(QTEMP1, 1) > 1)
      QTEMP3 = deblank(QTEMP1(1, :));
      for QTEMP2=2:size(QTEMP1, 1)
        QTEMP3 = [QTEMP3 '\n' deblank(QTEMP1(QTEMP2, :))];
      end
    else
      QTEMP3 = QTEMP1;
    end
    set(QmatNMR.TitleEdit , 'string', QTEMP3);
  end
  
  
  
  
  
  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end