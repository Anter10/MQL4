//+------------------------------------------------------------------+
//|                                                         技术指标.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
 
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   
   // iAC 比尔·威廉姆斯的加速器/减速器振荡器 下边空头形式 上边多头形式  由正负线条标示 正值越大 多头越强 负值越大 空头越强 
   double iac=iAC(NULL, PERIOD_M1, 0);
   Print("iac Minute = ",iac);
    // iAD 积累/分配指标  正值多头 负值空头
    /*
      吸筹/派发 (Accumulation/Distribution)
      吸筹/派发技术指标是通过价格和交易量的变化来判断的。在价格变化时交易量实际上作为权重系数 ― 系数 (交易量) 越高，价格变化 (在这段时间周期内) 对指标值的贡献越大。
      事实上, 该指标是较常用的 能量潮 指标的一个版本。这两个指标都用来通过衡量各自的销售交易量来确认价格的变化。
      当吸筹/派发指标增长，意味着特定证券正在积累 (吸筹中)，因为业务量的压倒性份额与价格的上涨趋势相关。当指标下降时，意味着证券的派发 (抛售中)，因为大部分的业务是在价格下跌的过程中发生的。
      吸筹/派发指标与证券价格之间的背离表明即将到来的价格变化。作为一条规则，通常情况下，如果出现这种背离，价格趋势会朝着指标运行的方向发展。 因此，如果指标增长，证券价格下降，应期待价格出现转折。
      吸筹/派发 (Accumulation/Distribution)
      吸筹/派发技术指标是通过价格和交易量的变化来判断的。在价格变化时交易量实际上作为权重系数 ― 系数 (交易量) 越高，价格变化 (在这段时间周期内) 对指标值的贡献越大。
      事实上, 该指标是较常用的 能量潮 指标的一个版本。这两个指标都用来通过衡量各自的销售交易量来确认价格的变化。
      当吸筹/派发指标增长，意味着特定证券正在积累 (吸筹中)，因为业务量的压倒性份额与价格的上涨趋势相关。当指标下降时，意味着证券的派发 (抛售中)，因为大部分的业务是在价格下跌的过程中发生的。
      吸筹/派发指标与证券价格之间的背离表明即将到来的价格变化。作为一条规则，通常情况下，如果出现这种背离，价格趋势会朝着指标运行的方向发展。 因此，如果指标增长，证券价格下降，应期待价格出现转折。
   */
   double result=iAD(NULL, PERIOD_H1, 232);
   Print("ADM1 Minute = ",result);
    // iADX 平均方向移动指数指标 由三条线标示 主线 DI+线 DI-线 向上多头 向下空头
   double iadx=iADX(Symbol(),PERIOD_CURRENT,14,PRICE_MEDIAN,MODE_MAIN,0);
   Print("iadx MODE_MAIN center = ",iadx);
   double iadx1=iADX(Symbol(),PERIOD_CURRENT,14,PRICE_MEDIAN,MODE_PLUSDI,0);
   Print("iadx MODE_PLUSDI +d = ",iadx1);
   double iadx2=iADX(Symbol(),PERIOD_CURRENT,14,PRICE_MEDIAN,MODE_MINUSDI,0);
   Print("iadx MODE_MINUSDI -d = ",iadx2); 
   // iAlligator  计算比尔.威廉斯的鳄鱼指标 由三条线组成
   // 由symbol 要计算指标数据的货币对名称。 NULL表示当前货币对。
   // timeframe     - 时间周期。 可以 时间周期列举 任意值。 
   // 0表示当前图表的时间周期。 
   // jaw_period    - 蓝线平均周期(鳄鱼的下颌)
   // jaw_shift     - 蓝线偏移量
   // teeth_period  - 红线平均周期(鳄鱼的牙)
   // teeth_shift   - 红线偏移量
   // lips_period   - 绿线平均周期(鳄鱼的嘴唇)
   // lips_shift    - 绿线偏移量
   // ma_method     - MA方法。可以是任意的移动平均计算方法。
   // applied_price - 应用的价格。它可以是 应用价格枚举 的任意值。
   // mode          - 指标线的标识符。可以是以下任意值                
   // MODE_GATORJAW - 鳄鱼下领(蓝色)指标线，                
   // MODE_GATORTEETH - 鳄鱼牙(红色)指标线，                
   // MODE_GATORLIPS - 鳄鱼嘴唇(绿色)指标线。  
   // shift         - 从指标缓冲区中获取值的索引(相对当前柱子向前移动一定数量周期的偏移量)。 
   double jaw_val=iAlligator(Symbol(), PERIOD_M1, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORJAW, 1);
   Print("鳄鱼指标上颚 = ",jaw_val);
   double teeth_val=iAlligator(Symbol(), PERIOD_M1, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORTEETH, 1);
   Print("鳄鱼指标齿 = ",teeth_val);
   double lips=iAlligator(Symbol(), PERIOD_M1, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORLIPS, 1);
   Print("鳄鱼指标下颚 = ",lips);
   
   
   // iAO Awesome Oscillator，动量震荡指标，简称AO指标，它的发明者是Bill Williams，
   // AO指标是用于显示当前市场的发展趋势，
   // 而以其柱形图的形式表现出来，它是有零点中央线和两条不同颜色的柱状形来表示的，
   // 在零轴之上表示是正值，零轴之下表示是负值。
   // 指标颜色变化规律：在交易软件中柱线图分为红绿两种颜色，
   // 它们围绕一根零轴线运动。当最新的一根柱线高于前一根柱线时它就是绿色的，
   // 相反，当最新的一根柱线低于前一根柱线时它就是红色的。
   // 由上下鳄鱼状组成 上方多头 下方空头
   double iao1 = iAO(Symbol(),PERIOD_M1,0);
   double iao2 = iAO(Symbol(),PERIOD_M1,1);
   double iao3 = iAO(Symbol(),PERIOD_M1,2);
   Print(" iao 1 ",iao1);
   Print(" iao 2 ",iao2);
   Print(" iao 3 ",iao3);
   
   // iATR 平均真实范围 (Average True Range) 由一条真实的线标示 值越大多头 越小  空头
   double iatr1 = iATR(Symbol(),PERIOD_M1,14,0);
   double iatr2 = iATR(Symbol(),PERIOD_M1,14,1);
   double iatr3 = iATR(Symbol(),PERIOD_M1,14,2);
   Print("iatr = ",iatr1);
   Print("iatr = ",iatr2);
   Print("iatr = ",iatr3);
   
   // iBearsPower 熊势力度 (Bears Power)  该指标最好与趋势指标搭配使用 (最频繁的是移动均线):
   // 每天的交易如同推高价格的购买者 ("牛势") 和拉低价格的出售者 ("熊势") 之间的战斗。取决于哪一方得势，当天结束时的价格会高于或低于前一天的收盘价。中间结果，优先于最高价和最低价，能够判定日间的战斗是如何发展的。
   // 能够评估熊势力度的平衡极其重要，以为平衡的变化可初步表明可能的趋势逆转。该任务可使用 Alexander Elder 开发的熊势力度振荡器来解决，此指标在其名为《为生活而交易》一书中描述。Elder 根据以下前提推导出该振荡器:
   // 移动平均线是某一特定周期内买卖双方之间认同的价格。
   // 最低价格代表日内卖方力度最大。
   // 这些前提下，Elder 开发的熊势力度展现的是最低价与 13-周期指数移动平均线之间的差价 (LOW-EMA)。
   // 该指标最好与趋势指标搭配使用 (最频繁的是移动均线): 如果趋势指标向上而熊势力度指数低于零，但处于增长状态，这就是买入信号;
   // 这种情况下，更期待在指标图表里形成底部背离。
   double bears1 = iBearsPower(Symbol(),PERIOD_M1,13,PRICE_CLOSE,0);
   double bears2 = iBearsPower(Symbol(),PERIOD_M1,13,PRICE_CLOSE,1);
   double bears3 = iBearsPower(Symbol(),PERIOD_M1,13,PRICE_CLOSE,2);
  
  
   Print("bears1 = ",bears1);
   Print("bears2 = ",bears2);
   Print("bears3 = ",bears3);
   
   double bears4 = iBearsPower(Symbol(),PERIOD_M1,13,PRICE_OPEN,0);
   double bears5 = iBearsPower(Symbol(),PERIOD_M1,13,PRICE_OPEN,1);
   double bears6 = iBearsPower(Symbol(),PERIOD_M1,13,PRICE_OPEN,2);
   Print("bears1 = ",bears4);
   Print("bears2 = ",bears5);
   Print("bears3 = ",bears6);
  
   // iBullsPower 牛势力度 (Bulls Power)
   
    /*每天的交易如同推高价格的购买者 ("牛势") 和拉低价格的出售者 ("熊势") 之间的战斗。取决于哪一方得势，当天结束时的价格会高于或低于前一天的收盘价。中间结果，优先于最高价和最低价，能够判定日间的战斗是如何发展的。
能够评估牛势力度的平衡极其重要，以为平衡的变化可初步表明可能的趋势逆转。该任务可使用 Alexander Elder 开发的牛势力度振荡器来解决，此指标在其名为《为生活而交易》一书中描述。Elder 根据以下前提推导出该振荡器:
移动平均线是某一特定周期内买卖双方之间认同的价格。
最高价格代表日内买方力度最大。
这些前提下，Elder 开发的牛势力度展现的是最高价与 13-周期指数移动平均线之间的差价 (HIGH-EMA)。
该指标最好与趋势指标搭配使用 (最频繁的是移动均线):
如果趋势指标向下而牛势力度指数高于零，但处于下降状态，这就是卖出信号;
这种情况下，更期待在指标图表里形成峰顶背离。
   */
   double bull1 = iBullsPower(Symbol(),PERIOD_M1,13,PRICE_CLOSE,0);
   double bull2 = iBullsPower(Symbol(),PERIOD_M1,13,PRICE_CLOSE,1);
   double bull3 = iBullsPower(Symbol(),PERIOD_M1,13,PRICE_CLOSE,2);
   Print("牛势力度1 = ",bull1);
   Print("牛势力度2 = ",bull2);
   Print("牛势力度3 = ",bull3);
   
   // iCCI 商品通道指数 (Commodity Channel Index) 由一条平滑曲线标示
    /*
      商品通道指数技术指标 (CCI) 衡量商品价格与其平均统计价格的偏差值。该指数越高表明价格比之均值较高。越低说明价格比之均值过低。顾名思义，商品通道指数可应用于任何金融产品，不只限于商品。
      使用商品通道指数有两种基本的技巧:
      发现背离
      当价格抵达一个新的最大值，而商品通道指数未超过之前的最大值，则出现背离。这种典型的偏差通常伴随着价格的修正而发生。
      作为超买/超卖指标
      商品通道指数通常在 ±100 的范围内变化。大于+100 的数值表明过度买入（可能出现修正减小的可能性）小于-100的数值表示过度卖出了（可能出现修正增加的可能性）。 
   */
   double icc1 = iCCI(Symbol(),PERIOD_M1,14,PRICE_TYPICAL,0);
   double icc2 = iCCI(Symbol(),PERIOD_M1,14,PRICE_TYPICAL,1);
   double icc3 = iCCI(Symbol(),PERIOD_M1,14,PRICE_TYPICAL,2);
   Print("商品通道指数1 = ",icc1);
   Print("商品通道指数2 = ",icc2);
   Print("商品通道指数3 = ",icc3);
   
   
   
   // iDeMarker 迪马克 (DeMarker)
   /*
         迪马克技术指标 (DeM) 取当前周期最大值并与前一周期最大值进行比较。如果当前周期 (柱线) 数值较高，就登记两者间的差值。如果当前最大值低于或等于前一个周期的最大值，则登记空值。得到 N 个周期的差值后汇总，所得数值作为迪马克的分子，然后将其除以相同数值加上前一周期与当前周期 (柱线) 最小值的差值的总和。如果当前价格的最小值大于前一根柱线，则登记空值。
      当指标低于 30 时，可以期待牛势反转。当指高于 70 时，应期待熊势反转。
      如果您使用持续时间较长的周期，当计算指标值时，您就能够捕捉一个长线的行情趋势。若指标基于持续时间比较短的周期，可令您在一个风险较小的点位入场，并可以规划交易时间，使之与主要趋势一致。
   */
   
   double mark1 = iDeMarker(Symbol(),PERIOD_M1,14,0);
   double mark2 = iDeMarker(Symbol(),PERIOD_M1,14,1);
   double mark3 = iDeMarker(Symbol(),PERIOD_M1,14,2);
   Print("迪马克 1 = ",mark1);
   Print("迪马克 2 = ",mark2);
   Print("迪马克 3 = ",mark3);
   
   /*
      iForce： 推力指数 (Force Index)
      推力指数技术指标由 Alexander Elder 开发。该指数在每次递增时测量牛势力度，并在递减时测量熊势力度。它与最基本的市场信息要素相挂钩: 价格趋势，暴跌，和业务交易量。此指数可以按照原样使用, 但是最好使用 移动均线 进行近似。使用短线移动均线逼近 (作者建议使用间隔 2) 有助于发现开仓和平仓的最佳时机。如果使用长线移动均线 (周期 13) 进行逼近, 则指数体现出趋势变化。
      在指标上涨趋势的周期中，当指数变为负值时 (跌落低于零)，最好买入;
      当它升到一个新峰值时，指数发出上涨趋势会持续的信号;
      当指数在下降趋势期间变为正值时，卖出信号到来;
      当指数下降到一个深度时，它标志着熊势力度，且下跌趋势将持续;
      如果价格的变化与相应的交易量变化相不能匹配的话，推力指数仍旧保持在一个水平上，这就告诉您趋势很快就会变化。
      每个行情走势的推动力都是以其方向，比例和交易量为特征的。如果当前柱线的收盘价高于前一根，推力指数为正值。如果当前柱线的收盘价低于前一根，推力指数为负值。价格差异越大, 推力越大。交易量越大, 推力越大。
      ENUM_MA_METHOD：
      
      MODE_SMA
      0
      Simple averaging
      MODE_EMA
      1
      Exponential averaging
      MODE_SMMA
      2
      Smoothed averaging
      MODE_LWMA
   */
   double ifc1 = iForce(Symbol(),PERIOD_M1,12,MODE_SMA,PRICE_CLOSE,0);
   double ifc2 = iForce(Symbol(),PERIOD_M1,12,MODE_SMA,PRICE_CLOSE,1);
   double ifc3 = iForce(Symbol(),PERIOD_M1,12,MODE_SMA,PRICE_CLOSE,2);
   Print("推力指数 1 = ", ifc1);
   Print("推力指数 2 = ", ifc2);
   Print("推力指数 3 = ", ifc3);
   
   /*
         均线聚散 (MACD)
      
      均线聚合/发散 (MACD) 是趋势追随动态指标。它指明两条价格移动平均线的相关性。
      均线聚合/发散 (MACD) 技术指标是 26-周期和 12-周期的指数移动平均线 (EMA) 的差值。为了清晰地展示买入/卖出的机会，一条所谓的信号线 (9-周期指数移动平均线) 绘制在 MACD 图表上。
      在宽幅震荡的行情中，MACD 证明非常有效。MACD 有三种流行的运用方法: "交叉"，超买/超卖条件，和背离。
      交叉
      基本 MACD 交易规则就是当 MACD 下穿信号线时 (死叉) 卖出，类似地，当 MACD 上穿信号线时买入信号产生。当 MACD 在零轴上/下穿越时，买入/卖出也很受欢迎。
      超买/超卖条件
      MACD 也是一个非常有用的超买/超卖指标。当短期均线急剧偏离长期均线时 (即 MACD 上升)，品种价格有可能过度扩张，且可能很快会回到更为现实的价位上。
      背离
      当 MACD 与品种背离时，就意味着当前趋势结束的时刻邻近发生。当 MACD 指标创出新高，而价格未创新高时，牛势背离即会产生。当 MACD 指标创出新低时，而此刻价格未能达到新低，熊势背离产生。当这两种背离发生在超买/超卖价位时，它们具有非常重大的意义。
      
      MACD 的计算由 12-周期指数移动平均线减去 26-周期指数移动平均线。然后在 MACD 上绘制 9-周期简单移动平均线作为信号线 (虚线)。
      MACD = EMA(CLOSE, 12) - EMA(CLOSE, 26)
      SIGNAL = SMA(MACD, 9)
      其中:
      EMA ― 指数移动均线;
      SMA ― 简单移动均线;
      SIGNAL ― 指标的信号线。
   */
   double macd1 = iMACD(Symbol(),PERIOD_M1,12,26,9,PRICE_CLOSE,MODE_MAIN,0); 
   double macd2 = iMACD(Symbol(),PERIOD_M1,12,26,9,PRICE_CLOSE,MODE_MAIN,1); 
   double macd3 = iMACD(Symbol(),PERIOD_M1,12,26,9,PRICE_CLOSE,MODE_MAIN,2); 
   Print("MACD 1 = ", macd1);
   Print("MACD 2 = ", macd2);
   Print("MACD 3 = ", macd3);
   
   
   /*
      Momentum indicator 动量指标
      动量 (Momentum)
      动量技术指标衡量金融产品在给定时间跨度内的价格变化。有两种使用动量指标的基本方法:
      作为一种追随市场趋势的指标动量类似于移动平均线聚合/发散指标 (MACD)。 在这种情况下如果动量指标探底并反弹时产生买入信号；当它达到顶点又下落时，卖出信号出现。你可能想要画一个指标的短期移动平均线来决定何时探底或是上扬。
      动量指标的极高或者极低值表示当前趋势会持续。因此如果指标达到极高值然后下降，就可以预计下一步价格走势。无论如何，只有指标生成价格确认信号后才可以持仓或者平仓。
      作为一款领先指标。该方法假定上升趋势的最终阶段通常伴随快速的价格增长 (当所有人都期望价格走高时)，而在熊势末期则以价格快速下跌为特点 (当所有人都想出逃时)。这是常有的事，但这也只是泛泛而论。
      当行情接近峰值时，动量指标出现大幅跳水。 之后它开始下跌，而价格继续上涨或横向移动。与此类似，在行情底部动量急剧下降，然后在价格开始上涨之前反身向上很长时间。 这两种情况都会导致指标和价格之间出现背离。
        动量指标的计算就是本日价格和 n-周期前价格的比率:
      MOMENTUM = CLOSE (i) / CLOSE (i - n) * 100
      其中:
      CLOSE (i) ― 当前柱线的收盘价;
      CLOSE (i - n) ― n 根柱线以前的收盘价。
   */
   double im1 = iMomentum(Symbol(),PERIOD_M1,14,PRICE_CLOSE,0);
   double im2 = iMomentum(Symbol(),PERIOD_M1,14,PRICE_CLOSE,1);
   double im3 = iMomentum(Symbol(),PERIOD_M1,14,PRICE_CLOSE,2);
   Print("iMomentum 1 = ", im1);
   Print("iMomentum 2 = ", im2);
   Print("iMomentum 3 = ", im3);
   
   
   /*
      移动均线振荡器 (Moving Average of Oscillator)
      移动均线振荡器 (OsMA) 就是振荡器和振荡器平滑指标的差值。在这种情况下，MACD 基准线作为振荡器使用，而信号线用于平滑。
      
   */
 
   double iosma1 = iOsMA(Symbol(),PERIOD_M1,12,26,9,PRICE_CLOSE,0);
   double iosma2 = iOsMA(Symbol(),PERIOD_M1,12,26,9,PRICE_CLOSE,1);
   double iosma3 = iOsMA(Symbol(),PERIOD_M1,12,26,9,PRICE_CLOSE,2);
   Print("iOsMA 1 = ",iosma1);
   Print("iOsMA 2 = ",iosma2);
   Print("iOsMA 3 = ",iosma3);
   
   
   /*
         相对强度指数 (Relative Strength Index)
      
      相对强度指数技术指标 (RSI) 是一个价格追随振荡器，其取值范围在 0 和 100 之间。对于相对强度指数, J. W. Wilder 建议使用其 14-周期版本。自那时起，9-周期和 25-周期相对强度指数指标也非常流行。分析 RSI 指标的普遍方法是寻找证券创新高而 RSI 未超越前高的背离。这种背离是逆转迫在眉睫的一个指示。当相对强度指数下行并跌到最近的波谷以下时，它被称为 "衰退摆动"。衰退摆动被看做逆转迫近的确认。
      在图表分析中使用以下相对强度指数信号:
      顶部和底部
      相对强度指数通常顶部高于 70，而底部低于 30。它一般在构成价格图表之前形成这些顶部和底部。
      图表的形成
      RSI 常常形成图表形态，诸如头颈肩或三角形，这些形态不一定都能在价格图表上可见。
      衰退摆动 (支撑或阻力突破)
      此处相对强度指数会超过前高 (峰值)，或跌落到最近低点 (波谷) 之下。
      支撑或阻力价位
      相对强度指数有时比价格本身更清晰地显示支撑和阻力价位。
      背离
      如同上述讨论，当价格创出新高 (低)，而其并未由相对强度指数的新高 (低) 所确认的时候，背离就发生了。价格通常会调整并且沿着 RSI 指标方向前移。
         以下是相对强度指数的主公式:
      RSI = 100 - (100 / (1 + U / D))
      其中:
      U ― 价格变化正数值的平均值;
      D ― 价格变化负数值的平均值。
   */
   
   double irsi1 = iRSI(Symbol(),PERIOD_M1,14,PRICE_CLOSE,0);
   double irsi2 = iRSI(Symbol(),PERIOD_M1,14,PRICE_CLOSE,1);
   double irsi3 = iRSI(Symbol(),PERIOD_M1,14,PRICE_CLOSE,2);
   Print("iRSI 1 = ",irsi1);
   Print("iRSI 2 = ",irsi2);
   Print("iRSI 3 = ",irsi3);
   
   
   
   /*
      相对活力指数 (Relative Vigor Index)
      相对活力指数技术指标(RVI)的重要一点就是牛市上收盘价通常高于开盘价。熊市上正好相反。所以相对活力指数指标之后的原理就是价格收盘时确立指数移动的活力，或者能量。为了使得当日的交易范围指数正常化，我们根据当日价格范围的最大值来划分价格的变动情况。为了进行更为顺利的计算，使用 简单移动平均线 。10公认为最好的周期。为避免可能的混淆，需要构建一个信号线，该线是相对活力指数指标值的4-周期对称加权移动平均线。线与线的汇合被认为是购买或者是卖出的信号。
      RVI的计算类似于随机振荡指标 。然而，活力指数指标是用于收盘水平相对于开盘水平的比较，而不会完成随机最小价格。指标的计算为一段周期内指标值等于实际价格，并使该段周期价格变化最大范围标准化，例如天或者小时。
      RVI = (CLOSE - OPEN) / (HIGH - LOW)
      其中:
      OPEN ― 开盘价;
      HIGH ― 最高价;
      LOW ― 最低价;
      CLOSE ― 收盘价。
      通常 RVI 显示两条线:
      1. 第一条线的构建如同 RVI，但是取代收盘价和开盘价的差价，以及最高价和最低价的差价，使用 4-周期对称加权移动平均线的合计。即，计算分子的 4-周期对称加权移动平均线:
      MovAverage = (CLOSE-OPEN) + 2 * (CLOSE-1 - OPEN-1) + 2 * (CLOSE-2 - OPEN-2) + (CLOSE-3 - OPEN-3)
      其中:
      CLOSE - 当前收盘价;
      CLOSE-1, CLOSE-2, CLOSE-3 - 1, 2 和 3 周期之前的收盘价;
      OPEN - 当前开盘价;
      OPEN-1, OPEN-2, OPEN-3 - 1, 2 和 3 周期之前的开盘价。
      然后找出分母的 4-周期对称加权移动平均线:
      RangeAverage = (HIGH-LOW) + 2 x (HIGH-1 - LOW-1) + 2 x (HIGH-2 - LOW-2) + (HIGH-3 - LOW-3),
      其中:
      HIGH - 最后柱线的最高价;
      HIGH, HIGH-2, HIGH-3 - 1, 2 和 3 周期之前的最高价;
      LOW - 1, 2 和 3 周期之前的最低价;
      LOW-1, LOW-2, LOW-3 - 1, 2 和 3 周期之前的最低价。
      之后我们计算这些移动平均线最后 4 个周期的总和，例如小时或天:
      rvi_formula
      2. 第二条线是第一条线的 4-周期对称加权移动平均线:
      RVIsignal = (RVIaverage + 2 * RVIaverage-1 + 2 * RVIaverage-2 + RVIaverage-3)/6
   */
   double rvi1=iRVI(Symbol(),PERIOD_M1,10,MODE_MAIN,0);
   double rvi2=iRVI(Symbol(),PERIOD_M1,10,MODE_MAIN,1);
   double rvi3=iRVI(Symbol(),PERIOD_M1,10,MODE_MAIN,2);
   Print("RVI 1 = ",rvi1);
   Print("RVI 2 = ",rvi2);
   Print("RVI 3 = ",rvi3);
   
   /*
   随机振荡器 (Stochastic Oscillator)
   
   随机振荡器技术指标用证券的收盘价与给定时间周期内价格范围进行比较。随机振荡器显示为两条线。主线称为 %K。第二条线称为 %D，是 %K 的一条 移动均线。%K 线通常显示为实线，而 %D 线显示为虚线。有很多方法来解释随机振荡器。有三种流行方法包括:
   当振荡器 (或 %K 或 %D) 降至特定等级以下 (例如，20) 然后又回升到该等价以上，可以买入。当振荡器上到特定等级以上 (例如，80) 然后又回落到该等级以下，可以卖出。
   当 %K 线上涨高过 %D 则买入。当 %K 线下跌低于 %D 则卖出。
   寻找背离。比如：价格创出一系列新高，而随机振荡器未能突破其前高。
   
   
   */
   double iso1 = iStochastic(Symbol(),PERIOD_M1,5,3,3,MODE_SMA,0,MODE_MAIN,0);
   double iso2 = iStochastic(Symbol(),PERIOD_M1,5,3,3,MODE_SMA,0,MODE_MAIN,1);
   double iso3 = iStochastic(Symbol(),PERIOD_M1,5,3,3,MODE_SMA,0,MODE_MAIN,2);
   Print("iso  1 = ",iso1);
   Print("iso  2 = ",iso2);
   Print("iso  3 = ",iso3);
   
   /*
      威廉姆斯百分比范围

      威廉姆斯百分比范围技术指标 (%R) 是一款动态技术指标，其判断行情是否处于超买/超卖。威廉 %R 与随机振荡器十分相似。唯一的区别在于 %R 的标尺自顶至下，而随机振荡器有内部平滑。
      指标值若在 -80% 到 -100% 范围表示行情处于超卖。指标值若在 -0% 到 -20% 范围表示市场处于超买。为了按照自顶至下方式显示指标，在威廉姆斯百分比范围数值前加负号 (例如 -30%)。不过在进行分析的时候，应忽略负号。
      如同所有的超买/超卖指标，您在下单前最好等待品种价格改变方向。例如，如果超买超卖指标显示超买条件，则在抛售资产之前等待价格回落是明智之举。
      威廉姆斯百分比范围指标的一个有趣现象就是它具有预测基础证券价格逆转的神奇能力。指标几乎总会在证券价格到达峰值并回落的几天前就形成峰顶并反身回落。同样，威廉百分比范围通常会在证券价格回升的几天前形成一个波谷后反身回升。
   */
   double wpr1 = iWPR(Symbol(),PERIOD_M1,14,0);
   double wpr2 = iWPR(Symbol(),PERIOD_M1,14,1);
   double wpr3 = iWPR(Symbol(),PERIOD_M1,14,2);
   Print("wpr  1 = ",wpr1);
   Print("wpr  2 = ",wpr2);
   Print("wpr  3 = ",wpr3);
   
   /* iBands
      布林带 (Bollinger Bands®)
      
      布林带 (BB) 类似于轨道线。唯一的区别在于轨道线的带边线与移动平均线的距离 (%) 是固定的，而布林带则是采用某个距其的标准偏差数字来绘制。标准偏差是一种波动性测量值，因此布林带调整自身来适应行情状况。当行情不稳定时，布林带就会放宽，而在稳定期就会收缩。
      布林带通常绘制在价格图表上，但也能添加到指标图表。就像轨道线指标的情况，布林带的阐释基于价格趋于保持在波带的顶部界线和底部界线之间的事实。布林带指标的一个显著特征就是随着价格的波动，其宽度可变。在重大价格变化期间 (即，剧烈波动时) 带宽扩大为价格进入留有很多空间。在平静期，或低波动性期间，带宽收缩保持价格在它们的极限之内。
      以下特征是布林带特有的:
      由于波动性降低带宽收缩，易于发生价格突变;
      如果价格突破上边带，预期当前的趋势会延续;
      如果尖顶和深坑超出带宽之后又缩回带宽之内，也许趋势会逆转;
      若价格走势始自一条边带线，那么通常会到达相对一侧。
      最后的观察对于预测价格指导是有用的。
      布林带由三条线形成。中间线 (ML) 就是一条普通的移动平均线 。
      ML = SUM (CLOSE, N) / N = SMA (CLOSE, N)
      顶线 (TL) 是中线以相同标准偏差数向上移动。
      TL = ML + (D * StdDev)
      底线 (BL) 是中线以相同标准偏差数向下移动。
      BL = ML - (D * StdDev)
      其中:
      SUM (..., N) ― N 周期的总和;
      CLOSE ― 收盘价;
      N ― 计算所用的周期数;
      SMA ― 简单移动均线;
      SQRT ― 平方差;
      StdDev ― 标准偏差:
      StdDev = SQRT (SUM ((CLOSE �D SMA (CLOSE, N))^2, N)/N)
      推荐使用 20-周期简单移动平均线作为中线，并距此以两个标准偏差绘制顶边线和底边线。此外，小于 10 周期的移动平均线效果不佳。
   */
   double iband1 = iBands(Symbol(),PERIOD_M1,20,2,0,PRICE_CLOSE,MODE_LOWER,0);
   double iband2 = iBands(Symbol(),PERIOD_M1,20,2,0,PRICE_CLOSE,MODE_LOWER,1);
   double iband3 = iBands(Symbol(),PERIOD_M1,20,2,0,PRICE_CLOSE,MODE_LOWER,2);
   Print("iband1  1 = ",iband1);
   Print("iband1  2 = ",iband2);
   Print("iband1  3 = ",iband3);
   
   
   /*
      轨道线 (Envelopes) 由上下两条轨道线组成 价格接近上轨卖出 价格接近下轨买进
      
      轨道线技术指标由两条 移动平均线组成，一条向上偏移而另一条向下偏移。波带边距偏移的最佳相对数字由行情波动率来确定选择: 后者越高，偏移越强烈。
      轨道线定义了价格范围的上下边距。当价格抵达波带的上边缘时出现卖出信号; 当价格抵达下边缘出现买进信号。
      轨道线背后的逻辑就是过分兴奋的买家和卖家将价格推到了极值 (即，上边缘和下边缘)，在这一点价格通常会移到更现实的级别来稳定。这就类似于布林带 (BB) 的阐述。
   */
   double envelopes1 = iEnvelopes(Symbol(),PERIOD_M1,13,MODE_SMA,10,PRICE_CLOSE,0.2,MODE_UPPER,0);
   double envelopes2 = iEnvelopes(Symbol(),PERIOD_M1,13,MODE_SMA,10,PRICE_CLOSE,0.2,MODE_UPPER,1);
   double envelopes3 = iEnvelopes(Symbol(),PERIOD_M1,13,MODE_SMA,10,PRICE_CLOSE,0.2,MODE_UPPER,2);
   Print("envelopes1  1 = ",envelopes1);
   Print("envelopes1  2 = ",envelopes2);
   Print("envelopes1  3 = ",envelopes3);
   
   
   /*
   一目平衡表 (Ichimoku Kinko Hyo)

   一目平衡表技术指标预定义行情特征，趋势，支撑和阻力级别，以及生成买入和卖出信号。该指标在周线和日线图表中表现最好。
   定义参量维度时，使用 4 个不同长度的时间间隔。组成该指标的各自指示线的数值就是基于这些间隔:
   Tenkan-sen(红线) 显示的第一时间段的平均价格数值定义为此时间内最大值和最小值的合计，并除以二;
   Kijun-sen（蓝线） 显示的第二时间段的平均价格数值;
   Senkou 跨度 A() 显示前两条线间距的中值，并向前偏移第二个时间间隔的数值;
   Senkou 跨度 B 显示第三时间段的平均价格数值，并向前偏移第二个时间间隔的数值。
   Chikou 跨度显示当前柱线收盘价，并向后偏移第二个时间间隔的数值。Senkou 指示线的间距被赋予了其它颜色，并称为 "云"。如果价格处于这些指示线之间，那么行情应被认为是非趋势性的，随后，云的边缘形成了支撑和阻力级别。
   如果价格高于云，其上边缘形成第一级支撑，它的第二条指示线形成第二级支撑;
   如果价格低于云，则它的下边缘形成第一级阻力，它的上边缘形成第二级阻力;
   如果 Chikou 跨度指示线自底而上的方向贯穿价格图表，即为买入信号; 如果它自顶而下的方向贯穿价格图表，即为卖出信号。
   Kijun-sen用作行情走势指标。如果价格高于该指标，那么价格应很可能它继续增长。当价格横穿这条线时，可能会有更多的趋势变化。使用 Kijun-sen 的另一个作用就是发出各种信号。当 Tenkan-sen 线上穿 Kijun-sen 时, 买入信号就产生了。Tenkan-sen 被作为行情趋势指标。如果这条线增长或降低，则趋势存在。当它横向运动时，意即行情已经进入通道。
   */
    double tenkan_sen1 = iIchimoku(Symbol(),PERIOD_M1,9,26,52,MODE_TENKANSEN,0);
    double tenkan_sen2 = iIchimoku(Symbol(),PERIOD_M1,9,26,52,MODE_TENKANSEN,1);
    double tenkan_sen3 = iIchimoku(Symbol(),PERIOD_M1,9,26,52,MODE_TENKANSEN,2);
    Print("tenkan_sen1  1 = ",tenkan_sen1);
    Print("tenkan_sen2  2 = ",tenkan_sen2);
    Print("tenkan_sen3  3 = ",tenkan_sen3);
    
    /*
      iMA 移动平均线指标 由一条平滑曲线组成
      移动平均线技术指标显示某一个时间周期内产品的平均价格。当计算移动平均线的时候，是将这个时间周期内产品的价格摊平。由于价格的变化，移动平均线也会增长和降低。
      有四种不同类型的移动平均线: 简单移动平均线 (也被称为算术), 指数移动平均线, 平滑移动平均线 以及 加权移动平均线 。移动平均线可以针对任何连续的数据集进行计算，包括开盘价和收盘价，最高价和最低价，交易量或任何其它指标。还经常用到双重移动平均的情况。
      只有在一种情况下，不同种类的移动平均线会产生相当大的分歧，就是为后期的数据分配不同权重系数的情况。在 简单移动均线情况下, 问题涉及的所有时间周期内的价格权重相等。指数移动均线 和 线性加权移动均线 为后期价格分配更多的权重。
      解释价格平均移动的更普遍方法是就是将其与价格动作相比较。当产品价格上升到其移动平均线之上时，买入信号出现; 当价格回落到移动平均线以下时，我们所得到的是一个卖出信号。
      基于移动平均线的交易系统，并非设计用来在最低点入场，且在峰顶正确离场。它可以根据随后的趋势而动作: 价格抵达底部后尽快买入，并在价格触及峰顶后尽快卖出。
      移动平均线也应用于指标。指标移动平均线的解释类似于价格移动平均线: 如果指标涨过其移动平均线，意味着指标上升走势很可能延续; 如果指标跌过其移动平均线，意味着会持续走低。
      图表上是移动平均线的类型:
      简单移动平均线 (SMA)
      指数移动平均线 (EMA)
      平滑移动平均线 (SMMA)
      线形加权移动平均线 (LWMA)
    */
    double i1 = iMA(NULL,0,10,8,MODE_SMMA,PRICE_CLOSE,0);
    double i2 = iMA(NULL,0,10,8,MODE_SMMA,PRICE_CLOSE,1);
    double i3 = iMA(NULL,0,10,8,MODE_SMMA,PRICE_CLOSE,2);
    Print("iMA 1 = ",i1);
    Print("iMA 2 = ",i2);
    Print("iMA 3 = ",i3);
    
    
    /*
      抛物线转向[Parabolic Stop and Reverse system indicator] (Parabolic SAR) 
      抛物线转向技术指标的开发是用来分析趋势行情。该指标是在价格图表上构造的。该指标类似于移动平均线， 唯一的区别就是抛物线转向的移动具有较高的加速度，并依据价格立场而改变其位置。该指标在牛势行情里 (上行趋势) 低于价格，在熊势行清里 (下行趋势) 高于价格。
      如果价格穿越抛物线转向指示线，则指标反转，其未来数值位于价格的另一侧。当该指标的反转确实发生时，上一个时间段的最高和最低值将作为一个开始点。当该指标反转，它就会给出一个市场趋势结束或者是反转的信号（修正阶段或无波动阶段）。
      抛物线转向是一款杰出的提供离场点的指标。当价格下沉到低于转向指示线时，应将多头平仓; 当价格上涨高于转向指示线时，应将空头平仓。也就是说，有必要跟踪抛物线转向的方向，并保留与抛物线转向方向一致的持仓。该指标通常用作尾随止损线。
      如果开多头仓位 (即价格高于转向指示线)，抛物线转向总是向上运动，就不必在意价格取向。抛物线转向指示线的移动数额取决于价格走势的数值。
    */
    double isar1 = iSAR(Symbol(),PERIOD_M1,0.02,0.2,0);
    double isar2 = iSAR(Symbol(),PERIOD_M1,0.02,0.2,1);
    double isar3 = iSAR(Symbol(),PERIOD_M1,0.02,0.2,2);
    Print("isar1 = ",isar1);
    Print("isar2 = ",isar2);
    Print("isar3 = ",isar3);
    
    /*
      标准偏差 (Standard Deviation)
      标准偏差是行情波动率衡量数值。该指标是对移动平均线价格涨落变化的描述。所以，如果指标的价值为高，市场不稳定，价格柱将会随着移动平均线而涨落。如果指标的价值为低，市场的浮动则会降低，价格柱也会随着移动平均线涨落。
      正常情况下，该指标作为其它指标的组成部分使用。对于 布林带 (Bollinger Bands®) 的计算,
      该品种的标准偏差值被加入其 移动均线。
      市场行为表现为交易活跃与疲软互现。所以，该指标很容易解释:
      如果其值太低，即，市场毫无生气，所以期待不久就会出现暴涨;
      否则，如果其值极高，则意味着活力不久就会降温。
    */
    
    double istddev1 = iStdDev(Symbol(),PERIOD_M1,20,0,MODE_EMA,PRICE_CLOSE,0);
    double istddev2 = iStdDev(Symbol(),PERIOD_M1,20,0,MODE_EMA,PRICE_CLOSE,1);
    double istddev3 = iStdDev(Symbol(),PERIOD_M1,20,0,MODE_EMA,PRICE_CLOSE,2);
    Print("istddev1 = ",istddev1);
    Print("istddev2 = ",istddev2);
    Print("istddev3 = ",istddev3);
    
    /*
    iMFI
    资金流动指数 (Money Flow Index)
    资金流动指数 (MFI) 是一款技术指标，表示资金投入证券并回笼的速率。该指标的构造和解释与相对强度指数类似，仅有的区别在于: 交易量对于 MFI 是极其重要。
    当分析资金流动指数时，必须考虑下列几点:
    指标和价格走势的背离。如果价格上升而指标下降的话 (反之亦然)，则价格转折的概率很大;
    资金流动指数的值，如果超过 80 或者是低于 20，信号分别对应于行情的潜在峰顶或谷底。
    */
    double imfi1 = iMFI(Symbol(),PERIOD_M1,14,0);
    double imfi2 = iMFI(Symbol(),PERIOD_M1,14,1);
    double imfi3 = iMFI(Symbol(),PERIOD_M1,14,2);
    
    Print("imfi1 = ",imfi1);
    Print("imfi2 = ",imfi2);
    Print("imfi3 = ",imfi3);
    
    
    /*
      能量潮 (On Balance Volume)
   
      能量潮技术指标 (OBV) 是一款动量技术指标，表示成交量相对于价格变化。该指标由 Joseph Granville 发起，且相当简单。如果当前柱线的收盘价高于前一根柱线，当前柱线的交易量就会加入前一个 OBV 中。如果当前柱线收盘价低于前一根柱线，就从前一个 OBV 当中减去当前交易量。
      关于能量潮分析，一个最基本的假设是: OBV 额变化先于价格的变化。该理论认为，通过上升的 OBV，可以看到热钱流入该证券。当公众涌入该证券时，证券和能量潮均会激增。
      如果证券的价格走势先于 OBV 走势，"非确认" 将会发生。非确认会出现在牛势顶部 (那时证券上涨无需或先于 OBV)，或熊势底部 (那时证券下跌无需或先于能量潮技术指标)。
      当 OBV 处于上升趋势中，每个新峰值均高于前一个，或每个新低谷都高于前一个。同样，当能量潮处于下跌趋势中，每个连续顶点都低于前一个，或每个连续低谷都低于前一个。当 OBV 窄幅震荡前行，且无连续高点和低点时，则其处于犹豫趋势。
      趋势一旦建立，它会强行持续，直至被打破。有两种打破能量潮趋势的方法。第一种就是从涨势向跌势变化，或从跌势向涨势转变。
      第二种打破 OBV 趋势的方法就是趋势向犹豫趋势转变，且保持 3 天以上。因此，如果证券从涨势转变为犹豫趋势，且在重返升势之前仅维持了两天徘徊，则能量潮认为升势仍将持续。当 OBV 向涨势或跌势转变，会发生 "突破"。
      因为 OBV 突破通常先于价格突破，投资者应该在能量潮向上突破时买进多头。同样，投资者在 OBV 向下突破时，卖出空头。持仓应保留到趋势变化。
      如果当前收盘价高于前一个，则:
      OBV (i) = OBV (i - 1) + VOLUME (i).
      如果当前收盘价低于前一个，则:
      OBV (i) = OBV (i - 1) - VOLUME (i)
      如果当前收盘价等于前一个，则:
      OBV (i) = OBV (i - 1)
      其中:
      OBV (i) ― 当前周期的能量潮指标数值;
      OBV (i - 1) ― 前一周期的能量潮指标数值;
      VOLUME (i) ― 当前柱线的交易量。
    */ 
    
    double iobv1 = iOBV(Symbol(),PERIOD_M1,PRICE_CLOSE,0);
    double iobv2 = iOBV(Symbol(),PERIOD_M1,PRICE_CLOSE,1);
    double iobv3 = iOBV(Symbol(),PERIOD_M1,PRICE_CLOSE,2);
    Print("iobv1 = ",iobv1);
    Print("iobv2 = ",iobv2);
    Print("iobv3 = ",iobv3);
    
    /*
    
      市场促进指数技术指标 (BW MFI) 是显示分笔报价中价格变化的指标。指标绝对值不代表任何含义，只有指标的变化才有意义。比尔.威廉姆斯强调 MFI 和交易量的相互变化:
      市场促进指数增长且交易量增加 – 这一点表明: a) 入场交易的人气增长 (交易量增长) b) 新来的人员遵照柱线发展方向开仓，即，走势已开始并加快速度。
      市场促进指数下降，且交易量也下降。意即市场参与者不再有兴趣。
      市场促进指数增长，但是交易量下降。最有可能的就是，行情未受到来自交易者成交量的支持，而价格由于"场内交易员" (经纪商或交易员) 的投机而改变。
      市场促进指数下降，但是交易量增长。这是一场多空双方之间的战争，其特征是，买卖交易量巨大，但由于两股势力相当，价格变化不明显。最终买卖双方当中的一方会赢得战争的胜利。通常，一根柱线突破令您知晓这根柱线决定了行情趋势延续，亦或趋势终止。比尔.威廉姆斯称之为 "行屈膝礼"。
      要计算市场促进指数，您需要从柱线的最高价中减去最低价，并除以交易量。
      BW MFI = (HIGH - LOW) / VOLUME
      其中:
      HIGH ― 当前柱线最高价;
      LOW ― 当前柱线最低价;
      VOLUME ― 当前柱线交易量。
   
    */
    double ibwmfi1 = iBWMFI(Symbol(),10,0);
    double ibwmfi2 = iBWMFI(Symbol(),10,1);
    double ibwmfi3 = iBWMFI(Symbol(),10,2);
    Print("ibwmfi1 = ",ibwmfi1);
    Print("ibwmfi2 = ",ibwmfi2);
    Print("ibwmfi3 = ",ibwmfi3);
    
    
    
  }
//+------------------------------------------------------------------+
