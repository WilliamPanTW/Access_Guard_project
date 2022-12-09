clc;
close;
clear

a = arduino('com3', 'uno');
configurePin(a,'D5','PWM') 
configurePin(a,'D7','DigitalOutput' )
configurePin(a,'D8','DigitalOutput')

c=webcam;
load myNet1;
faceDetector=vision.CascadeObjectDetector;
while true
e=c.snapshot;
bboxes =step(faceDetector,e);
if(sum(sum(bboxes))~=0)
es=imcrop(e,bboxes(1,:));
es=imresize(es,[227 227]);
label=classify(myNet1,es);
image(e);
title(char(label));
drawnow;

for i=1:20 %open
writeDigitalPin(a, 'D7', 1);
writeDigitalPin(a, 'D8', 0);
writePWMDutyCycle(a, 'D5', 1);
end
writeDigitalPin(a, 'D7', 0);
break;
else
image(e);
title('No Face Detected');

for i=1:25 %close
writeDigitalPin(a, 'D7', 0);
writeDigitalPin(a, 'D8', 1);
writePWMDutyCycle(a, 'D5', 1);
end
writeDigitalPin(a, 'D8', 0);
break;

end
end