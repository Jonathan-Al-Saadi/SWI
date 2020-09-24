function y = test();
fname = strcat(uigetdir(), '/fid')

id=fopen(fname, 'r', 'b');			%use big endian format for VARIAN

						%read in the Varian header
    [a, count] = fread(id, 6, 'int32');
    nblocks = a(1);
    ntraces = a(2);
    np = a(3);
    ebytes = a(4);
    tbytes = a(5);
    bbytes = a(6);
    [a, count] = fread(id, 2, 'int16');
    vers_id = a(1);
    status = a(2);
    [a, count] = fread(id, 1, 'int32');
    nbheaders = a(1);
   
    SizeTD2 = np;
    SizeTD1 = nblocks*ntraces;
    a = zeros(nblocks*ntraces*np, 1);
  						%determine the actual binary format from the status bit
    BinaryStatus = fliplr(dec2bin(status));
    if ((BinaryStatus(3) == '0') & (BinaryStatus(4) == '0'))
      for QTEMP40=1:nblocks
        for QTEMP41=1:nbheaders
          fread(id, nbheaders*14, 'int16');			%read in the block headers (nbheaders*28 bytes)
        end 
        [b, count] = fread(id, ntraces*np, 'int16');  	%read in the actual data (ntraces*np)
        %
        %check whether data has the correct length, otherwise append zeros
        %
        if (length(b) ~= ntraces*np)
          b( (length(b)+1):ntraces*np ) = 0;
        end
       							%put the data in the vector
        a( ((QTEMP40-1)*np*ntraces+1) : QTEMP40*np*ntraces ) = b;
      end  
      
    elseif ((BinaryStatus(3) == '1') & (BinaryStatus(4) == '0'))
      for QTEMP40=1:nblocks
        for QTEMP41=1:nbheaders
          fread(id, nbheaders*14, 'int16');		%read in the block headers (nbheaders*28 bytes)
        end 
        [b, count] = fread(id, ntraces*np, 'int32');  	%read in the actual data (ntraces*np)
        %
        %check whether data has the correct length, otherwise append zeros
        %
        if (length(b) ~= ntraces*np)
          b( (length(b)+1):ntraces*np ) = 0;
        end
        							%put the data in the vector
        a( ((QTEMP40-1)*np*ntraces+1) : QTEMP40*np*ntraces ) = b;
      end  
      
    else  
      for QTEMP40=1:nblocks
        for QTEMP41=1:nbheaders
          fread(id, nbheaders*14, 'int16');		%read in the block headers (nbheaders*28 bytes)
        end 
        [b, count] = fread(id, ntraces*np, 'float');  	%read in the actual data (ntraces*np)
        %
        %check whether data has the correct length, otherwise append zeros
        %
        if (length(b) ~= ntraces*np)
          b( (length(b)+1):ntraces*np ) = 0;
        end
        							%put the data in the vector
        a( ((QTEMP40-1)*np*ntraces+1) : QTEMP40*np*ntraces ) = b;
      end  
    end  
  
      y = zeros(SizeTD1, SizeTD2/2);
    for tel=1:SizeTD1
      %note that for VNMR we perform a transpose AND complex conjugate to obtain the right direction for the spectra
      y(tel, 1:(SizeTD2/2)) = (a((tel-1)*SizeTD2 + 1 : 2 : tel*SizeTD2-1) + sqrt(-1)*a((tel-1)*SizeTD2 + 2 : 2 : tel*SizeTD2))';
    end
