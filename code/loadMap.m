function [VFX, VFY, I] = loadMap()

M = loadSituation();
[VFX, VFY, I] = computeVF(M);

end