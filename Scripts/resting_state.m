% Sound
try
InitializePsychSound;
pa = PsychPortAudio('Open', [], [], [], [], [], 256);
bp400 = PsychPortAudio('CreateBuffer', pa, [MakeBeep(400, 0.2); MakeBeep(400, 0.2)]);
PsychPortAudio('FillBuffer', pa, bp400);

config_io
address = hex2dec('D010');
outp(address, 0);

KbName('UnifyKeyNames');
esc_key = KbName('Escape');

scr = Screen('OpenWindow', 0, 127.5);
HideCursor;

DrawFormattedText(scr, 'From the first beep, keep your eyes open for a minute. After a minute you will hear a second beep, indicating you should close your eyes for one minute. This will continue to alternate for 4 minutes.\n\nPress any key to start.', 'center', 'center', 0, 40, [], [], 1.5);
Screen('Flip', scr);
WaitSecs(1);
KbWait;
WaitSecs(0.2);
for lapsedTime = 1:5
DrawFormattedText(scr, ['Starting in ' num2str(5-lapsedTime+1) ' seconds'], 'center', 'center', 0);
Screen('Flip', scr);
WaitSecs(1);
end
Screen('Flip', scr);

outp(address, 101);
PsychPortAudio('Start', pa);
t0 = GetSecs;
while GetSecs < t0 + 60;
    WaitSecs(0.2);
    [~, ~, pressArray] = KbCheck;
    if pressArray(esc_key);
        outp(address, 199);
        error('Interrupted Script');
    end
end

outp(address, 102);
PsychPortAudio('Start', pa);

while GetSecs < t0 + 120;
    WaitSecs(0.2);
    [~, ~, pressArray] = KbCheck;
    if pressArray(esc_key);
        outp(address, 199);
        error('Interrupted Script');
    end
end

outp(address, 101);
PsychPortAudio('Start', pa);

while GetSecs < t0 + 180;
    WaitSecs(0.2);
    [~, ~, pressArray] = KbCheck;
    if pressArray(esc_key);
        outp(address, 199);
        error('Interrupted Script');
    end
end

outp(address, 102);
PsychPortAudio('Start', pa);

while GetSecs < t0 + 240;
    WaitSecs(0.2);
    [~, ~, pressArray] = KbCheck;
    if pressArray(esc_key);
        outp(address, 199);
        error('Interrupted Script');
    end
end
outp(address, 0);
PsychPortAudio('Start', pa);
WaitSecs(0.5);
PsychPortAudio('Start', pa);
PsychPortAudio('Close');
sca;
catch err
    sca;
    PsychPortAudio('Close');
    outp(address, 0);
    rethrow(err);
end