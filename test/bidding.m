function [price] = bidding(dP)


sellIndex = dP > 0;
sell = dP(sellIndex);
 
buyIndex = dP < 0;
buy = -dP(buyIndex);


if isempty(sell) || isempty(buy)
    price = 0;
else
    cs = 0.19;
    cb = 1.29;
    bidPrice =  0.3: 0.05: 1.2;
    m = size(bidPrice, 2);

    sellN = size(sell, 2); 
    sellQ = ones(sellN, m);
    sellDecision = ones(sellN, 1);
    buyN = size(buy, 2);
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
        clearPrice = (sellBidPrice(sellbidIndex(is)) + buyBidPrice(buybidIndex(ib))) / 2;
        sumSeller = sell(sellbidIndex(is));
        sumBuyer = buy(buybidIndex(ib));
        while  true
            if sellBidPrice(sellbidIndex(is)) > buyBidPrice(buybidIndex(ib))
                break;
            end
            clearPrice = (sellBidPrice(sellbidIndex(is)) + buyBidPrice(buybidIndex(ib))) / 2;
            if sumSeller < sumBuyer
                is = is + 1;
                if is > sellN
                    break;
                end
                sumSeller = sumSeller + sell(sellbidIndex(is));
            else
                ib = ib + 1;
                if ib > buyN
                    break;
                end
                sumBuyer = sumBuyer + buy(buybidIndex(ib));
            end
        end

        sellReward = (sellBidPrice <= clearPrice) * (clearPrice - cs);
        buyReward = (buyBidPrice >= clearPrice) * (cb - clearPrice);

        priceRecord(i) = clearPrice;

        % 改进决策
        for j = 1: sellN
           sellQ(j, :) = REImprove(sellReward(j), sellDecision(j), sellQ(j, :));
        end

        for j = 1: buyN
           buyQ(j, :) = REImprove(buyReward(j), buyDecision(j), buyQ(j, :));
        end
    end
    plot(priceRecord);
    price = clearPrice;
end   