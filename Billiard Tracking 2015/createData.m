function [z]=createData(vid, r, starttime, endtime,xcut,ycut)
    
    v=VideoReader(vid);
    if nargin>3
        frames=read(v, [starttime*v.FrameRate endtime*v.FrameRate]);
    else
        frames=read(v);
    end
    for i=1:size(frames,4)
        if nargin<5
            [yvid,xvid]=circle_detection(frames(:,:,:,i),r);
            z(i)={[xvid';yvid']};
        else
            [yvid,xvid]=circle_detection(frames(ycut,xcut,:,i),r);
            z(i)={[(xvid+xcut(1))';(yvid+ycut(1))']};
        end
        disp(i/size(frames,4)*100)
    end
end