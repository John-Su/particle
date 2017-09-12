function [particleTraceNew, f_posNew] = makeUpParticleTrace(particleTrace, a, f_pos)
    particleTraceNew = [];
    f_posNew = [];
    totalFound = 0;
    for I =1: size(particleTrace,1)
%         dropIndex = [] ; %% 已经匹配了的
        currentParticle = particleTrace(I,[end-1, end]);
        found = 0;
        for J = 1:size(a,1)
            matchFor = a(J,[2 3]);
            if (all(currentParticle == matchFor) && ~all(a(J,[4,5]) == 0))
                found = found + 1;
                particleTraceNew = [particleTraceNew; [particleTrace(I,:),a(J,[4,5])]];
                f_posNew = [f_posNew; f_pos(I,:)];
            end
        end
        if found == 0 && size(particleTrace,2) > 10
            particleTraceNew = [particleTraceNew;[particleTrace(I,:),[0,0]]];
            f_posNew = [f_posNew; [f_pos(I,1:end-2),[nan,nan]]];
        end
        totalFound = totalFound + found;
    end
    
    if totalFound == 0
        particleTraceNew = particleTrace;
        f_posNew = f_pos;
    end
    