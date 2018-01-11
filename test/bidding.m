function [price, dealingQuantity] = bidding(dP)

if size(dP, 2) == 1
    dP = dP';
end

sellIndex = dP > 0.00001;
sellOwn = dP(sellIndex);
 
buyIndex = dP < -0.00001;
buyOwn = -dP(buyIndex);  
dealingQuantity = zeros(size(dP));
if isempty(sellOwn) || isempty(buyOwn)
    price = 0;
else
    cs = - 0.4;
    cb = 1.2;
    bidPrice =  -0.3: 0.05: 1.1;
    m = size(bidPrice, 2);

    sellN = size(sellOwn, 2); 
    sellQ = ones(sellN, m);
    sellDecision = ones(sellN, 1);
    buyN = size(buyOwn, 2);
    buyQ = ones(buyN, m);
    buyDecision = ones(buyN, 1);

    iterMax = 1000;
    priceRecord = zeros(1, iterMax);

    for i = 1: iterMax
        % 决策
        for j = 1: sellN
           sellDecision(j) = REDecision(sellQ(j, :));
        end
        for j = 1: buyN
           buyDecision(j) = REDecision(buyQ(j, :));
        end
        
        % 出清
        sellBidPrice = bidPrice(sellDecision);
        buyBidPrice = bidPrice(buyDecision);

        [~, sellbidIndex] = sort(sellBidPrice);
        [~, buybidIndex] = sort(-buyBidPrice);

        is = 1;
        ib = 1;
        isl = is;
        ibl = ib;
        clearPrice = (sellBidPrice(sellbidIndex(is)) + buyBidPrice(buybidIndex(ib))) / 2;
        sumSeller = sellOwn(sellbidIndex(is));
        sumBuyer = buyOwn(buybidIndex(ib));
        while  true
            if sellBidPrice(sellbidIndex(is)) > buyBidPrice(buybidIndex(ib))
                break;
            end
            clearPrice = (sellBidPrice(sellbidIndex(is)) + buyBidPrice(buybidIndex(ib))) / 2;
            if sumSeller < sumBuyer
                isl = is;
                is = is + 1;
                ibl = ib;
                if is > sellN
                    break;
                end
                sumSeller = sumSeller + sellOwn(sellbidIndex(is));
            else
                ibl = ib;
                ib = ib + 1;
                isl = is;
                if ib > buyN
                    break;
                end
                sumBuyer = sumBuyer + buyOwn(buybidIndex(ib));
            end
        end

        if (sumSeller > sumBuyer)
            buyQuantity = (buyBidPrice >= clearPrice) .* buyOwn;
            sellAllIndex = sellBidPrice < sellBidPrice(sellbidIndex(isl));
            sellPartIndex = sellBidPrice == sellBidPrice(sellbidIndex(isl));
            sellQuantity = (sellAllIndex + sellPartIndex * (sumBuyer - sum(sellOwn(sellAllIndex)))/ sum(sellOwn(sellPartIndex))) .* sellOwn;
        else
            sellQuantity = (sellBidPrice <= clearPrice) .* sellOwn;
            buyAllIndex = buyBidPrice > buyBidPrice(buybidIndex(ibl));
            buyPartIndex = buyBidPrice == buyBidPrice(buybidIndex(ibl));
            buyQuantity = (buyAllIndex + buyPartIndex * (sumSeller - sum(buyOwn(buyAllIndex)))/ sum(buyOwn(buyPartIndex))) .* buyOwn;
        end
        sellReward = sellQuantity * (clearPrice - cs);
        buyReward = buyQuantity * (cb - clearPrice);
        priceRecord(i) = clearPrice;
%         buyReward = (buyBidPrice >= clearPrice) * (cb - clearPrice) .* buy;
%         sellReward = (sellBidPrice <= clearPrice) * (clearPrice - cs) .* sell;
        
        % 改进决策
        for j = 1: sellN
           sellQ(j, :) = REImprove(sellReward(j) / 500, sellDecision(j), sellQ(j, :));
        end

        for j = 1: buyN
           buyQ(j, :) = REImprove(buyReward(j) / 500, buyDecision(j), buyQ(j, :));
        end
    end
    plot(priceRecord);
    dealingQuantity(sellIndex) = -sellQuantity;
    dealingQuantity(buyIndex) = buyQuantity;
    price = clearPrice;
end   