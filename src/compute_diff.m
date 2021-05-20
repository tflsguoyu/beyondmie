
function img_err = compute_diff(im1, im2)
    color = pmkmp(256);
    im1_gray = mean(im1,3);
    im2_gray = mean(im2,3);
    img_diff = abs(im1_gray - im2_gray);
    max_diff = max(im1_gray(:))/4;
    img_diff = img_diff / max_diff;
    img_err = zeros(640,320,3);

    for i = 1:640
        for j = 1:320
            img_err(i,j,:) =  color(min(255,round(img_diff(i,j)*255))+1,:);
        end
    end
end