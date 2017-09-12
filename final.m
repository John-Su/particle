
A = [];
B = [];
bA = [];
bB = [];
for I = 1:length(AX)
    A = [A;[reshape(AX{I}(1:end-1,:),nA*mA,1), reshape(AY{I}(1:end-1,:),nA*mA,1)]];
    B = [B;[reshape(BX{I}(1:end-1,:),nB*mB,1), reshape(BY{I}(1:end-1,:),nB*mB,1)]];
    bA = [bA;[reshape(boardAX,nA*mA,1), reshape(boardAY,nA*mA,1),ones(nA*mA,1)]];
    bB = [bB;[reshape(boardBX,nB*mB,1), reshape(boardBY,nB*mB,1),ones(nB*mB,1)]];
end
CA = calib(A(:,1),A(:,2),bA(:,1),bA(:,2),bA(:,3));
CB = calib(B(:,1),B(:,2),bB(:,1),bB(:,2),bB(:,3));
A = CA*[reshape(X_A,nA*mA,1), reshape(Y_A,nA*mA,1),ones(nA*mA,1)]';
B = CB*[reshape(X_B,nB*mB,1), reshape(Y_B,nB*mB,1),ones(nB*mB,1)]';
PAB = CB\A;
PBA = CA\B;
max(max(abs(PAB(1:2,:)-[reshape(X_B,nB*mB,1), reshape(Y_B,nB*mB,1)]')))
max(max(abs(PBA(1:2,:)-[reshape(X_A,nA*mA,1), reshape(Y_A,nA*mA,1)]')))