function mask_out_cerebellum(D, whole_brain_template, subject_no, msk)
 rmsk = cpca_read_vol(whole_brain_template);
 rmsk.image(rmsk.image==3)=0;
 rmsk.image(rmsk.image==5)=0;
 fmsk = rmsk;
 mask_by_variance();
  function mask_by_variance()
  % --- this nested funtion only produces the individual run masks for current subject
    %these_stats = [ SubjectNo, RunNo, 0 0 0 ];
    
   if size(D,1) == 0
      fprintf( 1, '%s\n', [ 'No Files: ' subject_dir ] );
      return;
   end
    Z = zeros( size(D,1), rmsk.x );   
    for fi = 1:size(D,1)

      fn = D{fi,1};
      img = cpca_read_vol(fn);
      Z(fi,:) = img.image( rmsk.ind );
      
      if isempty( msk )
        msk = img; % --= 
        msk.image = ones( size(msk.image(:) ) ); % --= 
      end   % --- initialize the volume header and img data % --= 

      if ( fi == 1 )
        subject_mask = msk.image;
      end
          
      mask_size = find( subject_mask);
      
    end % --= each scan image in subject run directory

    clear D;


    SD = samp_dev( Z );
    problematic = find( isnan( sum(Z ) ) );
    problematic = [problematic find( isinf( sum(Z ) ) )];
    problematic = unique( [problematic find( SD == 0 )] );
    column_mean = mean( Z );
    if ~isempty( problematic )
      SD(problematic) = 0;
    end
    x = find( SD > 0 );

    msk.ind = rmsk.ind(x);
    [msk.x, msk.y] = size(msk.ind);
%    mask_VR = ones( 1, msk.y );
    mask_VR = fmsk.image( msk.ind);
      
    mask_name = ['subject_' num2str(subject_no) '_mask.img' ];
    err = write_cpca_image( ['subject_masks' filesep], mask_name, mask_VR, msk );

    x = size(msk.image);
    if size(x,2 ) < 3
      dim = msk.vol.dim;
      D = reshape( msk.image, dim);
    else
      D = msk.image;
    end

    ind = [1:prod(dim)];

    [msk.I msk.J msk.K] = ind2sub(size(D), ind);
    msk.IJK = [msk.I; msk.J; msk.K];
    if ~isempty(msk.IJK)
      msk.MNI = msk.vol.mat(1:3,:)*[msk.IJK; ones(1,size(msk.IJK,2))];
    end

    vbr = voxels_by_region(  msk );

    
  end  % --- nested function mask_by_variance()
end