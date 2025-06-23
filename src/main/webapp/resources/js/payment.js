function requestPayment(options, callback) {
    if (!window.IMP) {
        alert("아임포트 라이브러리가 로드되지 않았습니다.");
        return;
    }
    var IMP = window.IMP;
    IMP.init(options.impCode);

    console.log("impCode:", options.impCode);

    IMP.request_pay({
        pg: options.pg || 'html5_inicis',
        pay_method: options.pay_method || 'card',
        merchant_uid: options.merchant_uid || ('merchant_' + new Date().getTime()),
        name: options.name || '상품명',
        amount: options.amount || 0,
        buyer_email: options.buyer_email || '',
        buyer_name: options.buyer_name || '',
        buyer_tel: options.buyer_tel || '',
        // 필요시 추가 옵션
    }, callback);
} 